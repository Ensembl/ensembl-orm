=head1 LICENSE

Copyright [1999-2014] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::DB::Production::Manager::Biotype;

use strict;
use warnings;

use ORM::EnsEMBL::Utils::Exception;

use base qw(ORM::EnsEMBL::Rose::Manager);

=head2 fetch_biotype

    Arg [0]    : Instance of Bio::EnsEMBL::Gene|Transcript
    Description: Returns an object corresponding to the biotype of the argument
    Returntype : Instance of ORM::EnsEMBL::DB::Production::Object::Biotype
    Exceptions : if argument is not gene or transcript, or if object cannot
                 be fetched, or multiple objects are fetched

=cut

sub fetch_biotype {
  my ($self, $feature) = @_;
  
  my $object_type;
  if ($feature->isa('Bio::EnsEMBL::Gene')) {
    $object_type = 'gene';
  } elsif ($feature->isa('Bio::EnsEMBL::Transcript')) {
    $object_type = 'transcript';
  } else {
    throw sprintf "Argument (display_id: %s) is not a gene or transcript", $feature->display_id;
  }
  
  my $biotypes = $self->get_objects(query => [
					      name => $feature->biotype,
					      object_type => $object_type,
					     ]);
  
  throw sprintf "Feature %s: unable to fetch the corresponding biotype object", $feature->display_id
    unless scalar @{$biotypes};
  throw sprintf "Feature %s: fetched multiple biotype objects for feature %s", $feature->display_id
    unless scalar @{$biotypes} == 1;
  
  return $biotypes->[0];
}

=head2 fetch_all_biotype_groups

    Arg []     : None
    Description: Returns all biotype groups from the production db
    Returntype : ArrayRef; the list of groups
    Exceptions : None

=cut

sub fetch_all_biotype_groups {
  my $self = shift;

  my @groups = map { $_->{biotype_group} }
    @{$self->get_objects(select => ['biotype_group'], distinct => 1)};

  return \@groups;  
}

=head2 group_members

    Arg [0]    : String; the name of the group
    Description: Returns the biotypes having the group specified as argument
    Returntype : ArrayRef; the list of biotypes
    Exceptions : if the group does not exist

=cut

sub group_members {
  my ($self, $group) = @_;

  # check group is a valid one
  throw "Invalid biotype group $group specified"
    unless $group ~~ @{$self->fetch_all_biotype_groups()};

  my %members;
  map { $members{$_->{name}}++ }
    @{$self->get_objects(select => ['name'],
			 query => [
				   biotype_group => $group
				  ],
			 distinct => 1)};

  my @members = keys %members;
  return \@members;
}

=head2 is_member_of_group

    Arg [0]    : Instance of Bio::EnsEMBL::Gene|Transcript
    Arg [1]    : String; the name of the group
    Description: Returns the biotypes having the group specified as argument
    Returntype : 0/1 if the biotype belongs/do not belong to the group
    Exceptions : if the group does not exist or if the first argument is
                 not a gene or transcript

=cut

sub is_member_of_group {
  my ($self, $feature, $group) = @_;

  # check group is a valid one
  throw "Invalid biotype group $group specified"
    unless $group ~~ @{$self->fetch_all_biotype_groups()};

  my $object_type;
  if ($feature->isa('Bio::EnsEMBL::Gene')) {
    $object_type = 'gene';
  } elsif ($feature->isa('Bio::EnsEMBL::Transcript')) {
    $object_type = 'transcript';
  } else {
    throw sprintf "Argument (display_id: %s) is not a gene or transcript", $feature->display_id;
  }

  my $biotypes = $self->get_objects(query => [
					      name => $feature->biotype,
					      object_type => $object_type,
					      biotype_group => $group
					     ]);

  return 0 unless scalar @{$biotypes};
  return 1;
}

1;
