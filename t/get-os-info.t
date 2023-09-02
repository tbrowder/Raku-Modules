use Test;
use RakudoPkg;

my $os = os-version;
isa-ok, $os, OS;

my $osver = "{$os.version-number}.{$os.version-name}";

is $os.name, $*DISTRO.name;
is $osver, $*DISTRO.version;

done-testing;
