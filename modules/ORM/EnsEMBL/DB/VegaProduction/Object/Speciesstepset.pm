package ORM::EnsEMBL::DB::VegaProduction::Object::Speciesstepset;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::VegaProduction::Object);

__PACKAGE__->meta->setup(
  table => 'speciesstepset',
  columns => [
    'speciesstepset_id'
                   => { type => 'serial', primary_key => 1, not_null => 1 },
    description    => { type => 'varchar', length => 255 },
  ],

  relationships => [
    speciesstep => {
      type => 'many to many',
      map_class =>
        'ORM::EnsEMBL::DB::VegaProduction::Object::Speciesstepsetmember',
    },
    speciesstepmember => {
      type => 'one to many',
      class =>
        'ORM::EnsEMBL::DB::VegaProduction::Object::Speciesstepsetmember',
      key_columns => { speciesstepset_id => 'speciesstepset_id' },
    },
  ],
);

1;

