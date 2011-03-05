package MXSimpleConfigTestBase;
use Mouse;

has 'inherited_ro_attr' => ( is => 'ro', isa => 'Str' );

no Mouse;
1;

package MXSimpleConfigTest;
use Mouse;
extends 'MXSimpleConfigTestBase';
with 'MouseX::SimpleConfig';

has 'direct_attr' => ( is => 'ro', isa => 'Int' );

has 'req_attr' => ( is => 'rw', isa => 'Str', required => 1 );

no Mouse;
1;
