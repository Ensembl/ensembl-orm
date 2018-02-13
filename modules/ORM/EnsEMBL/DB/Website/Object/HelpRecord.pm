=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2018] EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::DB::Website::Object::HelpRecord;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::Website::Object);

__PACKAGE__->meta->setup(
  table           => 'help_record',

  trackable       => 1,

  columns         => [
    help_record_id  => {type => 'serial',                    not_null => 1, primary_key => 1},
    type            => {type => 'varchar',  'length' => 255, not_null => 1},
    keyword         => {type => 'text'},
    data            => {type => 'datamap',  'trusted' => 0,  not_null => 1},
    status          => {type => 'enum',     'values' => [qw(draft live dead)] },
    helpful         => {type => 'int',      'length' => 11},
    not_helpful     => {type => 'int',      'length' => 11}
  ],

  virtual_columns => [
    question        => {'column' => 'data'},
    answer          => {'column' => 'data'},
    category        => {'column' => 'data'},
    word            => {'column' => 'data'},
    expanded        => {'column' => 'data'},
    meaning         => {'column' => 'data'},
    list_position   => {'column' => 'data'},
    length          => {'column' => 'data'},
    youtube_id      => {'column' => 'data'},
    youku_id        => {'column' => 'data'},
    title           => {'column' => 'data'},
    ensembl_object  => {'column' => 'data'},
    ensembl_action  => {'column' => 'data'},
    content         => {'column' => 'data'},
  ],

  relationships   => [
    help_links      => {  # this relation only exists if help_record.type == 'view'
      'type'          => 'one to many',
      'class'         => 'ORM::EnsEMBL::DB::Website::Object::HelpLink',
      'column_map'    => {'help_record_id' => 'help_record_id'},
    }
  ]
);

sub include_in_lookup {
  ## @overrides
  ## Only help_record with type == 'view' can can be used, as only relationship that 
  return (shift->column_value('type') || '') eq 'view';
}

sub get_title {
  ## @overrodes
  return $_[0]->column_value({qw(view content movie title faq question glossary word lookup word)}->{$_[0]->type});
}

1;
