package ORM::EnsEMBL::DB::Tools::Manager::Job;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::Job;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::Job' }

sub get_job_id_by_name {
  my ($self, $name) = @_;
  return undef unless $name;

  my $jobs = $self->get_objects(
    query => [job_type => $name]
  );

  return $jobs->[0]->job_type_id;
}

1;

