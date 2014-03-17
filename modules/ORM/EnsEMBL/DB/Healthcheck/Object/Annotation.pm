=head1 LICENSE

Copyright [1999-2014] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::DB::Healthcheck::Object::Annotation;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::Healthcheck::Object);

__PACKAGE__->meta->setup(
  table       => 'annotation',

  columns     => [
    annotation_id => {type => 'serial', primary_key => 1, not_null => 1}, 
    report_id     => {type => 'integer'},
    session_id    => {type => 'integer'},
    action        => {
      'type'          => 'enum', 
      'values'        => [qw(manual_ok manual_ok_all_releases manual_ok_this_assembly manual_ok_this_genebuild manual_ok_this_regulatory_build healthcheck_bug under_review fixed note)]
    },
    comment       => {type => 'text'},
  ],

  trackable     => 1,

  title_column  => 'comment',

  relationships => [
    report => {
      'type'        => 'one to one',
      'class'       => 'ORM::EnsEMBL::DB::Healthcheck::Object::Report',
      'column_map'  => {'report_id' => 'report_id'},
    },
  ]
);

1;
