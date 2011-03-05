# Load the Module::Install bundled in ./inc/
use inc::Module::Install 0.91;

name 'MouseX-SimpleConfig';
all_from 'lib/MouseX/SimpleConfig.pm';

test_requires 'Test::More' => '0.42';

requires 'Mouse'                      => '0.35';
requires 'MouseX::ConfigFromFile'     => '0.02';
requires 'Config::Any'                => '0.13';

test_requires 'Test::More' => '0.88';

# Rebuild README for maintainers
system("pod2text lib/MouseX/SimpleConfig.pm >README") and die
    if $Module::Install::AUTHOR;

resources 'license'     => 'http://dev.perl.org/licenses/';
resources 'repository'  => 'git://github.com/mjg/mousex-simpleconfig.git';

auto_provides;
auto_install;
WriteAll;
