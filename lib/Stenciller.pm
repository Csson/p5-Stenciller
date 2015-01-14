use 5.14.0;
use strict;
use warnings;

use Stenciller::Standard;
use Stenciller::Stencil;

package Stenciller;

# VERSION
# ABSTRACT: Short intro

sub new {
    shift;
    return Stenciller::Wrap->new(@_);
}

class Stenciller::Wrap using Moose {

    use Data::Dump::Streamer;
    fun out {
        warn Dump(shift)->Out;
    }

    has filepath => (
        is => 'ro',
        isa => File,
        required => 1,
        coerce => 1,
    );
    has is_utf8 => (
        is => 'ro',
        isa => Bool,
        default => 1,
    );
    has stencils => (
        is => 'rw',
        isa => ArrayRef[Stencil],
        traits => ['Array'],
        default => sub { [ ] },
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
        handles => {
            add_header_line => 'push',
            all_header_lines => 'elements',
        },
    );
    has skip_if_input_empty => (
        is => 'ro',
        isa => Bool,
        default => 1,
    );
    has skip_if_output_empty => (
        is => 'ro',
        isa => Bool,
        default => 1,
    );
    has plugins => (
        is => 'rw',
        isa => ArrayRef[Renderer],
        default => sub { [] },
        traits => ['Array'],
        handles => {
            all_plugins => 'elements',
        }
    );
    

    method BUILD {
        $self->parse;
    }

    method render(Str $plugin_name, @constructor_args) {

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

=head1 SYNOPSIS

    use Stenciller;

=head1 DESCRIPTION

Stenciller is ...

=head1 SEE ALSO

=cut

== stencil { name => 'test1', is_example => 1, is_test => 0, loop => [qw/thing other_thing/] } ==

