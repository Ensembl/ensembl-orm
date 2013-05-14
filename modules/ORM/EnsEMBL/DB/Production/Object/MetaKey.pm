package ORM::EnsEMBL::DB::Production::Object::MetaKey;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table       => 'meta_key',

  columns     => [
    meta_key_id       => {type => 'serial', primary_key => 1, not_null => 1}, 
    name              => {type => 'varchar', 'length' => 64 },
    is_current        => {type => 'integer', 'default' => 1 },
    is_optional       => {type => 'integer'},
    db_type           => {type => 'set', default => 'core', not_null => 1, 'values' => [qw(
                            cdna
                            core
                            funcgen
                            otherfeatures
                            presite
                            rnaseq
                            sangervega
                            variation
                            vega)]
    },
    description       => {type => 'text'}
  ],

  trackable     => 1,

  relationships => [
    species => {
      'type'        => 'many to many',
      'map_class'   => 'ORM::EnsEMBL::DB::Production::Object::MetaKeySpecies',
      'map_from'    => 'meta_key',
      'map_to'      => 'species',
    },
  ],

  title_column          => 'name',
  inactive_flag_column  => 'is_current'
);

1;