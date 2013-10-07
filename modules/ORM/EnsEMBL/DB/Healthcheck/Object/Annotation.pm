package ORM::EnsEMBL::DB::Healthcheck::Object::Annotation;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Healthcheck::Object);

__PACKAGE__->meta->setup(
  table       => 'annotation',

  columns     => [
    annotation_id => {type => 'serial', primary_key => 1, not_null => 1}, 
    report_id     => {type => 'integer'},
    session_id    => {type => 'integer'},
    action        => {
      'type'          => 'enum', 
      'values'        => [qw(manual_ok manual_ok_all_releases manual_ok_this_assembly manual_ok_this_genebuild manual_ok_this_regulatory_build healthcheck_bug under_review fixed note)]
    },
    comment       => {type => 'text'},
  ],

  trackable     => 1,

  title_column  => 'comment',

  relationships => [
    report => {
      'type'        => 'one to one',
      'class'       => 'ORM::EnsEMBL::DB::Healthcheck::Object::Report',
      'column_map'  => {'report_id' => 'report_id'},
    },
  ]
);

1;
