use Test;
use RakudoPkg;

subtest {
    my $os = OS.new; #os-version;
    isa-ok $os, OS, "native Version info: name '{$*DISTRO.name}', version '{$*DISTRO.version}'";
    is $os.name, $*DISTRO.name, "my distro name '{$os.name}'";
    is $os.version, $*DISTRO.version, "my distro version '{$os.version}'";
    is $os.version.parts, $*DISTRO.version.parts, "my distro version.parts '{$os.version.parts}'";
}, "Testing class OS on native DISTRO object";

# arbitrary parsing of the version string
#    sub os-version-parts(Str $version --> Pair) is export {
subtest {
    my $vs = "2.1.Some.OS";
    my $p = os-version-parts $vs; 
    isa-ok $vs, Str, "arbitrary version string '{$vs}'";
    isa-ok $p.key, Num, "arbitrary version num part string '{$p.key}'";
    isa-ok $p.value, Str, "arbitrary version string part '{$p.value}'";
}, "Testing parsing of an arbitrary version string";

done-testing;
