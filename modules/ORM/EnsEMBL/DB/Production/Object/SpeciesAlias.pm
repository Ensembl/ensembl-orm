package ORM::EnsEMBL::DB::Production::Object::SpeciesAlias;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table       => 'species_alias',

  columns     => [
    species_alias_id  => {type => 'serial', primary_key => 1, not_null => 1},
    species_id        => {type => 'integer',                  not_null => 1},
    alias             => {type => 'varchar', 'length' => 255, not_null => 1},
    is_current        => {type => 'integer', 'default' => 1,  not_null => 1},
  ],

  trackable             => 1,

  title_column          => 'alias',

  inactive_flag_column  => 'is_current',

  relationships         => [
    species         => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::Species',
      'column_map'  => {'species_id' => 'species_id'}
    }
  ],
);

1;