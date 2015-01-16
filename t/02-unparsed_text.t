use strict;
use warnings FATAL => 'all';
use Test::More;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use Stenciller;

ok 1;

my $stenciller = Stenciller->new(filepath => 't/corpus/test-2.stencil');

is $stenciller->count_stencils, 1, 'Found stencils';

is $stenciller->transform('ToUnparsedText'), qq{Header\nlines\n\nIf you write this:\n\n    <%= badge '3' %>\n\nIt becomes this:\n\n    <span class="badge">3</span>\n}, 'Unparsed pod';

done_testing;
