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

package ORM::EnsEMBL::DB::Tools::Object::TicketType;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::Ticket; # for foreign key initialisation

use parent qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table           => 'ticket_type',
  auto_initialize => []
);

# exclude the 'Deleted' tickets when fetching
__PACKAGE__->meta->relationship('ticket')->query_args(['status' => {'ne' => 'Deleted'}]);

1;
