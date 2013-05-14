package ORM::EnsEMBL::Rose::CustomColumn::DataMap;

### Name: ORM::EnsEMBL::Rose::CustomColumn::DataMap
### Class for column type 'datamap' corresponding to single dimensional Hash
### Together with ORM::EnsEMBL::Rose::VirtualColumn, this package enables to access keys of this column as method names to the actual rose object

### Reserved keys:
### Since keys for the datamap can be accessed as methods on the rose object, any method name that is reserved in the rose object should be provided an 'alias' name

### Example:
### package MyObject;
### use base qw(Rose::DB::Object);
### __PACKAGE__->meta->setup(
###   columns => [
###     'data'  => {'type' => 'datamap', 'trusted' => 1, 'not_null' => 1} # trusted specifies that the value can always be trusted to eval into a hash without any errors
###   ],
###   virtual_columns => [
###     'name'  => {'column' => 'data'},
###     'db'    => {'column' => 'data', 'alias' => 'data_db'} # this column will be accessible by method 'data_db' not 'db'
###   ]
### );

use strict;

use ORM::EnsEMBL::Rose::CustomColumnValue::DataMap;

use base qw(ORM::EnsEMBL::Rose::CustomColumn::DataStructure);

sub new {
  ## @overrides
  ## Provides default values to virtual columns after creating a new object
  my $self = shift->SUPER::new(@_);

  my $set_default_values = sub {
    my ($object, $column) = @_;
    for ($object->meta->virtual_columns) {
      if ($_->column eq $column && $_->default_exists) {
        my $current_val = $object->virtual_column_value($_);
        my $default_val = $_->default;
        $object->virtual_column_value($_, $default_val) if not defined $current_val || $current_val eq '' && $default_val ne '';
      }
    }
  };

  $self->delete_trigger('event' => 'deflate', 'name' => 'value_class_to_value');

  $self->add_trigger(
    'event' => 'deflate',
    'name'  => 'datamap_value_class_to_value',
    'code'  => sub {
      my ($object, $value) = @_;
      $value = $self->value_class->new($value, $self) unless UNIVERSAL::isa($value, $self->value_class);
      $set_default_values->($object, $self);
      return $value->to_string;
    }
  );

  $self->add_trigger(
    'event' => 'on_get',
    'name'  => 'set_defaults',
    'code'  => sub {
      my ($object, $value) = @_;
      $value = $self->value_class->new($value, $self) unless UNIVERSAL::isa($value, $self->value_class);
      $set_default_values->($object, $self);
      return $value;
    }
  );
  
  return $self;
}

sub value_class {
  ## @overrides
  return 'ORM::EnsEMBL::Rose::CustomColumn::DataMap';
}

sub type {
  ## @overrides
  return 'datamap';
}

1;
