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

package ORM::EnsEMBL::DB::Tools::Object::JobMessage;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::Tools::Object);

{
  my $meta = __PACKAGE__->meta;
  $meta->table('job_message');
  $meta->auto_init_columns;
  $meta->column('display_message')->overflow('truncate');
  $meta->auto_initialize;
  $meta->datastructure_columns(map {'name' => $_, 'trusted' => 1}, qw(exception data));
}

1;
