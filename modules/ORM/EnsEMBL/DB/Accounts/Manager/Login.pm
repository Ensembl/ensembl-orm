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

package ORM::EnsEMBL::DB::Accounts::Manager::Login;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::Rose::Manager);

sub get_with_user {
  ## Gets a Login object for given identity column value, can be an openid url or email for local accounts OR primary key
  ## @param Identity value, or primary key value
  ## @return Single login object or undef is nothing found
  my ($self, $key) = @_;

  return shift @{$self->get_objects(
    'query'         => [ ($key =~ /^[0-9]+$/ ? 'login_id' : 'identity'), $key ],
    'with_objects'  => ['user'],
    'limit'         => 1
  )};
}

1;