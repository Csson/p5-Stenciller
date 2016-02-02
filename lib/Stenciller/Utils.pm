use 5.10.1;
use strict;
use warnings;

package Stenciller::Utils;

# VERSION:

use Moose::Role;

sub eval_to_hashref {
    my $self = shift;
    my $possible_hash = shift; # Str
    my $faulty_file = shift;   # Path|Str

    my $settings = eval $possible_hash;
    die sprintf "Can't parse stencil start: <%s> in %s: %s", $possible_hash, $faulty_file, $@ if $@;
    return $settings;
}

1;
