package ORM::EnsEMBL::DB::VegaProduction::Object::Speciesstep;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::VegaProduction::Object);

__PACKAGE__->meta->setup(
  table => 'speciesstep',
  columns => [
    speciesstep_id => { type => 'serial', primary_key => 1, not_null => 1 },
    step_id        => { type => 'int' },
    species_id     => { type => 'int' },
  ],

  relationships => [
    step => {
      type => 'many to one',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Step',
      key_columns => { step_id => 'step_id' },
    },
    species => {
      type => 'many to one',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Species',
      key_columns => { species_id => 'species_id' },
    },
  ],
);

1;

