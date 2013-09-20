package ORM::EnsEMBL::DB::Production::Object::AttribType;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table         => 'master_attrib_type',

  columns       => [
    attrib_type_id  => {type => 'serial', primary_key => 1, not_null => 1},
    code            => {type => 'varchar', 'length' => 15,  not_null => 1},		
    name            => {type => 'varchar', 'length' => 255, not_null => 1},			
    description     => {type => 'text'},
    is_current      => {type => 'int', 'default' => 1,      not_null => 1}
  ],

  trackable             => 1,

  unique_key            => ['code'],

  title_column          => 'name',

  inactive_flag_column  => 'is_current',

  relationships => [
    biotype         => {
      'type'        => 'one to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::Biotype',
      'column_map'  => {'attrib_type_id' => 'attrib_type_id'},
    }
  ]
);

1;
