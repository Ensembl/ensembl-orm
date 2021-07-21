=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2021] EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::DB::Production::Object::MetaKey;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table       => 'meta_key',

  columns     => [
    meta_key_id       => {type => 'serial', primary_key => 1, not_null => 1},
    name              => {type => 'varchar', 'length' => 64 },
    is_current        => {type => 'integer', 'default' => 1, not_null => 1},
    is_optional       => {type => 'integer', 'default' => 0, not_null => 1},
    db_type           => {type => 'set', default => 'core', not_null => 1, 'values' => [qw(
                            cdna
                            core
                            funcgen
                            otherfeatures
                            presite
                            rnaseq
                            sangervega
                            variation
                            vega)]
    },
    description       => {type => 'text'}
  ],

  trackable     => 1,

  relationships => [
    species => {
      'type'        => 'many to many',
      'map_class'   => 'ORM::EnsEMBL::DB::Production::Object::MetaKeySpecies',
      'map_from'    => 'meta_key',
      'map_to'      => 'species',
    },
  ],

  title_column          => 'name',
  inactive_flag_column  => 'is_current'
);

1;