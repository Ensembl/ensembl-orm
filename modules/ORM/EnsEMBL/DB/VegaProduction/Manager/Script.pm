package ORM::EnsEMBL::DB::VegaProduction::Manager::Script;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::Rose::Manager);

sub from_code {
  my ($self,$code) = @_;

  my $script = $self->object_class->new(code => $code);
  return undef unless $script->load();
  return $script;
}

1;

