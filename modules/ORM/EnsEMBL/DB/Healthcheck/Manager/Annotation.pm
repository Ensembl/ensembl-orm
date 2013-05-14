package ORM::EnsEMBL::DB::Healthcheck::Manager::Annotation;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Healthcheck::Object::Annotation;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Healthcheck::Object::Annotation' }

1;