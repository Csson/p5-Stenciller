use Stenciller::Standard;

# VERSION
# ABSTRACT: A plugin that renders to html
# PODCLASSNAME:

class Stenciller::Plugin::ToHtmlPreBlock using Moose with Stenciller::Renderer {

    use HTML::Entities 'encode_entities';

    has stenciller => (
        is => 'ro',
        isa => Stenciller,
        required => 1,
    );

    method render {
        my @out = ();

        STENCIL:
        foreach my $stencil ($self->stenciller->all_stencils) {

            push @out => $self->normal($stencil->all_before_input);
            push @out => $self->pre($stencil->all_input);
            push @out => $self->normal($stencil->all_between);
            push @out => $self->pre($stencil->all_output);
            push @out => $self->normal($stencil->all_after_output);

        }
        return join '' => @out;
    }

    method normal(@lines) {
        return () if !scalar @lines;
        return join "\n" => '<p>', @lines, '</p>';
    }

    method pre(@lines) {
        return () if !scalar @lines;

        my @encoded_lines = map {  encode_entities($_) } @lines;
        return  join "\n" => '<pre>', @encoded_lines, '</pre>';
    }
}

1;

__END__

=pod

:splint classname Stenciller::Plugin::ToHtmlPreBlock

=head1 SYNOPSIS

    use Stenciller;
    my $stenciller = Stenciller->new(filepath => 't/corpus/test-1.stencil');
    my $content = $stenciller->render('ToHtmlPreBlock');

=head1 DESCRIPTION

This plugin to L<Stenciller> places the C<before_input>, C<between> and C<after_output> regions in C<E<lt>pE<gt>> tags and the C<input> and C<output> regions inside C<E<lt>preE<gt>> tags.

=cut

