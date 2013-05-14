package ORM::EnsEMBL::DB::Production::Object::AnalysisWebData;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Production::Object);

use constant ROSE_DB_NAME => 'production';

__PACKAGE__->meta->setup(
  table       => 'analysis_web_data',

  columns     => [
    analysis_web_data_id    => {type => 'serial', primary_key => 1, not_null => 1},
    analysis_description_id => {type => 'integer' },
    web_data_id             => {type => 'integer' },
    species_id              => {type => 'integer' },
    db_type                 => {type => 'enum', 'values' => [qw(
                                  cdna
                                  core
                                  funcgen
                                  otherfeatures
                                  presite
                                  rnaseq
                                  sangervega
                                  vega)]
    },
    displayable             => {type => 'integer', 'not_null' => 1, 'default' => 1},
  ],

  trackable     => 1,

  relationships => [
    web_data              => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::WebData',
      'column_map'  => {'web_data_id' => 'web_data_id'}
    },
    analysis_description  => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::AnalysisDescription',
      'column_map'  => {'analysis_description_id' => 'analysis_description_id'}
    },
    species               => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::Species',
      'column_map'  => {'species_id' => 'species_id'}
    }
  ],
);

1;