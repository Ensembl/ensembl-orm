package ORM::EnsEMBL::DB::Tools::Manager::Ticket;

use strict;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::Ticket' };

sub is_ticket_name_unique {
  ## @return 1 is name is unique, 0 otherwise
  my ($self, $name) = @_;
  return $self->get_objects_count('select' => ['ticket_name'], 'query' => [ 'ticket_name' => $name ]) ? 0 : 1;
}

1;