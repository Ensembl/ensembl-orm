package ORM::EnsEMBL::DB::Healthcheck::Manager::Session;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub fetch_single {
  ## fetches first or last session from the db for the given release
  ## @param Release
  ## @param 'first' or 'last' (defaults to 'last')
  ## @return ORM::EnsEMBL::DB::Healthcheck::Object::Session object if found any
  my ($self, $release, $first_or_last) = @_;
  return undef unless $release;

  my $session = $self->get_objects(
    query   => [
      'db_release'  => $release,
#       '!start_time' => undef,
#       '!end_time'   => undef,
    ],
    sort_by => sprintf('session_id %s', ($first_or_last ||= '') eq 'first' ? 'ASC' : 'DESC'),
    limit   => 1
  );
  return @$session ? $session->[0] : undef;
}

1;
