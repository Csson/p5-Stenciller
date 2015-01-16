use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Deep;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';
use syntax 'qi';
use Stenciller;

ok 1;

my $stenciller = Stenciller->new(filepath => 't/corpus/test-2.stencil');

is $stenciller->count_stencils, 1, 'Found stencils';

is $stenciller->transform('ToHtmlPreBlock'), result(), 'Unparsed pod';

done_testing;

sub result {
    return join '' => qq{<p>
If you write this:

</p><pre>
    &lt;%= badge &#39;3&#39; %&gt;

</pre><p>
It becomes this:

</p><pre>
    &lt;span class=&quot;badge&quot;&gt;3&lt;/span&gt;

</pre>};
};
