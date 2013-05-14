package ORM::EnsEMBL::DB::Production::Object::MetaKeySpecies;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table       => 'meta_key_species',

  columns     => [
    meta_key_id      => {type => 'int', not_null => 1, primary_key => 1}, 
    species_id       => {type => 'int', not_null => 1, primary_key => 1}, 
  ],

  relationships => [
    meta_key => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::MetaKey',
      'column_map'  => {'meta_key_id' => 'meta_key_id'},
    },
    species => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::Species',
      'column_map'  => {'species_id' => 'species_id'}
    },
  ],
);

1;