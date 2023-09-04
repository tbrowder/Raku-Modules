unit module  RakudoPkg;

# Debian releases
our %debian-vnam is export = %(
    etch => 4,
    lenny => 5,
    squeeze => 6,
    wheezy => 7,
    jessie => 8,
    stretch => 9,
    buster => 10,
    bullsye => 11,
    bookworm => 12,
    trixie => 13,
    forky => 14,
);
our %debian-vnum is export = %debian-vnam.invert;

# Ubuntu releases
our %ubuntu-vnam is export = %(
   trusty => 14,
   xenial => 16,
   bionic => 18,
   focal => 20,
   jammy => 22,
   lunar => 23,
);
our %ubuntu-vnum is export = %ubuntu-vnam.invert;

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

=begin comment
from docs: var $*DISTRO
from docs: role Version does Systemic

basically, two methods usable:
  .name
  .version
    .Str
    .parts (a list of dot.separated items: integers, then strings)

=end comment

class OS is export {
    # the full Version string:
    has $.version;         # 1.0.1.buster, bookworm, ...
    # the number part
    # the string part

    has $.name;            # debian, ubuntu, ...
    has $.keyring-location;

    # valid for Debian and Ubuntu
    has $.version-number;  # 10, 11, 20, ...
    has $.version-name;    # buster, bookworm, xenial, ...

    submethod TWEAK {
        # using info from rakudo-pkg, the keyring_location varies:
        #   for Debian Stretch, Ubuntu 15.10 and earlier:
        #   for later:
    
    }

}

sub os-version(--> OS) is export {
    my $name = $*DISTRO.name.lc;
    my $v    = $*DISTRO.version; # a Version object: 11.buster

    my $version-number = $v.parts[0];
    my $version-name   = $v.parts[1].lc;
    my $version        = $v.Str;
    OS.new: :$name, :$version-name, :$version-number, :$version;
}

sub my-resources is export {
    %?RESOURCES
}

sub is-debian(--> Bool) {
    my $vnam = $*DISTRO.name.lc;
    $vnam eq 'debian';
}

sub is-ubuntu(--> Bool) {
    my $vnam = $*DISTRO.name.lc;
    $vnam eq 'ubuntu';
}

