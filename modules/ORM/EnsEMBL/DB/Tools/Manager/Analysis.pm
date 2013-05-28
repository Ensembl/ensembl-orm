package ORM::EnsEMBL::DB::Tools::Manager::Analysis;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::Analysis;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::Analysis' }

sub retrieve_analysis_object {
  my ($self, $ticket_id) = @_;
  return undef unless $ticket_id;

  my $analysis = $self->get_objects(
    query => ['ticket_id' => $ticket_id]
  );

  my $object = $analysis->[0]->object;
  return $object;
}

1;


