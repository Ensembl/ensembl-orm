package ORM::EnsEMBL::DB::Tools::Manager::TicketType;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::TicketType;
use ORM::EnsEMBL::Utils::Exception;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::TicketType' }

sub fetch_with_current_tickets {
  ## Gets the TicketType objects with linked Ticket objects belonging to given user 'or' the session
  ## @param Hashref with keys:
  ##  - site_type   : Site type string value as defined in SiteDefs ENSEMBL_SITE_TYPE (required)
  ##  - type        : Type string (or arrayref of strings) for filtering the TicketType (optional)
  ##  - ticket_name : String (or arrayref of strings) for filtering the tickets (optional)
  ##  - user_id     : ID of the user to filter the tickets with (optional)
  ##  - session_id  : Session id to filter the tickets with (optional)
  ## @return ArrayRef of TicketType objects
  my ($self, $params) = @_;

  my $site_type = delete $params->{'site_type'} or throw("Please provide 'site_type' in the arguments.");
  my $query     = [ map { exists $params->{"${_}_id"} ? [ 'ticket.owner_id' => $params->{"${_}_id"}, 'ticket.owner_type' => $_ ] : () } qw(user session) ];
     $query     = @$query > 1 ? [ 'or' => [ map {('and' => $_)} @$query ] ] : $query->[0];

  push @$query, 'ticket_type_name'    => $params->{'type'}        if exists $params->{'type'};
  push @$query, 'ticket.ticket_name'  => $params->{'ticket_name'} if exists $params->{'ticket_name'};
  push @$query, 'ticket.site_type'    => $site_type;

  return $self->get_objects(
    'with_objects'  => ['ticket', 'ticket.job'],
    'multi_many_ok' => 1,
    'query'         => $query
  );
}

sub fetch_with_given_job {
  ## Gets the TicketType objects with linked Ticket object, and it's linked job and optionally result objects for a given job_id, belonging to given user 'or' the session
  ## @param Hashref with keys:
  ##  - site_type     : Site type string value as defined in SiteDefs ENSEMBL_SITE_TYPE (required)
  ##  - type          : Type string (or arrayref of strings) for filtering the TicketType (required)
  ##  - ticket_name   : Ticket name (required)
  ##  - job_id        : Job id of the required job (required)
  ##  - result_id     : Result id if only one result is required, 'all' if all are required (don't provide this key if no result objects)
  ##  - user_id       : ID of the user to filter the tickets with (optional)
  ##  - session_id    : Session id to filter the tickets with (optional)
  ## @return TicketType object, only if job object is found (may or may not have related results objects)
  my ($self, $params) = @_;

  my $site_type         = delete $params->{'site_type'}   or throw("Please provide 'site_type' in the arguments.");
  my $ticket_name       = delete $params->{'ticket_name'} or throw("Please provide 'ticket_name' in the arguments.");
  my $ticket_type_name  = delete $params->{'type'}        or throw("Please provide 'type' in the arguments.");
  my $job_id            = delete $params->{'job_id'}      or throw("Please provide 'job_id' in the arguments.");

  my $query             = [ map { exists $params->{"${_}_id"} ? [ 'ticket.owner_id' => $params->{"${_}_id"}, 'ticket.owner_type' => $_ ] : () } qw(user session) ];
     $query             = @$query > 1 ? [ 'or' => [ map {('and' => $_)} @$query ] ] : $query->[0];

  push @$query, ('ticket.job.result.result_id' => $params->{'result_id'} || 0) if exists $params->{'result_id'} && $params->{'result_id'} ne 'all';
  push @$query, ('ticket_type_name' => $ticket_type_name, 'ticket.ticket_name' => $ticket_name, 'ticket.site_type' => $site_type, 'ticket.job.job_id' => $job_id);

  return $self->get_objects(
    'with_objects'  => ['ticket', 'ticket.job', exists $params->{'result_id'} ? 'ticket.job.result' : ()],
    'multi_many_ok' => 1,
    'query'         => $query
  )->[0];
}

1;
