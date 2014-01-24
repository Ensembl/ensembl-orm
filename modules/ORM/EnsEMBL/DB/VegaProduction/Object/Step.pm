package ORM::EnsEMBL::DB::VegaProduction::Object::Step;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::VegaProduction::Object);

__PACKAGE__->meta->setup(
  table => 'step',
  columns => [
    step_id    => { type => 'serial', primary_key => 1, not_null => 1 },
    process_id => { type => 'int' },
    script_id  => { type => 'int' },
  ],

  relationships => [
    process => {
      type => 'many to one',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Process',
      key_columns => { process_id => 'process_id' },
    },
    script => {
      type => 'many to one',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Script',
      key_columns => { script_id => 'script_id' },
    },
    speciessteps => {
      type => 'one to many',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Speciesstep',
      key_columns => { step_id => 'step_id' },
    },
  ],
);

1;

