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
      'values'        => [ __PACKAGE__->annotation_actions('keys_only') ]
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

sub annotation_actions {
  ## @static
  my ($class, @flags) = @_;
  my $flags = { map {$_ => 1} @flags };
  my @actions = (
    'manual_ok'                       => 'Manual ok: not a problem for this release',
    'manual_ok_all_releases'          => 'Manual ok all release: not a problem for this species',
    'manual_ok_this_assembly'         => 'Manual ok this assembly',
    'manual_ok_this_genebuild'        => 'Manual ok this genebuild',
    'manual_ok_this_regulatory_build' => 'Manual ok this regulatory build',
    'healthcheck_bug'                 => 'Healthcheck bug: error should not appear, requires changes to healthcheck',
  );
  unless (exists $flags->{'manual_ok'}) {
    push @actions, (
      'under_review'                  => 'Under review: Will be fixed/reviewed',
      'fixed'                         => 'Fixed',
      'note'                          => 'Note or comment',
    );
  }
  return exists $flags->{'keys_only'} ? keys %{{@actions}} : @actions;
}

1;