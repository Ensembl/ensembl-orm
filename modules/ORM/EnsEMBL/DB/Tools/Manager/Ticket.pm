=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2017] EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::DB::Tools::Manager::Ticket;

use strict;

use parent qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::Ticket' };

sub is_ticket_name_unique {
  ## @return 1 is name is unique, 0 otherwise
  my ($self, $name) = @_;
  return $self->get_objects_count('query' => [ 'ticket_name' => $name ]) ? 0 : 1;
}

sub count_current_tickets {
  ## Counts all the tickets for the given user_id and session_id
  ## @param Hashref with keys:
  ##  - site_type   : Site type string value as defined in SiteDefs ENSEMBL_SITE_TYPE (required)
  ##  - type        : Type string (or arrayref of strings) for filtering the TicketType (optional)
  ##  - user_id     : ID of the user to filter the tickets with (optional)
  ##  - session_id  : Session id to filter the tickets with (optional)
  ## @return Integer count
  my ($self, $params) = @_;

  my $site_type = delete $params->{'site_type'} or throw("Please provide 'site_type' in the arguments.");
  my $query     = [ map { exists $params->{"${_}_id"} ? [ 'owner_id' => $params->{"${_}_id"}, 'owner_type' => $_ ] : () } qw(user session) ];
     $query     = @$query > 1 ? [ 'or' => [ map {('and' => $_)} @$query ] ] : $query->[0];

  push @$query, 'ticket_type_name'  => $params->{'type'} if exists $params->{'type'};
  push @$query, 'site_type'         => $site_type;

  return $self->get_objects_count('query' => $query);
}

1;
