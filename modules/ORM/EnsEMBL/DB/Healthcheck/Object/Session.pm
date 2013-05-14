package ORM::EnsEMBL::DB::Healthcheck::Object::Session;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Healthcheck::Object);

__PACKAGE__->meta->setup(
  table         => 'session',

  columns       => [
    session_id        => {type => 'serial', primary_key => 1, not_null => 1}, 
    db_release        => {type => 'integer'},
    start_time        => {type => 'datetime'},
    end_time          => {type => 'datetime'},
    host              => {type => 'varchar', 'length' => '255'},
    config            => {type => 'text'}
  ],

  relationships => [
    report      => {
      'type'        => 'one to many',
      'class'       => 'ORM::EnsEMBL::DB::Healthcheck::Object::Report',
      'column_map'  => {'session_id' => 'last_session_id'},
    },
  ]
);

1;