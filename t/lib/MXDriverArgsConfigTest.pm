package MXDriverArgsConfigTestBase;
use Mouse;

has 'inherited_ro_attr' => (is => 'ro', isa => 'Str');

no Mouse;
1;

package MXDriverArgsConfigTest;
use Mouse;
extends 'MXDriverArgsConfigTestBase';
with 'MouseX::SimpleConfig';

has 'direct_attr' => (is => 'ro', isa => 'Int');

has 'req_attr' => (is => 'rw', isa => 'Str', required => 1);

sub config_any_args {
    return +{
        driver_args => {
            General => {
                -LowerCaseNames => 1
            }
        }
    }
}

no Mouse;
1;
