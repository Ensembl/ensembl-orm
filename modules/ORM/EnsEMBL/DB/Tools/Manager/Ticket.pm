package ORM::EnsEMBL::DB::Tools::Manager::Ticket;

use strict;

use ORM::EnsEMBL::DB::Tools::Object::Ticket;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::Ticket' };

sub fetch_ticket_by_name {
  my ($self, $ticket_name) = @_;

  return $ticket_name ? $self->get_objects(
    with_objects => ['job_type'],
    query        => ['ticket_name' => $ticket_name ],
    limit        => 1
  )->[0] : undef;
}

sub fetch_all_tickets_by_user {
  my ($self, $user_id) = @_;

  return unless $user_id;

  return $self->get_objects(
    with_objects  => ['job_type'],
    query         => ['owner_id' => $user_id, 'owner_type' => 'user' ]
  );
}

sub fetch_all_tickets_by_session {
  my ($self, $session_id) = @_;

  return unless $session_id;

  return $self->get_objects(
    with_objects  => ['job_type'],
    query         => ['owner_id' => $session_id, 'owner_type' => 'session' ]
  );
}

1;

