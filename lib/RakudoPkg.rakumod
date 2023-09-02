unit module  RakudoPkg;

# Debian releases
constant $DEBIAN = < 
    4.etch.2007
    5.lenny.2009
    6.squeeze.2011
    7.wheezy.2013
    8.jessie.2015
    9.stretch.2017
   10.buster.2019
   11.bullsye.2021
   12.bookworm.2023
   13.trixie.0
   14.forky.0
];

# Ubuntu releases
constant $UBUNTU = <
   14.trusty
   16.xenial
   18.bionic
   20.focal
   22.jammy
   23.lunar
>;

class OS is export {
    has $.name;            # debian, xenial, ...
    has $.version-number;  # 10, 11, ...
    has $.version-name;    # buster, bookworm, ...
}

sub os-version(--> OS) is export {
    my $name = $*DISTRO.name;
    my $v    = $*DISTRO.version; # a Version object: 11.buster

    my $version-number = $v.parts[0];
    my $version-name   = $v.parts[1];
    OS.new: :$name, :$version-name, :$version-number;
}

sub my-resources is export {
    %?RESOURCES
}


