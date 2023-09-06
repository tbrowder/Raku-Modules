use Test;
use RakudoPkg;

=begin comment
# test for deb/ub keys
if $!name eq 'ubuntu' {
    # need to know version number
    if $!version-number >= 16.04 {
        $!keyring-location = "/usr/share/keyrings/nxadm-pkgs-rakudo-pkg-archive-keyring.gpg";
    }
    else {
        $!keyring-location = "/etc/apt/trusted.gpg.d/nxadm-pkgs-rakudo-pkg.gpg";
    }
}
elsif $!name eq 'debian' {
    # need to know version number of Stretch
    my $dn = %debian-vnam<stretch>;
    if $!version-number >= $dn {
        $!keyring-location = "/usr/share/keyrings/nxadm-pkgs-rakudo-pkg-archive-keyring.gpg";
    }
    else {
        $!keyring-location = "/etc/apt/trusted.gpg.d/nxadm-pkgs-rakudo-pkg.gpg";
    }
}

=end comment

subtest {
    my $os = OS.new; #os-version;
    isa-ok $os, OS, "native Version info: name '{$*DISTRO.name}', version '{$*DISTRO.version}'";
    is $os.name, $*DISTRO.name, "my distro name '{$os.name}'";
    is $os.version, $*DISTRO.version, "my distro version '{$os.version}'";
    is $os.version.parts, $*DISTRO.version.parts, "my distro version.parts '{$os.version.parts}'";
}, "Testing class OS on native DISTRO object";

# arbitrary parsing of the version string
#    sub os-version-parts(Str $version --> Hash) is export {
subtest {
    my $vs = "2.1.Some.OS";
    my %h = os-version-parts $vs;
    isa-ok $vs, Str, "arbitrary version string '{$vs}'";
    isa-ok %h<version-number>, Str, "arbitrary version num part string '{%h<version-number>}'";
    isa-ok %h<version-string>, Str, "arbitrary version string part '{%h<version-string>}'";
    isa-ok %h<num>, Num, "version number for comparison '{%h<num>}'";
}, "Testing parsing of an arbitrary version string";

done-testing;
