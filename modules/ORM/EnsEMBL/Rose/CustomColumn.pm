package ORM::EnsEMBL::Rose::CustomColumn;

### Name: ORM::EnsEMBL::Rose::CustomColumn
### Base class for custom columns (the child class needs to use one of the Rose::Metadata::Column classes as base along with this class - MI)

use strict;
use warnings;

use ORM::EnsEMBL::Utils::Exception;

sub init_custom_column {
  my $class = shift;
  my $self  = $_[0];

  if (ref $self && UNIVERSAL::isa($self, 'Rose::DB::Object::Metadata::Column')) { # if trying to convert an existing column to a datastructure column

    my @allowed_columns = $class->allowed_base_classes;
    throw(sprintf 'Only %s type columns can be converted to %s type columns', join(', ' map { $_->type } @allowed_columns), $class->type) unless grep $self->isa($_), @allowed_columns;

    $self = bless $self, $class;
    $self->init(%{$_[1] || {}});
  } else {
    $self = $class->SUPER::new(@_);
  }

  # Add triggers to modify column values
  $self->add_trigger('inflate' => sub {
    my ($object, $value) = @_;
    return $self->value_class->new($value, $self);
  });

  $self->add_trigger('deflate' => sub {
    my ($object, $value) = @_;
    $value = $self->value_class->new($value, $self) unless UNIVERSAL::isa($value, $self->value_class);
    return $value->to_string;
  });

  return $self;
}

sub allowed_base_classes {
  ## Returns a list of classes that can be converted into the given custom column type
  ## Override this in child class to return the appropriate class names
  throw(sprintf 'Allowed base classes have not been defined for ', ref $_[0] || $_[0]);
}

sub value_class {
  ## Returns the name of the class that will be instantiated to represent value of this column
  ## Override this in child class to return the appropriate class name
  throw(sprintf 'Custom column value class has not been defined for ', ref $_[0] || $_[0]);
}

sub type {
  ## Returns the type of the column
  ## Override this in the child class to change column 'type'
  return 'custom';
}

1;
