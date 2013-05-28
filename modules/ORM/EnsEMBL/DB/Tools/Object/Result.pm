package ORM::EnsEMBL::DB::Tools::Object::Result;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table       => 'result',

  columns     => [
    result_id   => {type => 'serial', primary_key => 1, not_null => 1},
    ticket_id   => {type => 'int', length => 10, not_null => 1},
    sub_job_id  => {type => 'int', length => 10, not_null => 1, primary_key => 1},
    result      => {type => 'blob', not_null => 1 },
    chr_name    => {type => 'varchar', length => 40},
    chr_start   => {type => 'int', length => 10},
    chr_end     => {type => 'int', length => 10},
    created_at  => {type => 'timestamp', not_null => 1},
    modified_at  => {type => 'timestamp', not_null => 1},
  ],

  relationships => [
    ticket  => {
      type       => 'many to one',
      class      => 'ORM::EnsEMBL::DB::Tools::Object::Ticket',
      column_map => {'ticket_id' => 'ticket_id'},
    },

    sub_job => {
      type        => 'many to one',
      class       => 'ORM::EnsEMBL::DB::Tools::Object::SubJob',
      column_map  => {'sub_job_id' => 'sub_job_id'},
    }, 
  ],
);

1;

