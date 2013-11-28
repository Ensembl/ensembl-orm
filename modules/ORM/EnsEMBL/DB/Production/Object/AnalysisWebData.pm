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

package ORM::EnsEMBL::DB::Production::Object::AnalysisWebData;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Production::Object);

use constant ROSE_DB_NAME => 'production';

__PACKAGE__->meta->setup(
  table       => 'analysis_web_data',

  columns     => [
    analysis_web_data_id    => {type => 'serial', primary_key => 1, not_null => 1},
    analysis_description_id => {type => 'integer' },
    web_data_id             => {type => 'integer' },
    species_id              => {type => 'integer' },
    db_type                 => {type => 'enum', 'values' => [qw(
                                  cdna
                                  core
                                  funcgen
                                  otherfeatures
                                  presite
                                  rnaseq
                                  sangervega
                                  vega)]
    },
    displayable             => {type => 'integer', 'not_null' => 1, 'default' => 1},
  ],

  trackable     => 1,

  relationships => [
    web_data              => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::WebData',
      'column_map'  => {'web_data_id' => 'web_data_id'}
    },
    analysis_description  => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::AnalysisDescription',
      'column_map'  => {'analysis_description_id' => 'analysis_description_id'}
    },
    species               => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::Species',
      'column_map'  => {'species_id' => 'species_id'}
    }
  ],
);

1;