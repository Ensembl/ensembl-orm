package ORM::EnsEMBL::DB::VegaProduction::Object::Speciesstepsetmember;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::VegaProduction::Object);

__PACKAGE__->meta->setup(
  table => 'speciesstepsetmember',
  columns => [
    'speciesstepsetmember_id'
                   => { type => 'serial', primary_key => 1, not_null => 1 },
    'speciesstepset_id' => { type => 'int' },
    'speciesstep_id' => { type => 'int' },
  ],

  relationships => [
    speciesstep => {
      type => 'many to one',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Speciesstep',
      key_columns => { speciesstep_id => 'speciesstep_id' },
    },
    speciesstepset => {
      type => 'many to one',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Speciesstepset',
      key_columns => { speciesstepset_id => 'speciesstepset_id' },
    },
  ],
);

1;

