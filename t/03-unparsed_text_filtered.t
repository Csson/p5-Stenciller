use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Differences;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';
use Stenciller;

ok 1;

my $stenciller = Stenciller->new(filepath => 't/corpus/test-3.stencil');

is $stenciller->count_stencils, 2, 'Found stencils';

eq_or_diff $stenciller->transform(plugin_name => 'ToUnparsedText', transform_args => { stencils => [1] }), result(), 'Unparsed pod';

done_testing;

sub result {
    return qq{

Header
lines

If you write this [2]:

    <%= badge '3' %>

It becomes this:

    <span class="badge">3</span>

};
}
