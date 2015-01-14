use Stenciller::Standard;

# VERSION
# ABSTRACT: ...
# PODNAME:

class Stenciller::Plugin::ToPodHtmlBlock using Moose with Stenciller::Renderer {
    
    has stenciller => (
        is => 'ro',
        isa => Stenciller,
        required => 1,
    );

    method render {
        my @out = ();

        STENCIL:
        foreach my $stencil ($self->stenciller->all_stencils) {
            push @out => $self->join($stencil->all_before_input) if $stencil->has_before_input;
            push @out => $self->join($stencil->all_input)        if $stencil->has_input;
            push @out => $self->join($stencil->all_between)      if $stencil->has_between;
            push @out => $self->join($stencil->all_output)       if $stencil->has_output;
            push @out => $self->join($stencil->all_after_output) if $stencil->has_iafter_output;
        }
        return join '' => @out;
    }

    method join(@lines) {
        return join "\n" => @lines;
    }
    
}

1;
