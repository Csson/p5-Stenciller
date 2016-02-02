# NAME

Stenciller - Transforms a flat file format to different output

![Requires Perl 5.10.1+](https://img.shields.io/badge/perl-5.10.1+-brightgreen.svg) [![Travis status](https://api.travis-ci.org/Csson/p5-Stenciller.svg?branch=master)](https://travis-ci.org/Csson/p5-Stenciller) ![coverage 91.0%](https://img.shields.io/badge/coverage-91.0%-yellow.svg)

# VERSION

Version 0.1303, released 2016-02-02.

# SYNOPSIS

    use Stenciller;
    my $stenciller = Stenciller->new(filepath => 't/corpus/test-1.stencil');
    my $content = $stenciller->transform(plugin_name => 'ToUnparsedText');

# DESCRIPTION

Stenciller reads a special fileformat and provides a way to convert the content into different types of output. For example, it can be used to create documentation and tests from the same source file.

## File format

    == stencil {} ==

    --input--

    --end input--

    --output--

    --end output--

This is the basic layout. A stencil ends when a new stencil block is discovered (there is no fixed limit to the number of stencils in a file). The (optional) hash is for settings. Each stencil has five parts: `before_input`, `input`, `between`, `output` and `after_output`. In addition to this
there is a header before the first stencil.

# ATTRIBUTES

## filepath

<table cellpadding="0" cellspacing="0">
<tr>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;"><a href="https://metacpan.org/pod/Types::Path::Tiny#File">File</a></td>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;">required</td>
    <td style="padding-left: 6px; padding-right: 6px; white-space: nowrap;">read-only</td>
</tr>
</table>

<p>The textfile to parse.</p>

## is\_utf8

<table cellpadding="0" cellspacing="0">
<tr>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;"><a href="https://metacpan.org/pod/Types::Standard#Bool">Bool</a></td>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;">optional, default: <code>1</code></td>
    <td style="padding-left: 6px; padding-right: 6px; white-space: nowrap;">read-only</td>
</tr>
</table>

<p>Determines how the stencil file is read.</p>

## skip\_if\_input\_empty

<table cellpadding="0" cellspacing="0">
<tr>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;"><a href="https://metacpan.org/pod/Types::Standard#Bool">Bool</a></td>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;">optional, default: <code>1</code></td>
    <td style="padding-left: 6px; padding-right: 6px; white-space: nowrap;">read-only</td>
</tr>
</table>

<p>If a stencil has no input content, skip entire stencil.</p>

## skip\_if\_output\_empty

<table cellpadding="0" cellspacing="0">
<tr>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;"><a href="https://metacpan.org/pod/Types::Standard#Bool">Bool</a></td>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;">optional, default: <code>1</code></td>
    <td style="padding-left: 6px; padding-right: 6px; white-space: nowrap;">read-only</td>
</tr>
</table>

<p>If a stencil has no output content, skip entire stencil.</p>

## header\_lines

<table cellpadding="0" cellspacing="0">
<tr>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;"><a href="https://metacpan.org/pod/Types::Standard#ArrayRef">ArrayRef</a> [ <a href="https://metacpan.org/pod/Types::Standard#Str">Str</a> ]</td>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;">not in constructor</td>
    <td style="padding-left: 6px; padding-right: 6px; white-space: nowrap;">read-only</td>
</tr>
</table>

<p>After parsing, this contains all lines in the header.</p>

## stencils

<table cellpadding="0" cellspacing="0">
<tr>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;"><a href="https://metacpan.org/pod/Types::Standard#ArrayRef">ArrayRef</a> [ <a href="https://metacpan.org/pod/Types::Stenciller#Stencil">Stencil</a> ]</td>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;">not in constructor</td>
    <td style="padding-left: 6px; padding-right: 6px; white-space: nowrap;">read-only</td>
</tr>
</table>

<p>After parsing, this contains all parsed stencils.</p>

# METHODS

## transform

    $stenciller->transform(
        plugin_name => 'ToUnparsedText',
        constructor_args => {
            plugin_specific_args => ...,
        },
        tranform_args => {
            transformation_specific_args => ...,
        },
    );

`plugin_name` is mandatory and should be a class under the `Stenciller::Plugin` namespace.

`constructor_args` is optional. This hash reference will be passed on to the plugin constructor. Valid keys depends on the plugin.

`transform_args` is optional. This hash reference will be passed on to the `transform` method in the plugin. Valid keys depends on the plugin.

# PLUGINS

The actual transforming is done by plugins. There are two plugins bundled in this distribution:

- [Stenciller::Plugin::ToUnparsedText](https://metacpan.org/pod/Stenciller::Plugin::ToUnparsedText)
- [Stenciller::Plugin::ToHtmlPreBlock](https://metacpan.org/pod/Stenciller::Plugin::ToHtmlPreBlock)
- [Pod::Elemental::Transformer::Stenciller](https://metacpan.org/pod/Pod::Elemental::Transformer::Stenciller)

Custom plugins should be in the [Stenciller::Plugin](https://metacpan.org/pod/Stenciller::Plugin) namespace and consume the [Stenciller::Transformer](https://metacpan.org/pod/Stenciller::Transformer) role.

# SOURCE

[https://github.com/Csson/p5-Stenciller](https://github.com/Csson/p5-Stenciller)

# HOMEPAGE

[https://metacpan.org/release/Stenciller](https://metacpan.org/release/Stenciller)

# AUTHOR

Erik Carlsson <info@code301.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Erik Carlsson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
