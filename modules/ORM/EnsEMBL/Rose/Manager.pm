=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016] EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::Rose::Manager;

### Static class, extended from Rose::DB::Object::Manager
### Parent class for all the rose object manager classes. Provides some generic data mining methods.

use strict;
use warnings;

use ORM::EnsEMBL::Utils::Exception;
use ORM::EnsEMBL::Utils::Helper qw(load_package);

use parent qw(Rose::DB::Object::Manager);

sub get_objects {
  ## @overrides
  ## DO NOT OVERRIDE
  ## Wrapper to the manager's inbuilt get_objects method to provide 5 extra features:
  ##  - Getting all the externally related objects in a single method call, and a minimum possible number of sql queries
  ##  - Excludes the 'retired' rows, by default; includes if flag set false
  ##  - Warns all the sql queries done by rose if Object::DEBUG_SQL constant is set true
  ##  - Force returns an arrayref (no wantarray check)
  ##  - Error handling - TODO
  ## @param Hash, as accepted by default get_objects method (of Rose::DB::Object::Manager class) along with two extra keys as below:
  ##  - with_external_objects : ArrayRef of external relationship name as declared in meta->setup of the rose object
  ##  - active_only           : Flag, if on, will fetch active rows only (flag on by default)
  ## @return ArrayRef of objects, or undef if any error
  ## @example $manager->get_objects(
  ##   query                  => ['record_id' => 1, '!annotation.text' => undef],
  ##   with_objects           => ['annotation'],
  ##   with_external_objects  => ['created_by_user', 'annotation.created_by_user', 'annotation.modified_by_user'], #annotation is intermediate object, also included in with_objects
  ##   active_only            => 0
  ## )
  ## @note If any query param contains inactive_flag_column, set active_only => 0 always.
  ## @note If an externally related object is not directly related to the object, make sure the intermediate object is included in with_objects key.
  my ($self, %params) = shift->normalize_get_objects_args(@_);

  my $object_class = load_package($params{'object_class'} || $self->object_class_name);

  ######### This method is also called by Rose API sometimes. ###########
  ###            We don't want to override it for Rose                ###
  my $caller = caller;                                                ###
  return $self->SUPER::get_objects(%params) if $caller !~ /EnsEMBL/;  ###
  #########                   That's it!                      ###########

  my $with_e_objects  = delete $params{'with_external_objects'};
  $params{'debug'}    = 1 if $object_class->DEBUG_SQL;

  # 'where' is an alias for 'query'
  $params{'query'} = delete $params{'where'} if !$params{'query'} && $params{'where'};

  $self->_add_column_constraint_query(\%params);
  $self->_add_active_only_query(\%params) if exists $params{'active_only'} ? delete $params{'active_only'} : 1;

  my $objects = $self->SUPER::get_objects(%params);

  # return objects if no external object needed, or if no object found
  return $objects unless $with_e_objects && @$with_e_objects && $objects && @$objects;

  # parse the with_external_objects string values
  my $external_rels = [];
  foreach my $with_e_object (@$with_e_objects) {
    $with_e_object = [ split /\./, $with_e_object ];
    push @$external_rels, {
      'external_relation'       => pop @$with_e_object,
      'intermediate_relations'  => $with_e_object
    };
  }

  # get foreign ids for getting all the externally related objects
  my $relation_cache    = {}; # cache the ExternalRelationship object to avoid multiple queries to metadata of the object directly related to external object
  my $required_objects  = {}; # example structure: {'ORM::EnsEMBL::Rose::Object::Record' => {'record_id' => {'102' => Rose object with record_id 102}}}
  my $internal_objects  = [];
  foreach my $object (@$objects) {
    foreach my $external_relation (@$external_rels) {
      my $relationship_name = $external_relation->{'external_relation'};
      foreach my $object_related_to_external_object (@{$self->_objects_related_to_external_object($object, [ map {$_} @{$external_relation->{'intermediate_relations'}} ])}) {
        my $relationship = $relation_cache->{ref $object_related_to_external_object}{$relationship_name} ||= $object_related_to_external_object->meta->external_relationship($relationship_name);
        my ($internal_column, $external_column) = %{$relationship->column_map};
        if (my $foreign_key_value = $object_related_to_external_object->$internal_column) {
          $required_objects->{$relationship->class}{$external_column}{$foreign_key_value} = 1;
          push @$internal_objects, $object_related_to_external_object, $relationship_name, [$relationship->class, $external_column, $foreign_key_value];
        }
      }
    }
  }

  # Get all the external objects with min possible queries
  while (my ($object_class, $column_values) = each %$required_objects) {
    while (my ($foreign_key_name, $foreign_keys_map) = each %$column_values) {
      $required_objects->{$object_class}{$foreign_key_name} = {map {$_->$foreign_key_name => $_} @{$self->get_objects(
        'object_class'  => $object_class,
        'query'         => [$foreign_key_name, [ keys %$foreign_keys_map ]],
        'active_only'   => 0
      )}};
    }
  }

  # save the external objects to the corresponding linked rose objects
  my $hash_key_name = $object_class->meta->EXTERNAL_RELATIONS_KEY_NAME;
  while (my $object_related_to_external_object = shift @$internal_objects) {
    my $relationship_name = shift @$internal_objects;
    my $path              = shift @$internal_objects;
    $object_related_to_external_object->{$hash_key_name}{$relationship_name} = $required_objects->{$path->[0]}{$path->[1]}{$path->[2]};
  }

  return $objects;
}

sub object_class {
  ## Returns the corresponding object class after loading it
  ## Don't override this one in child class, override object_class_name method instead
  return load_package(shift->object_class_name);
}

sub object_class_name {
  ## Returns the name of the object class for the manager
  ## Override this in child class if namespace for the object class is different (although not recommended to keep it different)
  throw("Method object_class_name can not be called on base Manager class. Either provide 'object_class' as a key in the argument hash of the required method or call 'object_class_name' on Manager drived class.") if $_[0] eq __PACKAGE__;
  return $_[0] =~ s/::Manager::/::Object::/r;
}

sub fetch_by_primary_key {
  ## Wrapper around fetch_by_primary_keys for single value
  ## Does NOT work for composite primary keys
  ## @param Primary key value (string)
  ## @param (Optional) Hashref of extra parameters that are passed to get_objects methods
  ## @return Rose::Object drived object OR undef if any error
  my ($self, $id, $params) = @_;

  my $return = $self->fetch_by_primary_keys([$id], $params);
  return $return ? $return->[0] : undef;
}

sub fetch_by_primary_keys {
  ## Gets all the objects with the given primary keys
  ## Does NOT work for composite primary keys
  ## @param ArrayRef containing values of primary key
  ## @param (Optional) Hashref of extra parameters that are passed to get_objects methods
  ## @return ArrayRef of Rose::Object drived objects OR undef if any error
  my ($self, $ids, $params) = @_;

  $params->{'query'} ||= [];
  push @{$params->{'query'}}, load_package($params->{'object_class'} || $self->object_class_name)->meta->primary_key_column_names->[0], $ids;

  return @$ids ? $self->get_objects(%$params) : undef;
}

sub fetch_by_page {
  ## Returns objects from the database according to pagination parameters
  ## @param Number of objects to be returned
  ## @param Page number
  ## @param HashRef of extra params for get_objects
  ## @return ArrayRef of Rose::Object drived objects OR undef if any error
  my ($self, $pagination, $page, $params) = @_;

  $params ||= {};
  if ($pagination) {
    $params->{'per_page'} = $pagination;
    $params->{'page'}     = $page;
  }

  return $self->get_objects(%$params);
}

sub count {
  ## Gives the number of all the active rows in the table
  ## @param Ref of Hash that goes to manager's get_objects_count method as arg
  ## @return int
  my ($self, $params) = @_;

  my $active_only     = exists $params->{'active_only'} ? delete $params->{'active_only'} : 1;
  $self->_add_column_constraint_query($params);
  $self->_add_active_only_query($params) if $active_only;

  return $self->get_objects_count(%$params);
}

sub create_empty_object {
  ## Creates an new instance of the object class
  ## @param Rose::Object drived object (or object class) for reference (optional)
  ## @param Hash of name value pair for the params to construct the new object with
  ## @return Rose::Object drived object
  my ($self, $object, $params) = @_;

  $params = $object and $object = undef if ref $object eq 'HASH';
  return ($object ? ref $object || $object : $self->object_class)->new(%$params);
}

sub get_lookup {
  ## Gets lookups (name-value pairs) for all the object rows in the table
  ## Used for displaying options of dropdowns in forms for CRUD interface
  ## Skips the rows which are not active
  ## @param Object class string (optional - defaults to manager's default object_class)
  ## @return HashRefs with keys as primary key value and values as title value OR undef if an error
  ##  - key   : primary key's value
  ##  - title : value of the title column (Object->meta->title_column)
  my ($self, $object_class) = @_;

  my $default_object_class  = $self->object_class;
  $object_class           ||= $default_object_class;
  my $title_column_name     = $object_class->meta->title_column;
  my $lookup                = {};

  for (@{$self->get_objects('object_class', $object_class) || []}) {
    next unless $_->include_in_lookup($object_class);
    my $key = $_->get_primary_key_value;
    $lookup->{$key} = $_->get_title;
  }
  return $lookup;
}

sub fetch_all_created_by {
  ## Fetches all records created by a given user (for trackable objects only)
  ## @param User id (integer)
  ## @param (Optional) Extra bits to be a part of the query (HashRef with keys as supported by manager->get_objects)
  ## @return ArrayRef of Rose::Object drived classes, undef if any error
  return shift->_fetch_all_by('created', @_);
}

sub fetch_all_modified_by {
  ## Fetches all records modified by a given user (for trackable objects only)
  ## @param User id (integer)
  ## @param (Optional) Extra bits to be a part of the query (HashRef with keys as supported by manager->get_objects)
  ## @return ArrayRef of Rose::Object drived classes, undef if any error
  return shift->_fetch_all_by('modified', @_);
}

sub fetch_all_created_after   {} ## TODO
sub fetch_all_modified_after  {} ## TODO
sub fetch_all_created_before  {} ## TODO
sub fetch_all_modified_before {} ## TODO

sub _fetch_all_by {
  ## @private
  ## Helper method for fetch_all_created_by & fetch_all_modified_by
  my ($self, $type, $user_id, $params) = @_;

  return unless $user_id;

  $params             ||= {};
  $params->{'query'}  ||= [];
  push @{$params->{'query'}}, ("${type}_by", $user_id);
  
  return $self->get_objects(%$params);
}

sub _add_active_only_query {
  ## @private
  ## Adds query params for fetching 'active only' rows from the db
  ## Override in the child class if required to provide some custom param in query key of args passed to get_objects
  ## @param HashRef of params being passed to get_objects methods after normalisation
  my ($self, $params) = @_;
  my $meta_class = load_package($params->{'object_class'} || $self->object_class_name)->meta;

  if (my $inactive_flag_column = $meta_class->inactive_flag_column) {
    $params->{'query'} ||= [];
    push @{$params->{'query'}}, "!$inactive_flag_column", $meta_class->inactive_flag_value;
  }
}

sub _add_column_constraint_query {
  ## @private
  ## Adds query params to constraint the results to include only those rows that have column value as set by constraint_values for that column
  my ($self, $params) = @_;
  my $meta_class = load_package($params->{'object_class'} || $self->object_class_name)->meta;

  my $extra_args = {};

  for (grep $_->type eq 'enum', $meta_class->columns) {
    my $constraint_values = $_->constraint_values;

    $extra_args->{$_->alias || $_->name} = $constraint_values if @$constraint_values;
  }

  if (keys %$extra_args) {

    push @{$params->{'query'}}, keys %$extra_args > 1 ? ( 'AND' => [ %$extra_args ] ) : %$extra_args;
  }
}

sub _objects_related_to_external_object {
  ## @private
  ## Goes in to the object's relationships, recursively to get the sub-object that is directly related to the required external object
  ## @return Array ref of all the intermediate objects, with the object  at the first index
  my ($self, $object, $relationships) = @_;

  return [] unless $object;
  unless (@$relationships) {
    $object = [ $object ] unless ref $object eq 'ARRAY';
    return $object;
  }

  if (ref $object eq 'ARRAY') {
    my $return          = [];
    my $relations_clone = [];
    $relations_clone    = [ map {$_} @$relationships ] and push @$return, @{$self->_objects_related_to_external_object($_, $relations_clone)} for @$object;
    return $return;
  }

  my $relationship    = shift @$relationships;
  my $sub_objects     = $object->$relationship;
  return [] unless $sub_objects;

  return $self->_objects_related_to_external_object($sub_objects, $relationships) if scalar @$relationships;

  $sub_objects = [ $sub_objects ] unless ref $sub_objects eq 'ARRAY';
  return $sub_objects;
}

1;
