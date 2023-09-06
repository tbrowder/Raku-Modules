use Test;
use RakudoPkg;

subtest {
    my $os = OS.new; #os-version;
    isa-ok $os, OS, "native Version info: name '{$*DISTRO.name}', version '{$*DISTRO.version}'";
    is $os.name, $*DISTRO.name, "my distro name '{$os.name}'";
    is $os.version, $*DISTRO.version, "my distro version '{$os.version}'";
    is $os.version.parts, $*DISTRO.version.parts, "my distro version.parts '{$os.version.parts}'";
}, "Testing class OS on native DISTRO object";

# parsing of an arbitrary version string
#    sub os-version-parts(Str $version --> Hash) is export {
subtest {
    my $vs = "2.1.20.Some.OS";
    my %h = os-version-parts $vs;
    isa-ok $vs, Str, "arbitrary version string '{$vs}'";
    isa-ok %h<version-serial>, Str, "arbitrary version num part string '{%h<version-serial>}'";
    isa-ok %h<version-name>, Str, "arbitrary version string part '{%h<version-name>}'";
    isa-ok %h<vnum>, Num, "version number for comparison '{%h<vnum>}'";
}, "Testing parsing of an arbitrary version string";

# parsing version strings from live data on Github workflows
=begin comment
# sytems confirmed
# name ; version
ubuntu; 22.04.3.LTS.Jammy.Jellyfish
ubuntu; 20.04.6.LTS.Focal.Fossa 
macos;  12.6.7
macos;  13.5  
macos;  11.7.8
mswin32; 10.0.17763.52
=end comment
my @sys =
"ubuntu; 22.04.3.LTS.Jammy.Jellyfish",
"ubuntu; 20.04.6.LTS.Focal.Fossa",
"macos;  12.6.7",
"macos;  13.5",
"macos;  11.7.8",
"mswin32; 10.0.17763.52",
;
for @sys -> $s is copy {
    say "System; $s";
    $s ~~ s:g/\s//; # no spaces
    my @w = $s.split(';');
    say "  name/version string: {@w.raku}";
}

    

done-testing;
