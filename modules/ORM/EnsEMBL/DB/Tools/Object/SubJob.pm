package ORM::EnsEMBL::DB::Tools::Object::SubJob;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table       => 'sub_job',

  columns     => [
    ticket_id     => {type => 'int', length => 10, not_null => 1},
    sub_job_id    => {type => 'int', length => 10, not_null => 1, primary_key => 1},
    modified_at   => {type => 'timestamp', not_null => 1},
    job_division  => {type => 'blob', },
  ],

  relationships => [
    ticket  => {
      type       => 'many to one',
      class      => 'ORM::EnsEMBL::DB::Tools::Object::Ticket',
      column_map => {'ticket_id' => 'ticket_id'},
    },
    result  => {
      type        => 'one to many',
      class       => 'ORM::EnsEMBL::DB::Tools::Object::Result',
      column_map  => {'sub_job_id' => 'sub_job_id'},
    },
  ],
);  

1;
