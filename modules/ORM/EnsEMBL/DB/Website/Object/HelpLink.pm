=head1 LICENSE

Copyright [1999-2016] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::DB::Website::Object::HelpLink;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::Website::Object);

__PACKAGE__->meta->setup(
  table         => 'help_link',

  columns       => [
    help_link_id    => {type => 'serial', not_null => 1, primary_key => 1},
    page_url        => {type => 'text'},
    help_record_id  => {type => 'integer', 'length' => 11},
  ],
  
  title_column  => 'page_url',
  
  relationships => [
    help_record => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Website::Object::HelpRecord',
      'column_map'  => {'help_record_id' => 'help_record_id'},
    }
  ]
);

1;