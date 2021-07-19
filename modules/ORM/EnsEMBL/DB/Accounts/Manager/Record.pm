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

package ORM::EnsEMBL::DB::Accounts::Manager::Record;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::Rose::Manager);

sub get_user_records  { return shift->_get_records('user', @_);       } ## Wrapper around get_objects method to filter records by record type user  ## @params As accepted by get_objects
sub get_group_records { return shift->_get_records('group', @_);      } ## Wrapper around get_objects method to filter records by record type group ## @params As accepted by get_objects

sub get_saved_config {
  my ($self, $code) = @_;

  my $records = $self->get_objects('query' => ['code' => $code, 'type' => 'saved_config'], 'limit' => 1);

  return $records && $records->[0] && $records->[0]->data->raw;
}

sub _get_records {
  ## @private
  my ($self, $type, %params) = @_;

  push @{$params{'query'} ||= []}, 'record_type', $type;
  return $self->get_objects(%params);
}

1;
