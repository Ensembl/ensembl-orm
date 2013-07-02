package ORM::EnsEMBL::DB::Production::Object::Species;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table       => 'species',

  columns     => [
    species_id        => {type => 'serial', primary_key => 1, not_null => 1}, 
    db_name           => {type => 'varchar', 'length' => 255, not_null => 1},
    common_name       => {type => 'varchar', 'length' => 255, not_null => 1},
    web_name          => {type => 'varchar', 'length' => 255, not_null => 1},
    scientific_name   => {type => 'varchar', 'length' => 255, not_null => 1},
    production_name   => {type => 'varchar', 'length' => 255, not_null => 1},
    url_name          => {type => 'varchar', 'length' => 255, not_null => 1},
    taxon             => {type => 'varchar', 'length' => 20 },
    species_prefix    => {type => 'varchar', 'length' => 20 },
    attrib_type_id    => {type => 'integer', 'length' => 10 },
    is_current        => {type => 'integer', 'default' => 1,  not_null => 1}
  ],
  
  trackable             => 1,

  unique_key            => ['db_name'],

  title_column          => 'web_name',

  inactive_flag_column  => 'is_current',

  relationships         => [
    changelog         => {
      'type'        => 'many to many',
      'map_class'   => 'ORM::EnsEMBL::DB::Production::Object::ChangelogSpecies',
      'map_from'    => 'species',
      'map_to'      => 'changelog',
    },
    alias             => {
      'type'        => 'one to many',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::SpeciesAlias',
      'column_map'  => {'species_id' => 'species_id'}
    },
    meta_key          => {
      'type'        => 'many to many',
      'map_class'   => 'ORM::EnsEMBL::DB::Production::Object::MetaKeySpecies',
      'map_from'    => 'species',
      'map_to'      => 'meta_key',
    },
    analysis_web_data => {
      'type'        => 'one to many',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::AnalysisWebData',
      'column_map'  => {'species_id' => 'species_id'}
    },
    attrib_type       => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::AttribType',
      'column_map'  => {'attrib_type_id' => 'attrib_type_id'}
    }
  ],
);

1;