use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Deep;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use Stenciller;

ok 1;

my $stenciler = Stenciller->new(filepath => 't/corpus/test-1.stencil');

is $stenciler->count_stencils, 1, 'Correct number of stencils';

is joiner($stenciler->all_header_lines), "Intro text\ngoes  here\n", 'Got header text';

my $stencil = $stenciler->get_stencil(0);

is joiner($stencil->all_before_input), "thing\n\nhere\n", 'Got before input';
is joiner($stencil->all_input), "other thing\n", "Got input";
is joiner($stencil->all_between), "in between\nis three lines\nin a row\n", 'Got between input and output';
is joiner($stencil->all_output), "expecting this\n", "Got output";
is joiner($stencil->all_after_output), "A text after output", "Got after output";

done_testing;

sub joiner {
	return join "\n" => @_;
}
