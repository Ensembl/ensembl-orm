package ORM::EnsEMBL::DB::Tools::Object::Ticket;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::Job; # for foreign key initialisation

use base qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table           => 'ticket',
  auto_initialize => []
);

{
  my $job_relationship = __PACKAGE__->meta->relationship('job');

  $job_relationship->method_name('count', 'job_count');
  $job_relationship->make_methods(
    preserve_existing => 1,
    types             => [ 'count' ]
  );
}

1;
