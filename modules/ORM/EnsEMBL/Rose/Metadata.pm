package ORM::EnsEMBL::Rose::Metadata;

## Name: ORM::EnsEMBL::Rose::Metadata
## Metadata class for all Rose Objects

use strict;

use ORM::EnsEMBL::Rose::VirtualColumn;
use ORM::EnsEMBL::Rose::VirtualRelationship;
use ORM::EnsEMBL::Rose::ExternalRelationship;

use ORM::EnsEMBL::Utils::Exception;

use base qw(Rose::DB::Object::Metadata);

use constant {
  EXTERNAL_RELATIONS_KEY_NAME => '__ens_external_relationships',
  VIRTUAL_COLUMNS_KEY_NAME    => '__ens_virtual_columns',
  VIRTUAL_RELATIONS_KEY_NAME  => '__ens_virtual_relationships'
};

sub setup {
  ## @overrides
  my ($self, %params) = @_;
  my @args;

  ## sort arguments to keep auto, table name, columns and relationships before any other keys (to make sure virtual columns, virtual relationships are initiated after columns and relationships)
  splice @args, ($_ =~ /^(table|columns|relationships|auto)$/ ? 0 : @args), 0, $_, $params{$_} for keys %params;

  return $self->SUPER::setup(@args);
}

sub trackable {
  ## Sets up trackable fields or tells whether the object isa Trackable object
  ## @param Flag if on will set up the trackable fields (ignores the off flag)
  my ($self, $flag) = @_;

  if ($flag) {

    my %columns       = $self->_trackable_columns;
    my %relationships = map { $columns{$_}{'relationship'} ? (delete $columns{$_}{'relationship'}, $_) : () } keys %columns;

    for (keys %columns) {
      $self->column($_, $columns{$_});
    }

    my $add_relationship = $self->class->ROSE_DB_NAME eq ORM::EnsEMBL::DB::Accounts::Object->ROSE_DB_NAME ? 'relationship' : 'external_relationship';
    for (keys %relationships) {

      $self->$add_relationship($_, {
        'type'        => 'many to one',
        'class'       => 'ORM::EnsEMBL::DB::Accounts::Object::User',
        'column_map'  => { $relationships{$_} => 'user_id' }
      });
    }

    $self->{'__ens_trackable'} = 1;
  }

  return $self->{'__ens_trackable'} ||= 0;
}

sub trackable_column_names {
  ## Gets the list of all the trackable column names if the object is trackable
  my $self = shift;
  return [ $self->trackable ? keys %{{$self->_trackable_columns}} : () ];
}

sub column_is_trackable {
  ## TODO - remove this one and use trackable_column_names instead
  ## Tells whether the given column is one among the trackable columns
  ## @param Column object or name
  my ($self, $column) = @_;
  $column = $column->name if ref $column;

  my %trackable_columns = $self->_trackable_columns;

  return exists $trackable_columns{$column};
}

sub datamap_columns {
  ## Returns the existing datamap columns or upgrades existing text columns to datamap columns
  ## @params List of: Column objects or hashref with structure {name => column_name, trusted => 1} or just name string (optional)
  ## @return Array or arrayref of the column objects
  return shift->_hybrid_columns('datamap', @_);
}

sub datastructure_columns {
  ## Returns the existing datastructure columns or upgrades existing text columns to datastructure columns
  ## @params List of: Column objects or hashref with structure {name => column_name, trusted => 1} or just name string (optional)
  ## @return Array or arrayref of the column objects
  return shift->_hybrid_columns('datastructure', @_);
}

sub virtual_columns {
  ## Method to set/get the virtual columns that are actually keys of some other column of type datamap
  ## @param Column names and details (hashref containtng key 'column' (required) and 'alias' (optional)) as a hash in arrayref syntax
  ## @return Array and Arrayref of the virtual column objects in list and scalar context respectively
  my $self      = shift;
  my $key_name  = $self->VIRTUAL_COLUMNS_KEY_NAME;

  if (@_) {

    my $object_class    = $self->class;
    $self->{$key_name}  = [];

    while (my ($col, $detail) = splice @_, 0, 2) {

      # column that contains the virtual columns
      if (my $datamap = $self->column($detail->{'column'})) {

        $self->datamap_columns($datamap); # change column type to datamap (if not already) as only a datamap column can contain virtual columns

        my $column  = ORM::EnsEMBL::Rose::VirtualColumn->new({
          'name'    => $col,
          'column'  => $datamap,
          'parent'  => $self,
          'alias'   => $detail->{'alias'} || undef,
          'default' => defined $detail->{'default'} ? $detail->{'default'} : undef
        });
        $column->make_methods;

        push @{$self->{$key_name}}, $column;
      } else {
        throw("No datamap column with name '$detail->{'column'}' found. Either this column name is invalid or columns need to be added before adding virtual columns");
      }
    }
  }
  return wantarray ? @{$self->{$key_name} || []} : [ map {$_} @{$self->{$key_name} || []} ];
}

sub virtual_column_names {
  ## Gets the names of all the virtual columns of the related object
  ## @return Array and Arrayref of the virtual column names in list and scalar context respectively
  my $self = shift;
  my @cols = map {$_->name} @{$self->{$self->VIRTUAL_COLUMNS_KEY_NAME}};
  return wantarray ? @cols : \@cols;
}

sub virtual_column {
  ## Gets the virtual column object for the given column name
  ## @param   Virtual column name
  ## @return  Virtual column object if found, undef otherwise
  my ($self, $column_name) = @_;
  $_->name eq $column_name and return $_ for @{$self->{$self->VIRTUAL_COLUMNS_KEY_NAME}};
  return undef;
}

sub title_column {
  ## Method of set/get the name of the column containg the title of the row
  ## @param Column name as string
  ## @return Column name as string
  my $self = shift;
  $self->{'__ens_title_column'} = shift if @_;
  return $self->{'__ens_title_column'};
}

sub inactive_flag_column {
  ## Method of set/get the name of the column used as a flag to tell whether the row should be considered active or not
  ## @param Column name as string
  ## @return Column name as string
  my $self = shift;
  $self->{'__ens_inactive_flag_column'} = shift if @_;
  return $self->{'__ens_inactive_flag_column'};
}

sub inactive_flag_value {
  ## Method of set/get the value to which if inactive_flag_column is set, row is considered as inactive
  ## @param String value
  ## @return String value
  my $self = shift;
  $self->{'__ens_inactive_flag_value'} = shift if @_;
  return $self->{'__ens_inactive_flag_value'} || '0';
}

sub external_relationship {
  ## Gets/sets an external relationship
  ## @param External relation name
  ## @param Hashref for keys: (optional - will return the existing saved relationship if missed)
  ##  - class       Name of the class of the related object
  ##  - column_map  Hashref of internal_column => external column mapping the relationshop
  ##  - type        one to one, many to one etc
  ## @return External relationship object (or undef if no relation found for the given name)
  my ($self, $relationship_name, $params) = @_;

  my $object_class = $self->class;
  my $key_name     = $self->EXTERNAL_RELATIONS_KEY_NAME;

  if ($params) {
    my $relationship = $self->{$key_name}{$relationship_name} = ORM::EnsEMBL::Rose::ExternalRelationship->new({'name', $relationship_name, %$params});
    $relationship->make_methods('target_class' => $object_class);
  }

  return $self->{$key_name}{$relationship_name};
}

sub external_relationships {
  ## Gets/sets all the external relationships
  ## Functionality similar to Rose::Db::Object::Metadata::relationships method, but not same
  ## Methods camouflaged as relationship methods are created if two related objects not residing on the same table
  ## @param Hash of name - settings pair for external relationships (setting is hashref with keys class, column_map and type)
  my ($self, %relationships) = @_;
  while (my ($name, $settings) = each %relationships) {
    $self->external_relationship($name, $settings);
  }
  return [values %{$self->{$self->EXTERNAL_RELATIONS_KEY_NAME} ||= {}}];
}

sub virtual_relationships {
  ## Gets/sets virtual relationships - relationships that actually fall under a common relationship, but have a condition that is used to differentiate them
  ## @param Relationship names and details (hashref containtng key 'relationship' and 'condition' - both required) as a hash in arrayref syntax
  ## @return Array and Arrayref of the virtual relationship objects in list and scalar context respectively
  my $self      = shift;
  my $key_name  = $self->VIRTUAL_RELATIONS_KEY_NAME;

  if (@_) {

    my $object_class    = $self->class;
    $self->{$key_name}  = [];

    while (my ($relationship_name, $detail) = splice @_, 0, 2) {

      my $relationship = $self->relationship($detail->{'relationship'});
      throw("No relationship with name '$detail->{'relationship'}' found. Either this relationship name is invalid or relationships need to be added before adding virtual relationships") unless $relationship;
      throw("Relationship '$detail->{'relationship'}' is required to be of type '* to many' for categorising it into virtual relationships.") unless $relationship->type =~ /to many$/;

      my $virtual_relationship = ORM::EnsEMBL::Rose::VirtualRelationship->new({'name' => $relationship_name, 'relationship' => $relationship, 'condition' => $detail->{'condition'}, 'parent' => $self});
      $virtual_relationship->make_methods;

      push @{$self->{$key_name}}, $virtual_relationship;
    }
  }
  return wantarray ? @{$self->{$key_name} || []} : [ map {$_} @{$self->{$key_name} || []} ];
}

sub virtual_relationship {
  ## Gets the virtual relationship object for the given name
  ## @param   Virtual relationship name
  ## @return  Virtual relationship object if found, undef otherwise
  my ($self, $relation_name) = @_;
  $_->name eq $relation_name and return $_ for @{$self->{$self->VIRTUAL_RELATIONS_KEY_NAME}};
  return undef;
}

sub _hybrid_columns {
  ## @private
  my ($self, $type) = splice @_, 0, 2;
  my $col_classes   = $self->column_type_classes;

  for (@_) {
    $_ = {'name' => $_} unless ref $_;

    my ($col, $params);
    if (UNIVERSAL::isa($_, 'Rose::DB::Object::Metadata::Column')) {
      $col    = $_;
      $params = {};
    } else {
      $col    = $self->column(delete $_->{'name'});
      $params = $_;
    }
    my $ctype = $col->type;
    if ($ctype ne $type) {
      $col_classes->{$type}->new($col, $params);
    }
  }

  my @cols = grep { $_->type eq $type } $self->columns;

  return wantarray ? @cols : \@cols;
}

sub _trackable_columns {
  ## @private
  return (
    'created_by'    => { type => 'integer', relationship => 'created_by_user'   },
    'modified_by'   => { type => 'integer', relationship => 'modified_by_user'  },
    'created_at'    => { type => 'datetime' },
    'modified_at'   => { type => 'datetime' }
  );
}

1;
