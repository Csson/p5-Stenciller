use 5.14.0;
use warnings;

use Moops;

# VERSION
# PODNAME:
library Types::Stenciller

extends Types::Standard, Types::TypeTiny, Types::Path::Tiny

declares Stencil, Renderer

{

    class_type Stencil => { class => 'Stenciller::Stencil' };
    class_type Renderer => { class => 'Stenciller::Renderer' };
    
}

1;
