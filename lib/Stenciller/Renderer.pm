use Stenciller::Standard;

# VERSION
# ABSTRACT: ...
# PODNAME:

role Stenciller::Renderer using Moose {

    requires 'render';

    has stenciller => (
        is => 'ro',
        isa => Stenciller,
        required => 1,
    );
}

1;


=pod

:splint classname Stenciller::Renderer

=head1 SYNOPSIS

    package Stenciller::Plugin::MyNewRenderer;

    use Moose;
    with 'Stenciller::Renderer';

    sub render {
        ...
    }

=head1 DESCRIPTION

This is the role that all L<Stenciller> plugins must consume. It requires a C<render> method to be implemented.

=head1 ATTRIBUTES

=head2 stenciller

The L<Stenciller> object is passed automatically to plugins.

=cut
