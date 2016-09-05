=head1 LICENSE

Copyright [1999-2016] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::Rose::Column::EnumColumn;

### Class for column type 'enum' for filtering out windows newline characters

use strict;
use warnings;

use parent qw(Rose::DB::Object::Metadata::Column::Enum);

sub constraint_values {
  ## Sets/Gets values should be added to the 'where' clause when retrieving objects from the db
  ## @param Arrayref of string values (empty array means no containst, all values will be allowed when selecting rows)
  my $self = shift;
  $self->{'_ens_constraint_values'} = shift @_ if @_;
  return $self->{'_ens_constraint_values'} || [];
}

1;
