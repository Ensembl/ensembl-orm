package ORM::EnsEMBL::DB::Tools::Object::TicketType;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::Ticket; # for foreign key initialisation

use base qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table           => 'ticket_type',
  auto_initialize => []
);

1;
