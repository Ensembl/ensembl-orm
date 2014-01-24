package ORM::EnsEMBL::DB::VegaProduction::Manager::Speciesstep;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub find_step {
  my ($self,$process,$script,$species) = @_;

  my $objs = __PACKAGE__->get_objects(
    with_objects => ['step','step.script','step.process','species'],
    query => [ 't4.process_id' => $process->process_id,
               't3.script_id' => $script->script_id,
               't5.species_id' => $species->species_id ],
  );
  unless(@$objs == 1) {
    return undef;
  }
  return $objs->[0];
}

1;

