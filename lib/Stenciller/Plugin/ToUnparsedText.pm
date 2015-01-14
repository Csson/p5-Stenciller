use Stenciller::Standard;

# VERSION
# ABSTRACT: ...
# PODNAME:

class Stenciller::Plugin::ToUnparsedText using Moose with Stenciller::Renderer {
    
    has stenciller => (
        is => 'ro',
        isa => Stenciller,
        required => 1,
    );

    method render {
        my @out = ();

        STENCIL:
        foreach my $stencil ($self->stenciller->all_stencils) {
            push @out => $self->join($stencil->all_before_input);
            push @out => $self->join($stencil->all_input);
            push @out => $self->join($stencil->all_between);
            push @out => $self->join($stencil->all_output);
            push @out => $self->join($stencil->all_after_output);
        }
        return join "\n" => @out;
    }

    method join(@lines) {
        return join "\n" => @lines if scalar @lines;
        return ();
    }
}

1;
