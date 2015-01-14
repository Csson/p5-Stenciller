use 5.14.0;
use strict;
use warnings;

use Stenciller::Standard;
use Stenciller::Stencil;

# PODNAME:
# VERSION
# ABSTRACT: Convert textfiles to different output

class Stenciller using Moose {

    has filepath => (
        is => 'ro',
        isa => File,
        required => 1,
        coerce => 1,
        documentation => 'The textfile to parse.',
    );
    has is_utf8 => (
        is => 'ro',
        isa => Bool,
        default => 1,
        documentation => 'Determines how the stencil file is read.'
    );
    has stencils => (
        is => 'rw',
        isa => ArrayRef[Stencil],
        traits => ['Array'],
        default => sub { [ ] },
        documentation => 'After parsing, this contains all parsed stencils.',
        init_arg => undef,
        handles => {
            add_stencil => 'push',
            all_stencils => 'elements',
            get_stencil => 'get',
            count_stencils => 'count',
        },
    );
    has header_lines => (
        is => 'rw',
        isa => ArrayRef[Str],
        traits => ['Array'],
        default => sub { [] },
        documentation => 'After parsing, this contains all lines in the header.',
        handles => {
            add_header_line => 'push',
            all_header_lines => 'elements',
        },
    );
    has skip_if_input_empty => (
        is => 'ro',
        isa => Bool,
        default => 1,
        documentation => 'If a stencil has no input content, skip entire stencil.',
    );
    has skip_if_output_empty => (
        is => 'ro',
        isa => Bool,
        default => 1,
        documentation => 'If a stencil has no output content, skip entire stencil.',
    );

    method BUILD {
        $self->parse;
    }

    method render(Str $plugin_name       does doc('Plugin to render contents with.'),
                      @constructor_args  does doc('Constructor arguments for the plugin.')
              --> Str                    does doc('Returns the rendered contents.')
    ) {

        my $plugin_class = "Stenciller::Plugin::$plugin_name";
        eval "use $plugin_class";
        die ("Cant 'use $plugin_class': $@") if $@;
     #   if(!$plugin_class->does('Stenciller::Renderer')) {
     #       croak("[$plugin_name] doesn't do the Stenciller::Renderer role. Quitting.");
     #   }
        return $plugin_class->new(stenciller => $self, @constructor_args)->render;
    }

    method parse {
        my @contents = split /\v/ => $self->is_utf8 ? $self->filepath->slurp_utf8 : $self->filepath->slurp;

        my $stencil_start = qr/^== +stencil +(\{.*\} +)?==$/;
        my $input_start = qr/^--+input--+$/;
        my $input_end = qr/^--+end input--+$/;
        my $output_start = qr/^--+output--+$/;
        my $output_end = qr/^--+end output--+$/;

        my $environment = 'header';
        my $line_count = 0;

        my $stencil = undef;

        LINE:
        foreach my $line (@contents) {
            ++$line_count if $environment ne 'next_stencil'; # because then we are redo-ing the line

            if(any { $environment eq $_ } (qw/header next_stencil/)) {
                $self->add_header_line($line) and next LINE if $line !~ $stencil_start;

                my $settings = $1 ? $self->eval($1) : {};

                $stencil = Stenciller::Stencil->new(
                            name => exists $settings->{'name'} ? delete $settings->{'name'} : $self->filepath->basename . "-$line_count",
                            loop_values => delete $settings->{'loop'},
                            line_number => $line_count,
                      maybe skip  => delete $settings->{'skip'},
                    provided scalar keys %{ $settings }, extra_settings => $settings,
                );
                $environment = 'before_input';
            }
            elsif($environment eq 'before_input') {
                $stencil->add_before_input($line) and next LINE if $line !~ $input_start;
                $environment = 'input';
            }
            elsif($environment eq 'input') {
                $stencil->add_input($line) and next LINE if $line !~ $input_end;
                $environment = 'between';
            }
            elsif($environment eq 'between') {
                $stencil->add_between($line) and next LINE if $line !~ $output_start;
                $environment = 'output';
            }
            elsif($environment eq 'output') {
                $stencil->add_output($line) and next LINE if $line !~ $output_end;
                $environment = 'after_output';
            }
            elsif($environment eq 'after_output') {
                $stencil->add_after_output($line) and next LINE if $line !~ $stencil_start;
                $self->handle_completed_stencil($stencil);
                $environment = 'next_stencil';
                redo LINE;
            }
        }
        $self->handle_completed_stencil($stencil);
    }

    method handle_completed_stencil(Stencil $stencil) {
        return if !defined $stencil;
        return if $stencil->skip;
        return if !$stencil->has_input  && $self->skip_if_input_empty;
        return if !$stencil->has_output && $self->skip_if_output_empty;

        if(!$stencil->has_loop_values) {
            $self->add_stencil($stencil);
            return;
        }

        foreach my $loop_value ($stencil->all_loop_values) {
            my $clone = $stencil->clone_with_loop_value($loop_value);
            $self->add_stencil($clone);
        }
    }

    method eval(Str $possible_hash --> HashRef) {
        my $stencil_settings = eval $possible_hash;
        die sprintf "Can't parse stencil start: <%s> in %s: %s", $possible_hash, $self->filepath, $@ if $@;
        return $stencil_settings;
    }
}


1;

__END__

=pod

:splint classname Stenciller

=head1 SYNOPSIS

    use Stenciller;
    my $stenciller = Stenciller->new(filepath => 't/corpus/test-1.stencil');
    my $content = $stenciller->render('ToUnparsedText');

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

:splint method render

=head1 PLUGINS

The actual rendering is done by plugins. There are two plugins bundled in this distribution:

=for :list
* L<Stenciller::Plugin::ToUnparsedText>
* L<Stenciller::Plugin::ToHtmlPreBlock>

Custom plugins should be in the L<Stenciller::Plugin> namespace and consume the L<Stenciller::Renderer> role.

=cut


