=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2024] EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::Rose::CustomColumn;

### Abstract base class for custom columns
### The child class needs to use one of the Rose::Metadata::Column classes as base along with this class to work properly

use strict;
use warnings;

use ORM::EnsEMBL::Utils::Exception;

sub new_from_existing {
  ## Returns a new column object after modifying the existing one
  ## @param Existing column object
  ## @return Custom column object (or undef if not successful)
  my $class = shift;
  my $self  = $_[0];

  if (ref $self && UNIVERSAL::isa($self, 'Rose::DB::Object::Metadata::Column')) {

    my @allowed_columns = $class->allowed_base_classes;
    throw(sprintf 'Only %s type columns can be converted to %s type columns', join(', ', map { $_->type } @allowed_columns), $class->type) unless grep $self->isa($_), @allowed_columns;

    $self = bless $self, $class;
    $self->init(%{$_[1] || {}});

    return $self;
  }
}

sub init_custom_column {
  ## Initialises the inflate and deflate triggers on the column values for faking them as the custom column type
  ## @return Custom column object
  my $self = shift;

  # Add triggers to modify column values
  $self->add_trigger(
    'event' => 'inflate',
    'name'  => 'value_to_value_class',
    'code'  => sub {
      my ($object, $value) = @_;
      $value = $self->value_class->new($value, $self, $object);
      return $value->inflate($self, $object);
    }
  );

  $self->add_trigger(
    'event' => 'deflate',
    'name'  => 'value_class_to_value',
    'code'  => sub {
      my ($object, $value) = @_;
      $value = $self->value_class->new($value, $self, $object);
      return $value->deflate($self, $object);
    }
  );

  return $self;
}

sub allowed_base_classes {
  ## @abstract
  ## Should return a list of classes that can be converted into the given custom column type
  throw('Abstract method not implemented.');
}

sub value_class {
  ## @abstract
  ## Should return the name of the class that will be instantiated to represent value of this column
  throw('Abstract method not implemented.');
}

sub type {
  ## @abstract
  ## Should return the type of the column
  throw('Abstract method not implemented.');
}

1;
