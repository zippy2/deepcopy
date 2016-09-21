#!/usr/bin/perl
#
# Copyright (C) 2016 Red Hat, Inc.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library.  If not, see
# <http://www.gnu.org/licenses/>.
#
# Authors:
#       Michal Privoznik <mprivozn@redhat.com>
#

use strict;
use warnings;
use Data::Dumper;

my %structs;

# check whether struct in %structs is defined and if so whether it already
# contains a member
# $1 -> struct name
# $2 -> member name
sub check_duplicates {
    my $structName = shift;
    my $member = shift;
    if (not defined $structs{$structName}) {
        return 0;
    }
    for my $m (@{$structs{$structName}}) {
        if ($m->{member} eq $member) {
            return 1;
        }
    }
    return 0;
}

sub generate_header {
    foreach my $structName (sort { $a cmp $b } keys %structs) {
        my $struct = $structs{$structName};
        print "\nstruct $structName {\n";
        for my $m (@{$struct}) {
            print "    $m->{type} $m->{member};\n";
        }
        print "};\n";
    }
}

sub generate_copy {
    foreach my $structName (sort { $a cmp $b } keys %structs) {
        my $struct = $structs{$structName};
        print "\nint\n";
        print "${structName}Copy(struct ${structName} *dst, const struct ${structName} *src)\n";
        print "{\n";
        for my $m (@{$struct}) {
            if ($m->{type} =~ m/^(int|char|double|float)$/) {
                print "    dst->$m->{member} = src->$m->{member};\n";
            } elsif (defined $structs{$m->{type}}) {
                print "    if ($m->{type}Copy(&dst->$m->{member}, &src->$m->{member}) < 0)\n";
                print "        return -1;\n";
            } else {
                die("Unhandled type $m->{type}");
            }
        }
        print "    return 0;\n";
        print "};\n";
    }
}

my $in_struct = 0;
my $structName;

while (<>) {
    if (m/^struct (\S*)$/) {
        $in_struct = 1;
        $structName = $1;
        next;
    } elsif (m/^\s+(\S+)\s+(\S+);$/) {
        die ("Syntax error on line $.") unless $in_struct;
        my $type = $1;
        my $member = $2;
        my %rec;
        ${rec}{type} = $1;
        ${rec}{member} = $2;
        if (check_duplicates($structName, $member)) {
            die("Duplicate member $member in struct $structName at line $.");
        }
        push (@{${structs}{$structName}}, \%rec);
    } elsif (m/^\n$/) {
        $in_struct = 0;
        next;
    } else {
        die ("Syntax error on line $.");
    }
}

#print Dumper(\%structs);
generate_header();
generate_copy();
