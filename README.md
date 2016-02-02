# NAME

Stenciller - Transforms a flat file format to different output

![Requires Perl 5.14+](https://img.shields.io/badge/perl-5.14+-brightgreen.svg) [![Travis status](https://api.travis-ci.org/Csson/p5-Stenciller.svg?branch=master)](https://travis-ci.org/Csson/p5-Stenciller)

# VERSION

Version 0.1303, released 2016-01-12.

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

<p></p>

<!-- -->
<table style="margin-bottom: 10px; margin-left: 10px; border-collapse: bollapse;" cellpadding="0" cellspacing="0">

<tr style="vertical-align: top;">
    <td style="text-align: left; color: #444; padding-left: 5px; font-weight: bold; background-color: #e8eee8;">Named parameters</td>
    <td style="text-align: left; color: #444; padding-left: 5px; font-weight: bold; background-color: #e8eee8;">&#160;</td>
    <td style="text-align: left; color: #444; padding-left: 5px; font-weight: bold; background-color: #e8eee8;">&#160;</td>
    <td style="text-align: left; color: #444; padding-left: 5px; font-weight: bold; background-color: #e8eee8;">&#160;</td>
    <td style="text-align: left; color: #444; padding-left: 5px; font-weight: bold; background-color: #e8eee8;">&#160;</td>
</tr>
<tr style="vertical-align: top;">
    <td style="vertical-align: top; border-right: 1px solid #eee; white-space: nowrap;  padding: 3px 6px; border-bottom: 1px solid #eee;"><code>plugin_name =&gt; $value</code></td>
    <td style="vertical-align: top; border-right: 1px solid #eee; white-space: nowrap;  padding: 3px 6px; border-bottom: 1px solid #eee;"><a href="https://metacpan.org/pod/Types::Standard#Str">Str</a></td>
    <td style="vertical-align: top; border-right: 1px solid #eee; white-space: nowrap;  padding: 3px 6px; border-bottom: 1px solid #eee;">required</td>
    <td style="vertical-align: top; border-right: 1px solid #eee; white-space: nowrap;  border-bottom: 1px solid #eee;"></td>
    <td style="padding: 3px 6px; vertical-align: top;  border-bottom: 1px solid #eee;">Plugin that will generate output.</td>
</tr>
<tr style="vertical-align: top;">
    <td style="vertical-align: top; border-right: 1px solid #eee; white-space: nowrap;  padding: 3px 6px; border-bottom: 1px solid #eee;"><code>constructor_args =&gt; $value</code></td>
    <td style="vertical-align: top; border-right: 1px solid #eee; white-space: nowrap;  padding: 3px 6px; border-bottom: 1px solid #eee;"><a href="https://metacpan.org/pod/Types::Standard#HashRef">HashRef</a></td>
    <td style="vertical-align: top; border-right: 1px solid #eee; white-space: nowrap;  padding: 3px 6px; border-bottom: 1px solid #eee;">optional, default <code>= { }</code></td>
    <td style="vertical-align: top; border-right: 1px solid #eee; white-space: nowrap;  border-bottom: 1px solid #eee;"></td>
    <td style="padding: 3px 6px; vertical-align: top;  border-bottom: 1px solid #eee;">Constructor arguments for the plugin.</td>
</tr>
<tr style="vertical-align: top;">
    <td style="vertical-align: top; border-right: 1px solid #eee; white-space: nowrap;  padding: 3px 6px; border-bottom: 1px solid #eee;"><code>transform_args =&gt; $value</code></td>
    <td style="vertical-align: top; border-right: 1px solid #eee; white-space: nowrap;  padding: 3px 6px; border-bottom: 1px solid #eee;"><a href="https://metacpan.org/pod/Types::Standard#HashRef">HashRef</a></td>
    <td style="vertical-align: top; border-right: 1px solid #eee; white-space: nowrap;  padding: 3px 6px; border-bottom: 1px solid #eee;">optional, default <code>= { }</code></td>
    <td style="vertical-align: top; border-right: 1px solid #eee; white-space: nowrap;  border-bottom: 1px solid #eee;"></td>
    <td style="padding: 3px 6px; vertical-align: top;  border-bottom: 1px solid #eee;">Settings for the specific transformation.</td>
</tr>
<tr style="vertical-align: top;">
    <td style="text-align: left; color: #444; padding-left: 5px; font-weight: bold; background-color: #e8e8ee;">Returns</td>
    <td style="text-align: left; color: #444; padding-left: 5px; font-weight: bold; background-color: #e8e8ee;">&#160;</td>
    <td style="text-align: left; color: #444; padding-left: 5px; font-weight: bold; background-color: #e8e8ee;">&#160;</td>
    <td style="text-align: left; color: #444; padding-left: 5px; font-weight: bold; background-color: #e8e8ee;">&#160;</td>
    <td style="text-align: left; color: #444; padding-left: 5px; font-weight: bold; background-color: #e8e8ee;">&#160;</td>
</tr>
<tr style="vertical-align: top;">
    <td style="vertical-align: top; border-right: 1px solid #eee;  padding: 3px 6px; border-bottom: 1px solid #eee;"><a href="https://metacpan.org/pod/Types::Standard#Str">Str</a></td>
    <td style="vertical-align: top; border-right: 1px solid #eee;  padding: 3px 6px; border-bottom: 1px solid #eee;">&#160;</td>
    <td style="vertical-align: top; border-right: 1px solid #eee;  padding: 3px 6px; border-bottom: 1px solid #eee;">&#160;</td>
    <td style="vertical-align: top; border-right: 1px solid #eee;  padding: 3px 6px; border-bottom: 1px solid #eee;">&#160;</td>
    <td style="padding: 3px 6px; vertical-align: top;  border-bottom: 1px solid #eee;">The transformed content.</td>
</tr>
</table>

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
