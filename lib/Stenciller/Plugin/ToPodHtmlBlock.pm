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

            if($stencil->has_input) {
                warn 'and here................';
                push @out => sprintf qs{
                    =begin html

                    %s

                    =end html
                }, join "\n" => $stencil->all_input;
            }
        }
        return join '' => @out;
    }

}

1;
