use 5.14.0;
use warnings;

use Moops;

# VERSION:
# PODCLASSNAME:
# ABSTRACT: Types for Stenciller

library Types::Stenciller

extends Types::Standard, Types::Path::Tiny

{

    class_type Stenciller => { class => 'Stenciller::Wrap' };
    class_type Stencil    => { class => 'Stenciller::Stencil' };

}

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
