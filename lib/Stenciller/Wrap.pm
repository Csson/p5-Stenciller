use Stenciller::Standard;
use Stenciller::Stencil;
use strict;
use warnings;

# PODCLASSNAME

use Module::Pluggable search_path => ['Stenciller::Plugin'];

class Stenciller::Wrap using Moose with Stenciller::Utils {

    # VERSION

    use Module::Load;
    use Carp 'croak';

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
        is => 'ro',
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
            has_stencils => 'count',
        },
    );
    has header_lines => (
        is => 'ro',
        isa => ArrayRef[Str],
        traits => ['Array'],
        default => sub { [] },
        init_arg => undef,
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

    around BUILDARGS($next: $class, @args) {
        if(scalar @args == 1 && ref $args[0] eq 'HASH') {
            $class->$next(%{ $args[0] });
        }
        else {
            $class->$next(@args);
        }
    }

    method BUILD {
        $self->parse;
    }
    around has_stencils($next: $self) {
        my $count = $self->$next;
        return !!$count || 0;
    }

    method transform(Str :$plugin_name!          does doc('Plugin that will generate output.'),
                     HashRef :$constructor_args? does doc('Constructor arguments for the plugin.')     = {},
                     HashRef :$transform_args?   does doc('Settings for the specific transformation.') = {}, ...
                 --> Str     but assumed         does doc('The transformed content.')
    ) {

        my $plugin_class = "Stenciller::Plugin::$plugin_name";
        Module::Load::load($plugin_class);
        die sprintf "Can't load %s: %s", $plugin_class, $@ if $@;

        if(!$plugin_class->does('Stenciller::Transformer')) {
            croak("[$plugin_name] doesn't do the Stenciller::Transformer role. Quitting.");
        }
        return $plugin_class->new(stenciller => $self, %{ $constructor_args })->transform($transform_args);
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

                my $possible_hash = $1;
                my $settings = defined $possible_hash && $possible_hash =~ m{\{.*\}}
                             ? $self->eval_to_hashref($possible_hash, $self->filepath)
                             : {}
                             ;

                my $stencil_name = exists $settings->{'name'} ? delete $settings->{'name'} : $self->filepath->basename(qr/\..*/) . "-$line_count";
                $stencil_name =~ s{[. -]}{_}g;
                $stencil_name =~ s{[^a-zA-Z0-9_]}{}g;

                $stencil = Stenciller::Stencil->new(
                            stencil_name => $stencil_name,
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
        if($environment ne 'after_output') {
            croak (sprintf 'File <%s> appears malformed. Ended on <%s>', $self->filepath, $environment);
        }
        $self->handle_completed_stencil($stencil);
    }

    method handle_completed_stencil(Maybe[Stencil] $stencil) {
        return if !Stencil->check($stencil);
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

    method max_stencil_index {
        return $self->count_stencils - 1;
    }
}

1;
