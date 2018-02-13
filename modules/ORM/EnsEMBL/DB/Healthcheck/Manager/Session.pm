=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2018] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package ORM::EnsEMBL::DB::Healthcheck::Manager::Session;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::Rose::Manager);

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
