=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2021] EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::Rose::TextColumn;

### Class for column type 'text' for filtering out windows newline characters

use strict;
use warnings;

use parent qw(Rose::DB::Object::Metadata::Column::Text);

sub init {
  ## @override
  ## Adds a 'deflate' trigger to filter out carriage returns among newline characters
  my $self = shift;

  $self->SUPER::init(@_);

  $self->add_trigger(
    'event' => 'deflate',
    'name'  => 'remove_windows_newline',
    'code'  => sub {
      my ($object, $value) = @_;
      $value =~ s/\r\n?/\n/g if defined $value;
      return $value;
    }
  );
}

1;
