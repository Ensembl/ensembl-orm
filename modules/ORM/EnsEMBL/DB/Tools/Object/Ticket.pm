=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::DB::Tools::Object::Ticket;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::Job; # for foreign key initialisation
use ORM::EnsEMBL::Utils::Exception;

use parent qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table           => 'ticket',
  auto_initialize => []
);

{
  my $job_relationship = __PACKAGE__->meta->relationship('job');

  $job_relationship->query_args(['status' => {'ne' => 'deleted'}]); # exclude the 'deleted' jobs when fetching
  $job_relationship->method_name('count', 'job_count');
  $job_relationship->make_methods(
    preserve_existing => 1,
    types             => [ 'count' ]
  );
}

sub calculate_life_left {
  ## Calculates the life left for the ticket to expire according to give lifespan
  ## @param Life span for ticket in seconds
  ## @return Number of seconds left
  my ($self, $life_span) = @_;

  throw('Lifespan argument is missing or invalid') if !$life_span || $life_span !~ /^\d+$/;

  return $life_span if $self->owner_type eq 'user';

  return 0 if $self->status =~ /^(Expired|Deleted)$/;

  my $life_left = $life_span - time + $self->created_at->epoch;

  return $life_left > 0 ? $life_left : 0;
}

sub mark_deleted {
  ## Marks the ticket object and related job objects as deleted instead of actually deleting them from the db table - but deletes the related results and messages
  ## @return Boolean as returned by 'save' method
  my $self = shift;
  $self->load('with' => ['job']);

  $_->mark_deleted or return for $self->job;

  $self->status('Deleted');

  return $self->save;
}

1;
