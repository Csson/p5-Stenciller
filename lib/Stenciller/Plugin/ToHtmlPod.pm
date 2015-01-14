use Stenciller::Standard;

# VERSION
# ABSTRACT: ...
# PODNAME:

class Stenciller::Plugin::ToHtmlPod with Stenciller::Renderer using Moose {
    
    has stenciller => (
        is => 'ro',
        isa => Stenciller,
        required => 1,
    );

    method render {
        my @out = ();

        STENCIL:
        foreach my $stencil ($)
    }

}
