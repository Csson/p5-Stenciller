use Stenciller::Standard;

# VERSION
# ABSTRACT: A plugin that just renders all the text
# PODCLASSNAME:

class Stenciller::Plugin::ToUnparsedText using Moose with Stenciller::Renderer {

    method render {
        my @out = ();

        STENCIL:
        foreach my $stencil ($self->stenciller->all_stencils) {
            push @out => $stencil->all_before_input;
            push @out => $stencil->all_input;
            push @out => $stencil->all_between;
            push @out => $stencil->all_output;
            push @out => $stencil->all_after_output;
        }
        return join "\n" => @out;
    }
}

1;

=pod

:splint classname Stenciller::Plugin::ToUnparsedText

=head1 SYNOPSIS

    use Stenciller;
    my $stenciller = Stenciller->new(filepath => 't/corpus/test-1.stencil');
    my $content = $stenciller->render('ToUnparsedText');

=head1 DESCRIPTION

This plugin to L<Stenciller> basically returns all text content of the stencils.

=cut
