use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Differences;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';
use Stenciller;

ok 1;

my $stenciller = Stenciller->new(filepath => 't/corpus/test-5.stencil');

is $stenciller->count_stencils, 2, 'Found stencils';

eq_or_diff $stenciller->transform(plugin_name => 'ToHtmlPreBlock', transform_args => { stencils => [1] }), result(), 'Parsed to html';

done_testing;

sub result {
    return join '' => qq{
Header

lines


<p>If you write this [only this]:</p>
<pre>    &lt;%= badge &#39;3&#39; %&gt;
</pre>
<p>It becomes this:</p>
<pre>    &lt;span class=&quot;badge&quot;&gt;3&lt;/span&gt;
</pre>};
};
