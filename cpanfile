requires 'perl', '5.014000';

requires 'HTML::Entities';
requires 'List::AllUtils';
requires 'Moops';
requires 'MooseX::AttributeDocumented';
requires 'Kavorka::TraitFor::Parameter::doc';
requires 'Path::Tiny';
requires 'PerlX::Maybe';
requires 'Carp';

on test => sub {
    requires 'Test::More', '0.96';
    requires 'Test::Deep';
};
