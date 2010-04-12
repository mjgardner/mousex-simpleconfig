# Load the Module::Install bundled in ./inc/
use inc::Module::Install 0.91;

name 'MooseX-SimpleConfig';
all_from 'lib/MooseX/SimpleConfig.pm';

test_requires 'Test::More' => '0.42';

requires 'Moose'                      => '0.35';
requires 'MooseX::ConfigFromFile'     => '0.02';
requires 'Config::Any'                => '0.13';

# Rebuild README for maintainers
system("pod2text lib/MooseX/SimpleConfig.pm >README") and die
    if $Module::Install::AUTHOR;

auto_provides;
auto_install;
WriteAll;
