use 5.14.0;

package Stenciller::Standard {

    # VERSION
    # ABSTRACT: Import to all

    use base 'Moops';
    use List::AllUtils();
    use Types::Stenciller();
    use MooseX::AttributeDocumented();
    use Path::Tiny();
    use PerlX::Maybe();
    use Carp();

    sub import {
        my $class = shift;
        my %opts = @_;

        push @{ $opts{'imports'} ||= [] } => (
            'List::AllUtils'    => [qw/any none sum uniq first_index/],
            'feature'           => [qw/:5.14/],
            'Types::Stenciller' => [{ replace => 1 }, '-types'],
            'Path::Tiny'        => ['path'],
            'MooseX::AttributeDocumented' => [],
            'PerlX::Maybe'      => [qw/maybe provided/],
            'Carp'              => [qw/carp/],
        );

        $class->SUPER::import(%opts);
    }
}

1;
