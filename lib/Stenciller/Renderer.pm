use Stenciller::Standard;

# VERSION
# ABSTRACT: A role for transformer plugins to consume
# PODCLASSNAME

role Stenciller::Renderer using Moose {

    requires 'render';

}

1;


=pod

:splint classname Stenciller::Renderer

=head1 SYNOPSIS

    package Some::Place::MyNewRenderer;

    use Moose;
    with 'Stenciller::Renderer';

    sub render {
        ...
    }

=head1 DESCRIPTION

This is the role that everything that renders something that a L<Stenciller::Transformer> plugin has transformed must consume. It requires a C<render> method to be implemented.

=head1 ATTRIBUTES

Attributes can differ between consumers.

=cut
