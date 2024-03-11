=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2024] EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::DB::Production::Object::AnalysisDescription;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table         => 'analysis_description',

  columns       => [
    analysis_description_id => {type => 'serial', primary_key => 1, not_null => 1}, 
    logic_name              => {type => 'varchar', 'length' => 128 },
    description             => {type => 'text'},
    display_label           => {type => 'varchar', 'length' => 256 },
    db_version              => {type => 'integer', not_null => 1, default => 1 },
    default_web_data_id     => {type => 'integer'}
  ],

  trackable     => 1,

  title_column  => 'logic_name',

  unique_key    => ['logic_name'],

  relationships => [
    analysis_web_data => {
      'type'            => 'one to many',
      'class'           => 'ORM::EnsEMBL::DB::Production::Object::AnalysisWebData',
      'column_map'      => {'analysis_description_id' => 'analysis_description_id'}
    },

    default_web_data  => {
      'type'            => 'many to one',
      'class'           => 'ORM::EnsEMBL::DB::Production::Object::WebData',
      'column_map'      => {'default_web_data_id' => 'web_data_id'}
    }
  ]
);

1;