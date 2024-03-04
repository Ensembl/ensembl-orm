=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2024] EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::DB::Tools::Manager::TicketType;

use strict;
use warnings;

use ORM::EnsEMBL::Utils::Exception;

use parent qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::TicketType' }

sub fetch_with_current_tickets {
  ## Gets the TicketType objects with linked Ticket objects (and Job objects) belonging to given user + session
  ## @param Hashref with keys:
  ##  - site_type   : Site type string value as defined in SiteDefs ENSEMBL_SITE_TYPE (required)
  ##  - type        : Type string (or arrayref of strings) for filtering the TicketType (optional)
  ##  - user_id     : ID of the user to filter the tickets (required if session_id is missing)
  ##  - session_id  : Session id to filter the tickets (required if user_id is missing)
  ## @return ArrayRef of TicketType objects
  my ($self, $params) = @_;

  # required parameter
  my $site_type = delete $params->{'site_type'} or throw("Please provide 'site_type' in the arguments.");

  # include results for both user and session
  my $query = [ map { $params->{"${_}_id"} ? [ 'ticket.owner_id' => $params->{"${_}_id"}, 'ticket.owner_type' => $_ ] : () } qw(user session) ];
     $query = @$query > 1 ? [ 'or' => [ map {('and' => $_)} @$query ] ] : $query->[0];

  # at least one out of session and user is required
  throw("Please provide 'session_id' or 'user_id' in the arguments.") unless $query;

  push @$query, 'ticket_type_name'  => $params->{'type'} if $params->{'type'};
  push @$query, 'ticket.site_type'  => $site_type;

  return $self->get_objects(
    'with_objects'  => ['ticket', 'ticket.job'],
    'multi_many_ok' => 1,
    'query'         => $query
  );
}

sub fetch_with_requested_ticket {
  ## Gets the TicketType objects with linked Ticket object, and it's linked jobs and optionally result objects for the requested ticket that belongs to either given user or session
  ## @param Hashref with keys:
  ##  - site_type     : Site type string value as defined in SiteDefs ENSEMBL_SITE_TYPE (required)
  ##  - ticket_name   : Ticket name (required)
  ##  - job_id        : Job id of the required job or 'all' if all jobs are required (if not provided or value is false, no job objects will be returned)
  ##  - type          : Type string (or arrayref of strings) for filtering the TicketType (optional)
  ##  - result_id     : Result id if only one result is required, 'all' if all are required (if key not provided or value is false, no result objects are returned)
  ##  - user_id       : ID of the user to filter the ticket (required if session_id is missing)
  ##  - session_id    : Session id to filter the ticket (required if user_id is missing)
  ##  - public_ok     : Flag if on, will return the ticket even if it doesn't belong to the given user or session but has visibility 'public'
  ## @return TicketType object, only if job object is found (may or may not have related results objects)
  my ($self, $params) = @_;

  # required params
  my $site_type         = delete $params->{'site_type'}   or throw("Please provide 'site_type' in the arguments.");
  my $ticket_name       = delete $params->{'ticket_name'} or throw("Please provide 'ticket_name' in the arguments.");
  my $ticket_type_name  = delete $params->{'type'};

  # ticket could either belong to user or session
  my $query = [ $params->{'public_ok'} ? [ 'ticket.visibility' => 'public' ] : (), map { $params->{"${_}_id"} ? [ 'ticket.owner_id' => $params->{"${_}_id"}, 'ticket.owner_type' => $_ ] : () } qw(user session) ];
     $query = @$query > 1 ? [ 'or' => [ map {('and' => $_)} @$query ] ] : $query->[0];

  # at least one out of session and user is required
  throw("Please provide 'session_id' or 'user_id' in the arguments.") unless $query;

  push @$query, ('ticket.job.job_id' => $params->{'job_id'}) if $params->{'job_id'} && $params->{'job_id'} ne 'all';
  push @$query, ('ticket.job.result.result_id' => $params->{'result_id'}) if $params->{'result_id'} && $params->{'result_id'} ne 'all';
  push @$query, ('ticket.ticket_name' => $ticket_name, 'ticket.site_type' => $site_type, $ticket_type_name ? ('ticket_type_name' => $ticket_type_name) : ());

  return $self->get_objects(
    'with_objects'  => ['ticket', $params->{'job_id'} ? 'ticket.job' : (), $params->{'result_id'} ? 'ticket.job.result' : ()],
    'multi_many_ok' => 1,
    'query'         => $query
  )->[0];
}

1;
