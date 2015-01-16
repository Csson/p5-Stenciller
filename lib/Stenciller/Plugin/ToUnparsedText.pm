use Stenciller::Standard;

# VERSION
# ABSTRACT: A plugin that doesn't transforme the text the text
# PODCLASSNAME:

class Stenciller::Plugin::ToUnparsedText using Moose with Stenciller::Transformer {

    method transform {
        my @out = ($self->stenciller->all_header_lines);

        STENCIL:
        foreach my $stencil ($self->stenciller->all_stencils) {
            push @out => $stencil->all_before_input,
                         $stencil->all_input,
                         $stencil->all_between,
                         $stencil->all_output,
                         $stencil->all_after_output;
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
    my $content = $stenciller->transforme('ToUnparsedText');

=head1 DESCRIPTION

This plugin to L<Stenciller> basically returns all text content of the stencils.

=cut
