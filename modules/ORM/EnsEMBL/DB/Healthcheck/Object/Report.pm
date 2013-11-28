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

package ORM::EnsEMBL::DB::Healthcheck::Object::Report;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Healthcheck::Object);

__PACKAGE__->meta->setup(
  table       => 'report',

  columns     => [
    report_id         => {type => 'serial', primary_key => 1, not_null => 1}, 
    first_session_id  => {type => 'int', 'length' => '10'},
    last_session_id   => {type => 'int', 'length' => '10'},
    species           => {type => 'varchar', 'length' => '255'},
    database_type     => {type => 'varchar', 'length' => '255'},
    database_name     => {type => 'varchar', 'length' => '255'},
    testcase          => {type => 'varchar', 'length' => '255'},
    text              => {type => 'text'},
    team_responsible  => {type => 'varchar', 'length' => '255'},
    result            => {type => 'enum', 'values' => [qw(PROBLEM CORRECT WARNING INFO)]},
    timestamp         => {type => 'datetime'},
    created           => {type => 'datetime'},
    failed_count      => {type => 'integer', lazy => 1}
  ],

  title_column  => 'text',

  relationships => [
    first_session => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Healthcheck::Object::Session',
      'column_map'  => {'first_session_id' => 'session_id'},
    },
    last_session => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Healthcheck::Object::Session',
      'column_map'  => {'last_session_id' => 'session_id'},
    },
    annotation => {
      'type'        => 'one to one',
      'class'       => 'ORM::EnsEMBL::DB::Healthcheck::Object::Annotation',
      'column_map'  => {'report_id' => 'report_id'},
    },
  ],
);

1;