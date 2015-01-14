use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Deep;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use Stenciller;

ok 1;

my $stenciller = Stenciller->new(filepath => 't/corpus/test-2.stencil');

is $stenciller->count_stencils, 1, 'Found stencils';

is $stenciller->render('ToUnparsedPod'), qq{If you write this:\n    <%= badge '3' %>\nIt renders to this:\n    <span class="badge">3</span>\n}, 'Unparsed pod';

done_testing;
