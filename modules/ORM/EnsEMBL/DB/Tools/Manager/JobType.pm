package ORM::EnsEMBL::DB::Tools::Manager::JobType;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::JobType;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::JobType' }

sub get_job_type_id_by_name {
  my ($self, $name) = @_;

  if ($name) {
    my ($job_type) = @{$self->get_objects('query' => [ 'job_type' => $name ], 'limit' => 1)};
    return $job_type->job_type_id if $job_type;
  }
}

1;

