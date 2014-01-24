package ORM::EnsEMBL::DB::VegaProduction::Manager::Process;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub from_code {
  my ($self,$code) = @_;

  my $script = $self->object_class->new(code => $code);
  return undef unless $script->load();
  return $script;
}

1;

