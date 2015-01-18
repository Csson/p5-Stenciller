use 5.14.0;
use strict;
use warnings;

use Stenciller::Wrap;

package Stenciller;

# VERSION:
# PODCLASSNAME:
# ABSTRACT: Transforms a flat file format to different output

sub new {
    shift;
    Stenciller::Wrap->new(@_);
}
sub meta {
    Stenciller::Wrap->meta;
}

1;

__END__

=pod

:splint classname Stenciller::Wrap

=head1 SYNOPSIS

    use Stenciller;
    my $stenciller = Stenciller->new(filepath => 't/corpus/test-1.stencil');
    my $content = $stenciller->transform('ToUnparsedText');

=head1 DESCRIPTION

Stenciller reads a special fileformat and provides a way to convert the content into different types of output. For example, it can be used to create documentation and tests from the same source file.

=head2 File format

    == stencil {} ==

    --input--

    --end input--

    --output--

    --end output--

This is the basic layout. A stencil ends when a new stencil block is discovered (there is no set limit to the number of stencils in a file). The (optional) hash is for settings. Each stencil has five parts: C<before_input>, C<input>, C<between>, C<output> and C<after_output>. In addition to this
there is a header before the first stencil.

=head1 ATTRIBUTES

:splint attributes

=head1 METHODS

:splint method transform

=head1 PLUGINS

The actual transforming is done by plugins. There are two plugins bundled in this distribution:

=for :list
* L<Stenciller::Plugin::ToUnparsedText>
* L<Stenciller::Plugin::ToHtmlPreBlock>

Custom plugins should be in the L<Stenciller::Plugin> namespace and consume the L<Stenciller::Transformer> role.

=cut
