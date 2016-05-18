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

package ORM::EnsEMBL::DB::Session::Manager::Session;

use strict;
use warnings;

use ORM::EnsEMBL::Utils::Exception;

use parent qw(ORM::EnsEMBL::Rose::Manager);

sub create_session_id {
  my $self = shift;

  my $row     = $self->get_objects({'limit' => 1, 'lock' => {'type' => 'for update', 'tables' => ['session']}, debug => 1})->[0] || $self->create_empty_object({'last_session_id' => 0});
  my $new_id  = $row->last_session_id + 1;

  $row->last_session_id($new_id);
  $row->save;

  return $new_id;
}

1;
