package ORM::EnsEMBL::DB::VegaProduction::Manager::Species;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::Rose::Manager);
    
sub from_any_name {
  my ($self,$name) = @_;

  my $obj = $self->object_class->new(scientific_name => $name);
  return $obj if $obj->load;
  $obj = $self->object_class->new(production_name => $name);
  return $obj if $obj->load;
  $obj = $self->object_class->new(display_name => $name);
  return $obj if $obj->load;
  $obj = $self->object_class->new(common_name => $name);
  return $obj if $obj->load;
  return undef;
}

1;

