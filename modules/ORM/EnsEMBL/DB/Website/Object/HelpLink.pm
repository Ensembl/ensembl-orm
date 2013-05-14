package ORM::EnsEMBL::DB::Website::Object::HelpLink;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Website::Object);

__PACKAGE__->meta->setup(
  table         => 'help_link',

  columns       => [
    help_link_id    => {type => 'serial', not_null => 1, primary_key => 1},
    page_url        => {type => 'text'},
    help_record_id  => {type => 'integer', 'length' => 11},
  ],
  
  title_column  => 'page_url',
  
  relationships => [
    help_record => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Website::Object::HelpRecord',
      'column_map'  => {'help_record_id' => 'help_record_id'},
    }
  ]
);

1;