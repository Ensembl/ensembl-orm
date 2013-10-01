package ORM::EnsEMBL::DB::Tools::Object::Ticket;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::Job; # for foreign key initialisation

use base qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table           => 'ticket',
  auto_initialize => []
);

1;
