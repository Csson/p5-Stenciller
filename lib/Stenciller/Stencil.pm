use Stenciller::Standard;

# VERSION
# ABSTRACT: One part of a file
# PODCLASSNAME:

class Stenciller::Stencil using Moose {

    my @attrs = qw/before_input input between output after_output/;

    my $order = 1;
    foreach my $attr (@attrs) {
        has $attr => (
            is => 'ro',
            isa => ArrayRef[Str],
            default => sub { [] },
            traits => ['Array'],
            init_arg => undef,
            documentation_order => ++$order,
            documentation => sprintf ('Holds all lines of the %s section.', $attr),
            handles => {
                "has_$attr"    => 'count',
                "add_$attr"    => 'push',
                "all_$attr"    => 'elements',
                "map_$attr"    => 'map',
                "get_$attr"    => 'get',
            },
        );
    }
    has skip => (
        is => 'ro',
        isa => Bool,
        default => 0,
        documentation => 'Should the Stencil not be included in the result?',
    );

    has line_number => (
        is => 'ro',
        isa => Int,
        documentation => 'Can be referenced in the output for easier backtracking.',
    );
    has extra_settings => (
        is => 'ro',
        isa => HashRef,
        default => sub { { } },
        traits => ['Hash'],
        documentation => 'Any extra key-value pairs in the stencil header.',
        handles => {
            get_extra_setting => 'get',
            set_extra_setting => 'set',
            keys_extra_settings => 'keys',
        },
    );
    has loop_values => (
        is => 'ro',
        isa => ArrayRef,
        default => sub { [] },
        traits => ['Array'],
        documentation_order => 0,
        handles => {
            has_loop_values => 'count',
            add_loop_value => 'get',
            all_loop_values => 'elements',
        },
    );

    around BUILDARGS($orig: $class, @args) {
        my %args = @args;
        $args{'loop_values'} = [] if !defined $args{'loop_values'};

        return $class->$orig(%args);
    }

    # Remove all empty lines for each group until we have a line with content, then keep everything
    around add_before_input($orig: $self, $text) {
        return $self->ensure_content($orig, $self->has_before_input, $text);
    }
    around add_input($orig: $self, $text) {
        return $self->ensure_content($orig, $self->has_input, $text);
    }
    around add_between($orig: $self, $text) {
        return $self->ensure_content($orig, $self->has_between, $text);
    }
    around add_output($orig: $self, $text) {
        return $self->ensure_content($orig, $self->has_output, $text);
    }
    around add_after_output($orig: $self, $text) {
        return $self->ensure_content($orig, $self->has_after_output, $text);
    }
    method ensure_content(CodeRef $orig, Int $already_have, $text) {
        $self->$orig($text) if $already_have || $text !~ m{^\s*$};
        return $self;
    }

    method clone_with_loop_value(Str $loop_value) {
        return Stenciller::Stencil->new(
            before_input => $self->map_before_input( sub { $_ =~ s{ \[ var \] }{$loop_value}x }),
                   input => $self->map_input( sub { $_ =~ s{ \[ var \] }{$loop_value}x }),
                 between => $self->map_between( sub { $_ =~ s{ \[ var \] }{$loop_value}x }),
                  output => $self->map_output( sub { $_ =~ s{ \[ var \] }{$loop_value}x }),
                   after => $self->map_after( sub { $_ =~ s{ \[ var \] }{$loop_value}x }),
            (map { $_ => $self->$_ } qw/line_number extra_settings/)
        );
    }

}

__END__

=pod

:splint classname Stenciller::Stencil

=head1 SYNOPSIS

    # In a plugin (this is pretty similar to what ToUnparsedText does)
    sub render {
        my $self = shift;
        my @out = ();

        STENCIL:
        foreach my $stencil ($self->stenciller->all_stencils) {
            push @out => join "\n" => $stencil->all_before_input;
            push @out => join "\n" => $stencil->all_input;
            push @out => join "\n" => $stencil->all_between;
            push @out => join "\n" => $stencil->all_output;
            push @out => join "\n" => $stencil->all_after_output;
        }
        return join "\n" => @out;
    }

=head1 DESCRIPTION

A C<Stencil> is one section of the file format defined in L<Stenciller>.

=head1 ATTRIBUTES

:splint attributes

=cut
