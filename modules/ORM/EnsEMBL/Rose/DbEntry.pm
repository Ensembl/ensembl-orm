=head1 LICENSE

Copyright [1999-2014] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::Rose::DbEntry;

### Extension to Rose::DB::Registry::Entry object to save an extra key 'trackable'

use strict;
use warnings;

use parent qw(Rose::DB::Registry::Entry);

sub trackable {
  ## Saves the info about whether the database should respect the trackable info or not
  ## Method gets called when using ORM::EnsEMBL::Rose::DbConnection->register_db
  ## @return 1 or 0
  my $self = shift;
  $self->{'trackable'} = shift if @_;
  return $self->{'trackable'} || 0;
}

1;
