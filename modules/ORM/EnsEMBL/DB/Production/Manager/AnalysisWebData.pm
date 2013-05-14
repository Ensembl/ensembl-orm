package ORM::EnsEMBL::DB::Production::Manager::AnalysisWebData;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Production::Object::AnalysisWebData;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Production::Object::AnalysisWebData' }

1;