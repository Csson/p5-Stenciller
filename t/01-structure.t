use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Deep;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use Stenciller;

ok 1;

my $stencil = Stenciller->new(filepath => 'corpus/test-1.stencil');

is $stencil->get_stencil(0)->before_input, 'This', 'Great';

done_testing;
