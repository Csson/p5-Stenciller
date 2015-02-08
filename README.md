:splint classname Stenciller::Wrap

# SYNOPSIS

    use Stenciller;
    my $stenciller = Stenciller->new(filepath => 't/corpus/test-1.stencil');
    my $content = $stenciller->transform('ToUnparsedText');

# DESCRIPTION

Stenciller reads a special fileformat and provides a way to convert the content into different types of output. For example, it can be used to create documentation and tests from the same source file.

## File format

    == stencil {} ==

    --input--

    --end input--

    --output--

    --end output--

This is the basic layout. A stencil ends when a new stencil block is discovered (there is no set limit to the number of stencils in a file). The (optional) hash is for settings. Each stencil has five parts: `before_input`, `input`, `between`, `output` and `after_output`. In addition to this
there is a header before the first stencil.

# ATTRIBUTES

:splint attributes

# METHODS

:splint method transform

# PLUGINS

The actual transforming is done by plugins. There are two plugins bundled in this distribution:

Custom plugins should be in the [Stenciller::Plugin](https://metacpan.org/pod/Stenciller::Plugin) namespace and consume the [Stenciller::Transformer](https://metacpan.org/pod/Stenciller::Transformer) role.
