=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2022] EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::DB::Production::Object::Attrib;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table         => 'master_attrib',

  columns       => [
    attrib_id       => {type => 'serial', primary_key => 1, not_null => 1},
    attrib_type_id  => {type => 'int', not_null => 1},
    value           => {type => 'text', not_null => 1},
    is_current      => {type => 'int', 'default' => 1, not_null => 1}
  ],

  trackable             => 1,

  unique_key            => [qw(attrib_type_id value)],

  title_column          => 'value',

  inactive_flag_column  => 'is_current',

  relationships => [
    attrib_type => {
      'type'        => 'one to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::AttribType',
      'column_map'  => {'attrib_type_id' => 'attrib_type_id'},
    },
    attrib_set  => {
      'type'        => 'one to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::AttribSet',
      'column_map'  => {'attrib_id' => 'attrib_id'},
    }
  ]
);

1;
