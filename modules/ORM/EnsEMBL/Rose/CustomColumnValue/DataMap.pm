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

package ORM::EnsEMBL::Rose::CustomColumnValue::DataMap;

## Class representing the value provided to column type 'datamap'

use strict;
use warnings;

use ORM::EnsEMBL::Utils::Exception;

use parent qw(ORM::EnsEMBL::Rose::CustomColumnValue::DataStructure);

sub new {
  ## @override
  ## @constructor
  ## @exception If data is not a hash 
  my ($class, $data) = splice @_, 0, 2;
  my $self = $class->SUPER::new($data || {}, @_);
  throw('Column of type datatype can only accept stringified hash values.') unless $self->isa('HASH');

  return $self;
}

sub deflate {
  ## @override
  ## Adds default values to the virtual keys before deflating the column value
  my ($self, $column) = splice @_, 0, 2;
  $column->set_default_values($self);
  return $self->SUPER::deflate($column, @_);
}

sub has_key {
  ## Tells whether a key exists in the datamap or not
  ## @param String value of the key
  my ($self, $key) = @_;
  return exists $self->{$key};
}

1;
