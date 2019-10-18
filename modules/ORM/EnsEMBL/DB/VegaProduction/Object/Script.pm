package ORM::EnsEMBL::DB::VegaProduction::Object::Script;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::VegaProduction::Object);

__PACKAGE__->meta->setup(
  table => 'script',
  columns => [
    script_id => { type => 'serial', primary_key => 1, not_null => 1 },
    code      => { type => 'varchar', length => 40 },
  ],

  unique_key => 'code',

  relationships => [
    codemaps => {
      type => 'one to many',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Codemap',
      column_map => { script_id => 'script_id' },
    },
    step => {
      type => 'one to many',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Step',
      column_map => { step_id => 'step_id' },
    },
  ],

  error_mode => 'return',
);

1;

