use Stenciller::Standard;

# VERSION
# ABSTRACT: A role for transformer plugins to consume
# PODCLASSNAME

role Stenciller::Transformer using Moose {

    requires 'transformer';

    has stenciller => (
        is => 'ro',
        isa => Stenciller,
        required => 1,
    );
}

1;


=pod

:splint classname Stenciller::Transformer

=head1 SYNOPSIS

    package Stenciller::Plugin::MyNewRenderer;

    use Moose;
    with 'Stenciller::Transformer';

    sub transformer {
        ...
    }

=head1 DESCRIPTION

This is the role that all L<Stenciller> plugins must consume. It requires a C<transformer> method to be implemented.

=head1 ATTRIBUTES

=head2 stenciller

The L<Stenciller> object is passed automatically to plugins.

=cut
