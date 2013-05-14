package ORM::EnsEMBL::DB::Production::Manager::AnalysisDescription;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Production::Object::AnalysisDescription;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Production::Object::AnalysisDescription' }

1;