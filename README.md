# NAME

Stenciller - Transforms a flat file format to different output

# VERSION

Version 0.1203, released 2015-01-18.

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

## filepath

## is\_utf8

## skip\_if\_input\_empty

## skip\_if\_output\_empty

## header\_lines

## stencils

# METHODS

## transform

# PLUGINS

The actual transforming is done by plugins. There are two plugins bundled in this distribution:

- [Stenciller::Plugin::ToUnparsedText](https://metacpan.org/pod/Stenciller::Plugin::ToUnparsedText)
- [Stenciller::Plugin::ToHtmlPreBlock](https://metacpan.org/pod/Stenciller::Plugin::ToHtmlPreBlock)

Custom plugins should be in the [Stenciller::Plugin](https://metacpan.org/pod/Stenciller::Plugin) namespace and consume the [Stenciller::Transformer](https://metacpan.org/pod/Stenciller::Transformer) role.

# SOURCE

[https://github.com/Csson/p5-Stenciller](https://github.com/Csson/p5-Stenciller)

# HOMEPAGE

[https://metacpan.org/release/Stenciller](https://metacpan.org/release/Stenciller)

# AUTHOR

Erik Carlsson <info@code301.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Erik Carlsson <info@code301.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
