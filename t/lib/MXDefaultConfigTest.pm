package MXDefaultConfigTestBase;
use Mouse;

has 'inherited_ro_attr' => (is => 'ro', isa => 'Str');

no Mouse;
1;

package MXDefaultConfigTest;
use Mouse;
use Path::Class::File;
extends 'MXDefaultConfigTestBase';
with 'MouseX::SimpleConfig';

has 'direct_attr' => (is => 'ro', isa => 'Int');

has 'req_attr' => (is => 'rw', isa => 'Str', required => 1);

has '+configfile' => ( default => 'test.yaml' );

no Mouse;
1;
