use 5.14.0;
use strict;
use warnings;

package Stenciller::Plugin::ToUnparsedText;
# VERSION:
# ABSTRACT: A plugin that doesn't transform the text

use Moose;
use List::AllUtils qw/first_index/;
with 'Stenciller::Transformer';

sub transform {
    my $self = shift;
    my $transform_args = shift;

    my @out = ('');
    push (@out => $self->stenciller->all_header_lines, '') if !$transform_args->{'skip_header_lines'};

    STENCIL:
    for my $i (0 .. $self->stenciller->count_stencils - 1) {
        next STENCIL if exists $transform_args->{'stencils'} && -1 == first_index { $_ == $i } @{ $transform_args->{'stencils'} };

        my $stencil = $self->stenciller->get_stencil($i);
        push @out => '',
                     $stencil->all_before_input, '',
                     $stencil->all_input, '',
                     $stencil->all_between, '',
                     $stencil->all_output, '',
                     $stencil->all_after_output, '';
    }
    my $content = join "\n" => '', @out, '';
    $content =~ s{[\r?\n]{2,}}{\n\n}g;
    return $content;
}

1;

__END__

=pod

:splint classname Stenciller::Plugin::ToUnparsedText

=head1 SYNOPSIS

    use Stenciller;
    my $stenciller = Stenciller->new(filepath => 't/corpus/test-1.stencil');
    my $content = $stenciller->transform('ToUnparsedText');

=head1 DESCRIPTION

This plugin to L<Stenciller> basically returns all text content of the stencils.

=head1 METHODS

:splint method transform

The currently available keys in the C<$transform_args> hash ref is:

B<C<skip_header_lines =E<gt> 1>>

C<skip_header_lines> takes a boolean indicating if the L<Stenciller's|Stenciller> header_lines should be skipped. Default is C<0>.

B<C<stencils =E<gt> [ ]>>

C<stencils> takes an array reference of which stencils in the currently parsed file that should be included in the output. The index is zero based.

If this plugin is used via L<Pod::Elemental::Transformer::Stenciller> it could be used like this in pod:

    =pod

    # includes header_lines and all stencils
    :stenciller ToUnparsedText atestfile-1.stencil

    # includes header_lines and all stencils
    :stenciller ToUnparsedText atestfile-1.stencil { }

    # includes only the first stencil in the file
    :stenciller ToUnparsedText atestfile-1.stencil { stencils => [0], skip_header_lines => 1 }

    # includes only the header_lines
    :stenciller ToUnparsedText atestfile-1.stencil { stencils => [] }


=cut
