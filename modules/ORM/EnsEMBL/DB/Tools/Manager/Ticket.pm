package ORM::EnsEMBL::DB::Tools::Manager::Ticket;

use strict;

use ORM::EnsEMBL::DB::Tools::Object::Ticket;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::Ticket' };

sub fetch_by_ticket_name {
  my ($self, $ticket_name) = @_;
  return undef unless $ticket_name;

  my $ticket = $self->get_objects(
    with_objects => ['job'],
    query => ['ticket_name' => $ticket_name ]
  );
  return $ticket;
}

sub fetch_all_tickets_by_user {
  my ($self, $user_id) = @_;
  return undef unless $user_id;

  $user_id = 'user_' .$user_id;
  my $user_tickets =  $self->get_objects(
    with_objects => ['job'],
    query => ['owner_id' => $user_id ]
  );
  return $user_tickets;
}

sub fetch_all_tickets_by_session {
  my ($self, $session_id) = @_;
  return undef unless $session_id;

  $session_id = 'session_' .$session_id;
  my $session_tickets =  $self->get_objects(
    query => ['owner_id' => $session_id ]
  );
  return $session_tickets;
}

1;

