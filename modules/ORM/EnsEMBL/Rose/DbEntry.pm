package ORM::EnsEMBL::Rose::DbEntry;

### Extension to Rose::DB::Registry::Entry object to save an extra key 'trackable'

use strict;
use warnings;

use base qw(Rose::DB::Registry::Entry);

sub trackable {
  ## Saves the info about whether the database should respect the trackable info or not
  ## Method gets called when using ORM::EnsEMBL::Rose::DbConnection->register_db
  ## @return 1 or 0
  my $self = shift;
  $self->{'trackable'} = shift if @_;
  return $self->{'trackable'} || 0;
}

1;
