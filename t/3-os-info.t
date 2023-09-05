use Test;
use RakudoPkg;

my $os = OS.new; #os-version;
isa-ok $os, OS, "native Version info: name '{$*DISTRO.name}', version '{$*DISTRO.version}'";

is $os.name, $*DISTRO.name, "my distro name '{$os.name}'";
is $os.version, $*DISTRO.version, "my distro version '{$os.version}'";
is $os.version.parts, $*DISTRO.version.parts, "my distro version.parts '{$os.version.parts}'";

# arbitrary parsing of the version string
my $vs = "2.1.Some OS";

done-testing;
