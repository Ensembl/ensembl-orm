package ORM::EnsEMBL::DB::VegaProduction::Object::Codemap;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::VegaProduction::Object);

__PACKAGE__->meta->setup(
  table => 'codemap',
  columns => [
    codemap_id     => { type => 'serial', primary_key => 1, not_null => 1 },
    match_pattern   => { type => 'varchar', length => 255 },
    type            => { type => 'varchar', length => 255 },
    state_condition => { type => 'varchar', length => 255 },
    actions         => { type => 'varchar', length => 255 },
    script_id       => { type => 'int' },
    priority        => { type => 'int' }, 
  ],

  relationships => [
    script => {
      type => 'many to one',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Script',
      key_columns => { script_id => 'script_id' },
    },
  ],
);

1;

