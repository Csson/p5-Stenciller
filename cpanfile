requires 'perl', '5.014000';

requires 'HTML::Entities';
requires 'List::AllUtils';
requires 'Module::Pluggable';
requires 'Moops', '0.034';
requires 'Moose', '2.0000';
requires 'MooseX::AttributeDocumented';
requires 'Kavorka::TraitFor::Parameter::doc';
requires 'Path::Tiny';
requires 'PerlX::Maybe';
requires 'Carp';
requires 'Types::Path::Tiny';

on test => sub {
    requires 'Test::More', '0.96';
    requires 'Test::Deep';
    requires 'Test::Differences';
    requires 'Test::Warnings',
};

on develop => sub {
    requires 'Pod::Weaver::Section::Source::DefaultGitHub';
    requires 'Pod::Weaver::Section::Homepage::DefaultCPAN';
    requires 'Pod::Elemental::Transformer::List';
    requires 'Pod::Elemental::Transformer::Splint';
};
