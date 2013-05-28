package ORM::EnsEMBL::DB::Tools::Manager::Result;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::Result;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::Result' }

sub fetch_results_by_ticket_sub_job {
  my ($self, $ticket_id, $sub_job_id) = @_;
  my $results = $self->get_objects(
    'query' => [
      'ticket_id'   => $ticket_id,
      'sub_job_id'  => $sub_job_id
    ]
  );
  return $results;
}

sub fetch_result_by_result_id {
  my ($self, $result_id) = @_;
  return undef unless $result_id;

  my $result = $self->get_objects(
    'with_objects'  => ['sub_job'],
    'query'         => ['result_id' => $result_id]
  );
   
  return $result;
}

sub fetch_all_results_in_region {
  my ($self, $ticket_id, $slice) = @_;
  my $sr_name = $slice->seq_region_name;
  my $sr_start = $slice->start;
  my $sr_end  = $slice->end;

  # First select where complete result is within region  
  my $results1 = $self->get_objects(
    'query' => [
      'ticket_id' => $ticket_id,
      'chr_name'  => $sr_name,
      'chr_start' => { ge => $sr_start},
      'chr_end'   => { le => $sr_end}   
    ]
  ); 

  # Next select where end of result is within region
  my $results2 = $self->get_objects(
    'query' => [
      'ticket_id' => $ticket_id,
      'chr_name'  => $sr_name,
      'chr_start' => { lt => $sr_start}, 
      'chr_end'   => { le => $sr_end},
      'chr_end'   => { gt => $sr_start}
    ]
  );

  # Next select where start of result is within region
  my $results3 = $self->get_objects(
    'query' => [
      'ticket_id' => $ticket_id,
      'chr_name'  => $sr_name,
      'chr_start' => { ge => $sr_start}, 
      'chr_start' => { le => $sr_end},
      'chr_end'   => { gt => $sr_end},
    ]
  ); 

  # Next select where result spans entire region
  my $results4 = $self->get_objects(
    'query' => [
      'ticket_id' => $ticket_id,
      'chr_name'  => $sr_name,
      'chr_start' => { lt => $sr_start}, 
      'chr_end'   => { gt => $sr_end},
      'chr_start' => { lt => $sr_end},
    ]
  );

  my @results = ( @{$results1}, @{$results2}, @{$results3}, @{$results4}); # TODO - make it a single query! - dont we get repeats with this?

  return \@results;
}

1;

