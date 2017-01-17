=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2017] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package ORM::EnsEMBL::DB::Healthcheck::Manager::Report;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::Rose::Manager);

sub count_failed_for_session {
  ## Counts reports failed during the given session, grouped wrt given column name
  ## @param Hashref with keys:
  ##  - session_id          Id of the session
  ##  - group_by            ArrayRef of column names wrt which reports are to be grouped
  ##  - include_manual_ok   Flag to tell whether or not to include manual oked reports (defaults to false)
  ##  - query               To be added to the query key of hash passed to get_objects as argument
  ## @return ArrayRef of Rose objects with a key 'failed_count' containing the number of reports along with the keys in 'group_by' param
  my ($self, $params) = @_;

  my %arg = (
    'select'        => ['count(t1.report_id) AS failed_count', 'first_session_id', 'last_session_id', @{$params->{'group_by'}}],
    'group_by'      => ['first_session_id', @{$params->{'group_by'}}],
    'sort_by'       => 'first_session_id DESC',
    'query'         => [
      'result'          => 'PROBLEM',
      'last_session_id' => $params->{'session_id'},
      @{$params->{'query'} || []}
    ]
  );

  unless($params->{'include_manual_ok'}) {
    $arg{'with_objects'} = 'annotation';
    push @{$arg{'query'}}, $self->_manual_ok_annotation_query;
  }

  return $self->get_objects(%arg);
}

sub fetch_for_session {
  ## Fetches reports from the db for a given session, with or without their linked annotation and annotation's users
  ## @param HashRef with the following keys:
  ##  - session_id          Id of the session
  ##  - query               Arrayref to be added to the query part of get_objects method (optional)
  ##  - control_only        Flag if on, will return only control reports (ones having '#' prefixed to the text in the db)
  ##  - failed_only         Flag, possibly can have two values (will be ignored if control_only flag is on)
  ##    - false             Any boolean false value will get all the reports except with result 'CORRECT' (default)
  ##    - true              Any boolean true value will get only failed reports (reports with result 'PROBLEM')
  ##  - with_annotations    Flag (possibly can have three values) (will be ignored if control_only flag is on)
  ##    - false             Any boolean false value will not include any annotations of reports (default)
  ##    - exclude_manual_ok Will exclude all the reports with 'manual ok' annotations
  ##    - true              Any other boolean true value will include all annotations
  my ($self, $params) = @_;

  return unless $params->{'session_id'};
  
  my $args = {};
  $args->{'query'} = $params->{'query'} || [];
  push @{$args->{'query'}}, ('last_session_id' => $params->{'session_id'}),
    !$params->{'control_only'}
      ? $params->{'failed_only'}
        ? ('result' => 'PROBLEM')
        : ('result' => ['PROBLEM', 'WARNING', 'INFO'], 'text' => {'not like' => '#%'})
      : ('result' => 'INFO', 'text' => {'like' => '#%'});

  if (!$params->{'control_only'} && $params->{'with_annotations'}) {
    $args->{'with_objects'}           = ['annotation'];
    $args->{'with_external_objects'}  = ['annotation.created_by_user', 'annotation.modified_by_user'];
    if ($params->{'with_annotations'} eq 'exclude_manual_ok') {
      push @{$args->{'query'}}, $self->_manual_ok_annotation_query;
    }
  }

  return $self->get_objects(%$args);
}

sub fetch_for_distinct_databases {
  ## Fetches one report for each db for a given session/release - basically you get a list of database which were healthchecked in the given session/release
  ## @param HashRef with keys:
  ##  - last_session_id   Session id of the last session of the requested release (required)
  ##  - first_session_id  Session id of the first session of the requested release (optional) - if missed, reports for only last_session_id are fetched
  ## @return ArrayRef of ORM::EnsEMBL::DB::Healthcheck::Object::Report objects if found any
  return shift->_fetch_for_distinct('database_name', @_);
}

sub fetch_for_distinct_testcases {
  ## Fetches one report for each testcase - basically you get a list of all testcases
  ## @param HashRef with keys:
  ##  - last_session_id   Session id of the last session of the requested release (required)
  ##  - first_session_id  Session id of the first session of the requested release (optional) - if missed, reports for only last_session_id are fetched
  ## @return ArrayRef of ORM::EnsEMBL::DB::Healthcheck::Object::Report objects if found any
  return shift->_fetch_for_distinct('testcase', @_);
}

sub fetch_hc_bug_reports {
  ## Fetches all the reports that are annotated as healthcheck_bug for the required release
  ## @param Hashred with keys:
  ##  - last_session_id   Session id of the last session of the requested release
  ##  - first_session_id  Session id of the first session of the requested release
  ## @return ArrayRef of ORM::EnsEMBL::DB::Healthcheck::Object::Report objects if found any
  my ($self, $params) = @_;

  return $self->get_objects(
    'with_objects'          => ['annotation'],
    'with_external_objects' => ['annotation.created_by_user', 'annotation.modified_by_user'],
    'query'                 => [
      'annotation.action'     => 'healthcheck_bug',
      'last_session_id'       => {'ge' => $params->{'first_session_id'}},
      'last_session_id'       => {'le' => $params->{'last_session_id'}}
    ]
  );
}

sub _fetch_for_distinct {
  ## Private method to fetch reports keeping one column distinct
  my ($self, $group_by, $params) = @_;
  return [] unless $params->{'last_session_id'};

  my $objects = $self->get_objects(
    'group_by'  => $group_by,
    'query'     => exists $params->{'first_session_id'}
      ? ['last_session_id', {'ge' => $params->{'first_session_id'}}, 'last_session_id', {'le' => $params->{'last_session_id'}}]
      : ['last_session_id', $params->{'last_session_id'}],
  );
  return $objects;
}

sub _manual_ok_annotation_query {
  ## @private
  return  ('or', [
    'annotation.action'  => undef,
    '!annotation.action' => [ qw(manual_ok manual_ok_this_assembly manual_ok_this_genebuild manual_ok_this_regulatory_build healthcheck_bug) ],
  ]);
}

1;
