package ORM::EnsEMBL::DB::VegaProduction::Object::Process;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::VegaProduction::Object);

__PACKAGE__->meta->setup(
  table => 'process',
  columns => [
    process_id => { type => 'serial', primary_key => 1, not_null => 1 },
    code       => { type => 'varchar', length => 40 },
  ],

  unique_key => 'code',

  relationships => [
    codemaps => {
      type => 'one to many',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Codemap',
      column_map => { process_id => 'process_id' },
    },
    steps => {
      type => 'one to many',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Step',
      column_map => { process_id => 'process_id' },
    },
  ],
  error_mode => 'return',
);

1;

