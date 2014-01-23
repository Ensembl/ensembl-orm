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
###     awaiting_hive_response: job sent to hive db, and waiting for any further updates from hive
###     awaiting_user_response: some problem happenned, either job could not be sent to hive, or has failed somewhere - user needs to have a look and resubmit it
###     done: job finished successfully, no further editing should be made to this job
###  - hive_status:
###     not_submitted: could not be sent to the hive
###     queued: sent to hive, but not submitted to LFS by hive (either hive is too busy, or beekeeper is down)
###     submitted: sent to hive and submitted to LFS (relax and wait)
###     running: running on LFS
###     done: done at LFS
###     failed: failed at hive or LFS
###     deleted: job got deleted from the hive db

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::JobMessage;  # for foreign key initialisation
use ORM::EnsEMBL::DB::Tools::Object::Result;      # for foreign key initialisation

use base qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table           => 'job',
  auto_initialize => []
);

__PACKAGE__->meta->datastructure_columns(map {'name' => $_, 'trusted' => 1}, qw(job_data hive_job_data));

1;
