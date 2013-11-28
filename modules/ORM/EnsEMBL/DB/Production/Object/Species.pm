=head1 LICENSE

Copyright [1999-2013] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

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