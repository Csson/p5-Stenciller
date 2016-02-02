use 5.10.1;
use strict;
use warnings;

package Types::Stenciller;

# VERSION
# ABSTRACT: Types for Stenciller

use Type::Library -base, -declare => qw/Stencil Stenciller/;
use Type::Utils -all;

class_type Stenciller => { class => 'Stenciller' };
class_type Stencil    => { class => 'Stenciller::Stencil' };

1;

=pod

:splint classname Types::Stenciller

=head1 SYNOPSIS

    use Types::Stenciller -types;

=head1 DESCRIPTION

Defines a couple of types used in the C<Stenciller> namespace.

=head1 TYPES

=for :list
* C<Stenciller> is a L<Stenciller>
* C<Stencil> is a L<Stenciller::Stencil>

It also inherits from L<Types::Standard> and L<Types::Path::Tiny>.

=cut
