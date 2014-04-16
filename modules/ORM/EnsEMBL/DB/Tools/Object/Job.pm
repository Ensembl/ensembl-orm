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

package ORM::EnsEMBL::DB::Tools::Object::Job;

### Object representing 'job' table in the tools db
### Column description:
###  - status:
###     awaiting_dispatcher_response: job dispatched, and waiting for any further updates from dispatcher
###     awaiting_user_response: some problem happenned, either job could not be sent to dispatcher, or has failed somewhere - user needs to have a look and resubmit it
###     done: job finished successfully, no further editing should be made to this job
###  - dispatcher_status:
###     not_submitted: could not be sent to the dispatcher
###     queued: sent to dispatcher, but not submitted ahead for processing (eg. beekeeper yet to send the job to LFS)
###     submitted: sent to dispatcher and submitted to for processing
###     running: eg. running on LFS
###     done: eg. done at LFS
###     failed: failed at dispatcher
###     deleted: dispatcher has no info about the job

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::JobMessage;  # for foreign key initialisation
use ORM::EnsEMBL::DB::Tools::Object::Result;      # for foreign key initialisation

use parent qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table           => 'job',
  auto_initialize => []
);

__PACKAGE__->meta->datastructure_columns(map {'name' => $_, 'trusted' => 1}, qw(job_data dispatcher_job_data));

1;
