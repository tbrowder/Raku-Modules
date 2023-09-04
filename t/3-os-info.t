use Test;
use RakudoPkg;

my $os = os-version;
isa-ok $os, OS, "native Version info: name '{$*DISTRO.name}', version '{$*DISTRO.version.Str}'";

my $osver = "{$os.version-number}.{$os.version-name}";
my $osversion = "{$os.version}";

is $os.name, $*DISTRO.name, "my distro name {$os.name}";
is $osver, $*DISTRO.version, "my distro version {$osver}";
is $osversion, $*DISTRO.version.Str, "my distro version {$osversion}";

done-testing;
