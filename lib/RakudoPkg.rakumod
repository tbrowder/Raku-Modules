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

class OS is export {
    has $.name;            # debian, xenial, ...
    has $.version-number;  # 10, 11, ...
    has $.version-name;    # buster, bookworm, ...
    has $.version;         # 1.0.1.buster, bookworm, ...
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

