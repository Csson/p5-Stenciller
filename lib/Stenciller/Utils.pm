use Stenciller::Standard;

# VERSION:
# PODCLASSNAME

role Stenciller::Utils using Moose {

    method eval_to_hashref(Str $possible_hash!, Path|Str $faulty_file! --> HashRef) {
        my $settings = eval $possible_hash;
        die sprintf "Can't parse stencil start: <%s> in %s: %s", $possible_hash, $faulty_file, $@ if $@;
        return $settings;
    }
    method eval(Str $string!) {
        eval $string;
        die sprintf "Can't parse %s: %s", $string, $@ if $@;
        return 1;
    }
}

1;
