use 5.14.0;
use warnings;

use Moops;

# VERSION
# PODNAME:
library Types::Stenciller

extends Types::Standard, Types::TypeTiny, Types::Path::Tiny

declares Stencil, Renderer, Stenciller

{

    class_type Stenciller => { class => 'Stenciller' };
    class_type Stencil    => { class => 'Stenciller::Stencil' };

}

1;

=pod

:splint classname Types::Stenciller

=head1 SYNOPSIS

    use Types::Stenciller -types;

=head1 DESCRIPTION

Defines a few types used in the C<Stenciller> namespace.

=head1 TYPES

=for :list

* C<Stencil> is a L<Stenciller::Stencil>
* C<Stenciller> is a L<Stenciller>

=cut
