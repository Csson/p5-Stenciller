use 5.14.0;
use strict;
use warnings;

package Stenciller::Plugin::ToHtmlPreBlock;

# VERSION:
# ABSTRACT: A plugin that transforms to html

use Moose;
use List::AllUtils qw/first_index/;
with 'Stenciller::Transformer';

use Types::Standard qw/Bool Str Maybe/;
use MooseX::AttributeShortcuts;
use HTML::Entities 'encode_entities';

has output_also_as_html => (
    is => 'ro',
    isa => Bool,
    default => 0,
);
has separator => (
    is => 'ro',
    isa => Maybe[Str],
    predicate => 1,
);


sub transform {
    my $self = shift;
    my $transform_args = shift;

    my @out = $self->init_out($self->stenciller, $transform_args);

    STENCIL:
    for my $i (0 .. $self->stenciller->max_stencil_index) {
        next STENCIL if $self->should_skip_stencil_by_index($i, $transform_args);

        my $stencil = $self->stenciller->get_stencil($i);
        next STENCIL if $self->should_skip_stencil($stencil, $transform_args);

        push @out => $self->normal($stencil->all_before_input),
                     $self->pre($stencil->all_input),
                     $self->normal($stencil->all_between),
                     $self->pre($stencil->all_output),
                     $self->output_also_as_html ? $self->normal([$stencil->all_output]) : (),
                     $self->normal($stencil->all_after_output),
                     $self->has_separator && $i < $self->stenciller->max_stencil_index ? $self->separator : ();

    }
    return join "\n" => @out;
}

sub normal {
    my $self = shift;
    my @lines = @_;

    return () if !scalar @lines;
    my $tag = 'p';
    if(ref $lines[0] eq 'ARRAY') {
        $tag = 'div';
        @lines = @{ $lines[0] };
    }
    return join '' => ("<$tag>", join ('' => @lines), "</$tag>");
}
sub pre {
    my $self = shift;
    my @lines = @_;

    my @encoded_lines = map { $_ =~ s{^ {4}}{}; encode_entities($_) } @lines;
    return join '' => ('<pre>', join ("\n" => @encoded_lines), '</pre>');
}

1;

__END__

=pod

:splint classname Stenciller::Plugin::ToHtmlPreBlock

=head1 SYNOPSIS

    use Stenciller;
    my $stenciller = Stenciller->new(filepath => 't/corpus/test-1.stencil');
    my $content = $stenciller->transform('ToHtmlPreBlock');

=head1 DESCRIPTION

This plugin to L<Stenciller> places the C<before_input>, C<between> and C<after_output> regions in C<E<lt>pE<gt>> tags and the C<input> and C<output> regions inside C<E<lt>preE<gt>> tags.

Content that will be placed in C<pre> tags (input and output sections in stencils) also have four leading spaces removed.

=head1 ATTRIBUTES

=head2 output_also_as_html

Default: C<0>

If set to a true value, the contents of C<output> in stencils is rendered as html (directly following the pre-block).

=head2 separator

Default: C<undef>

When set, this text is used to separate two stencils.

=head1 METHODS

=head2 transform

See L<transform|Stenciller::Transformer/"transform"> in L<Stenciller::Transformer>.

=cut
