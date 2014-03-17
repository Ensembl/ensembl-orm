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

package ORM::EnsEMBL::DB::Accounts::Manager::Group;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::Rose::Manager);

sub fetch_with_members {
  ## Fetchs group(s) with given id(s) along with it's members
  ## @param Group id OR ArrayRef of group ids if multiple groups
  ## @param Flag if on, will return the active only users
  ## @return Rose::Object drived object, or arrayref of same if arrayref of ids provided as argument
  my ($self, $ids, $active_only) = @_;
  
  return unless $ids;
  
  my $method          = ref $ids eq 'ARRAY' ? 'fetch_by_primary_keys' : 'fetch_by_primary_key';
  my $params          = {'with_objects' => ['memberships', 'memberships.user'], 'sort_by' => 'user.name'};
  $params->{'query'}  = ['memberships.member_status', 'active', 'memberships.status', 'active'] if $active_only;

  return $self->$method($ids, $params);
}

1;