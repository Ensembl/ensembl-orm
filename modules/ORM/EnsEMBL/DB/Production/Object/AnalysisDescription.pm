package ORM::EnsEMBL::DB::Production::Object::AnalysisDescription;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table         => 'analysis_description',

  columns       => [
    analysis_description_id => {type => 'serial', primary_key => 1, not_null => 1}, 
    logic_name              => {type => 'varchar', 'length' => 128 },
    description             => {type => 'text'},
    display_label           => {type => 'varchar', 'length' => 256 },
    db_version              => {type => 'integer', not_null => 1, default => 1 },
    default_web_data_id     => {type => 'integer'}
  ],

  trackable     => 1,

  title_column  => 'logic_name',

  unique_key    => ['logic_name'],

  relationships => [
    analysis_web_data => {
      'type'            => 'one to many',
      'class'           => 'ORM::EnsEMBL::DB::Production::Object::AnalysisWebData',
      'column_map'      => {'analysis_description_id' => 'analysis_description_id'}
    },

    default_web_data  => {
      'type'            => 'many to one',
      'class'           => 'ORM::EnsEMBL::DB::Production::Object::WebData',
      'column_map'      => {'default_web_data_id' => 'web_data_id'}
    }
  ]
);

1;