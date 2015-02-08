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

    my @out = $self->init_out($self->stenciller, $transform_args);

    STENCIL:
    for my $i (0 .. $self->stenciller->max_stencil_index) {
        next STENCIL if $self->should_skip_stencil_by_index($i, $transform_args);

        my $stencil = $self->stenciller->get_stencil($i);
        next STENCIL if $self->should_skip_stencil($stencil, $transform_args);

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

=head1 METHODS

=head2 transform

See L<transform|Stenciller::Transformer/"transform"> in L<Stenciller::Transformer>.


=cut
