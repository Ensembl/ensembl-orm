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

package ORM::EnsEMBL::DB::Accounts::Manager::User;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::Rose::Manager);

sub get_by_id {
  ## Gets user by id
  ## @param String id
  ## @return User object
  my ($class, $id) = @_;

  return $id ? $class->fetch_by_primary_key($id) : undef;
}

sub get_by_email {
  ## Gets user by email
  ## @param String email
  ## @return User object
  my ($class, $email) = @_;

  return shift @{$email ? $class->get_objects('query' => [ 'email', $email ]) : []};
}

1;