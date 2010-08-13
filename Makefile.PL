# Load the Module::Install bundled in ./inc/
use inc::Module::Install 0.91;

name 'MooseX-SimpleConfig';
all_from 'lib/MooseX/SimpleConfig.pm';

test_requires 'Test::More' => '0.42';

requires 'Moose'                      => '0.35';
requires 'MooseX::ConfigFromFile'     => '0.02';
requires 'Config::Any'                => '0.13';

test_requires 'Test::More' => '0.88';

# Rebuild README for maintainers
system("pod2text lib/MooseX/SimpleConfig.pm >README") and die
    if $Module::Install::AUTHOR;

resources 'IRC'         => 'irc://irc.perl.org/#moose';
resources 'license'     => 'http://dev.perl.org/licenses/';
resources 'repository'  => 'git://git.moose.perl.org/MooseX-SimpleConfig.git';
resources 'MailingList' => 'http://news.gmane.org/gmane.comp.lang.perl.moose';

auto_provides;
auto_install;
WriteAll;
