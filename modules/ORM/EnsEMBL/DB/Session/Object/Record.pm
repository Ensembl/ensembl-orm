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

package ORM::EnsEMBL::DB::Session::Object::Record;

### NAME: ORM::EnsEMBL::DB::Session::Object::Record
### ORM class for the record table in session db

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::Session::Object);

__PACKAGE__->_meta_setup;

sub _meta_setup {
  ## Initialises database schema
  my $meta = shift->meta;
  $meta->table('record');
  $meta->auto_init_columns;
  $meta->column('data')->overflow('truncate');
  $meta->auto_initialize;
  $meta->datastructure_columns({'name' => 'data', 'trusted' => 1});
  $meta->column('record_type')->values(['session']);
  $meta->column('record_type')->constraint_values(['session']);
}

1;
