package ORM::EnsEMBL::DB::VegaProduction::Object::Speciesstepset;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::VegaProduction::Object);

__PACKAGE__->meta->setup(
  table => 'speciesstepset',
  columns => [
    'speciesstepset_id'
                   => { type => 'serial', primary_key => 1, not_null => 1 },
    speciesstep_id => { type => 'int' },
    description    => { type => 'varchar', length => 255 },
  ],

  relationships => [
    speciesstep => {
      type => 'many to one',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Speciesstep',
      key_columns => { speciesstep_id => 'speciesstep_id' },
    },
  ],
);

1;

