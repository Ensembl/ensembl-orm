package ORM::EnsEMBL::DB::VegaProduction::Manager::Rule;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub all_from_speciesstep {
  my ($self,$ss) = @_;

  my $explicit = __PACKAGE__->get_objects(
    with_objects => ['speciesstepset','speciesstepset.speciesstep'],
    query => [ 't2.speciesstep_id' => $ss->speciesstep_id ],
  );
  my $extra = __PACKAGE__->get_objects(
    query => [ 'speciesstepset_id' => undef ],
  );
  return [@$explicit,@$extra];
}

1;

