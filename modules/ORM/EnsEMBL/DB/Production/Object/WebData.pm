package ORM::EnsEMBL::DB::Production::Object::WebData;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table           => 'web_data',

  columns         => [
    web_data_id => {type => 'serial', primary_key => 1, not_null => 1},
    data        => {type => 'datastructure', 'default' => '{}' },
    comment     => {type => 'text' }
  ],

  trackable       => 1,

  title_column    => 'data',

  relationships   => [
    analysis_web_data => {
      'type'        => 'one to many',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::AnalysisWebData',
      'column_map'  => {'web_data_id' => 'web_data_id'}
    },
  ],
);


1;