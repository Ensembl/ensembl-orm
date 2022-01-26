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

package ORM::EnsEMBL::DB::Production::Object::ExternalDb;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table                 => 'master_external_db',

  columns               => [
    external_db_id        => {'type' => 'serial',   'not_null' => 1,  'length' => 5,     'primary_key' => 1},
    db_name               => {'type' => 'varchar',  'not_null' => 1,  'length' => 100},
    db_release            => {'type' => 'varchar',                    'length' => 255},
    status                => {'type' => 'enum',     'not_null' => 1,  'values' => [qw(KNOWNXREF KNOWN XREF PRED ORTH PSEUDO)]},
    priority              => {'type' => 'int',      'not_null' => 1,  'length' => 11},
    db_display_name       => {'type' => 'varchar',  'not_null' => 1,  'length' => 255},
    type                  => {'type' => 'enum',                       'values' => [qw(ARRAY ALT_TRANS ALT_GENE MISC LIT PRIMARY_DB_SYNONYM ENSEMBL)]},
    secondary_db_name     => {'type' => 'varchar',                    'length' => 255},
    secondary_db_table    => {'type' => 'varchar',                    'length' => 255},
    description           => {'type' => 'text'}, 
    is_current            => {'type' => 'int',      'not_null' => 1,  'length' => 1,     'default' => 1}
  ],
  
  trackable             => 1,

  unique_key            => [qw(db_name is_current)],

  title_column          => 'db_name',

  inactive_flag_column  => 'is_current'
);

1;