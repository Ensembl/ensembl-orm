package ORM::EnsEMBL::DB::Tools::Manager::SubJob;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::SubJob;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::SubJob' }

sub fetch_by_id {
  my ($self, $id) = @_;
  my $sub_job = $self->get_objects(
    query => ['sub_job_id' => $id]
  );

  return $sub_job->[0];
}

1;

