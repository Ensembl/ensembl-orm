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

sub value_class {
  ## @overrides
  return 'ORM::EnsEMBL::Rose::CustomColumn::DataMap';
}

sub type {
  ## @overrides
  return 'datamap';
}

1;