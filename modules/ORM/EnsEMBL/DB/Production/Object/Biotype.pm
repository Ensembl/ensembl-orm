=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::DB::Production::Object::Biotype;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table       => 'biotype',

  columns     => [
    biotype_id        => {type => 'serial', primary_key => 1, not_null => 1}, 
    name              => {type => 'varchar', 'length' => 64 },
    is_current        => {type => 'integer', default => 1, not_null => 1},
    is_dumped         => {type => 'integer', default => 1, not_null => 1},
    object_type       => {type => 'enum', default => 'gene', not_null => 1, 'values' => [qw(gene transcript)]},
    db_type           => {type => 'set' , default => 'core', not_null => 1, 'values' => [qw(
                            cdna
                            core
                            coreexpressionatlas
                            coreexpressionest
                            coreexpressiongnf
                            funcgen
                            otherfeatures
                            presite
                            rnaseq
                            sangervega
                            variation
                            vega)]
    },
    attrib_type_id    => {type => 'integer'},
    description       => {type => 'text'},
    biotype_group     => {type => 'enum', default => 'undefined', not_null => 1, 'values' => [qw(
                            coding
                            pseudogene
                            snoncoding
                            lnoncoding
                            mnoncoding
                            LRG
                            no_group
                            undefined)]
    }
  ],

  trackable             => 1,

  title_column          => 'name',

  inactive_flag_column  => 'is_current',

  relationships => [
    attrib_type       => {
      'type'        => 'one to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::AttribType',
      'column_map'  => {'attrib_type_id' => 'attrib_type_id'},
    }
  ]
);

1;
