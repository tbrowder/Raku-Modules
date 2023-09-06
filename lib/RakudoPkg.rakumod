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
    # the two parts of the $*DISTRO object:
    has $.name;              # debian, ubuntu, macos, mswin32, ...
    # the full Version string:
    has $.version;           # 1.0.1.buster, bookworm, ...

    # DERIVED PARTS
    # the number part
    has $.version-number = "";    # 10, 11, 20.4, ...
    # the string part
    has $.version-name   = "";      # buster, bookworm, xenial, ...
    # a numerical part for comparison between Ubuntu versions (x.y.z ==> x.y)
    has $.vnum = 0;
    # a hash to contain the parts
    # %h = %(
    #     version-number => value,
    #     version-name   => value,
    #     vnum           => value,
    # )

    # for rakudo-pkg use
    # valid for Debian and Ubuntu
    has $.keyring-location = "";

    submethod TWEAK {
        # the two parts of the $*DISTRO object:
        $!name    = $*DISTRO.name.lc;
        $!version = $*DISTRO.version;

        # what names does this module support?
        unless $!name ~~ /:i debian | ubuntu/ {
            note "WARNING: OS $!version-name is not supported. Please file an issue.";
        }
  
        # other pieces needed for installation by rakudo-pkg
        my %h = os-version-parts($!version.Str); # $n.Num;    # 10, 11, 20.4, ...
        $!version-number = %h<version-number>; 
        $!version-name   = %h<version-name>; 
        # we have to support multiple integer chunks for numerical comparison
        $!vnum           = %h<vnum>; 

        # using info from rakudo-pkg, the keyring_location varies:
        #   for Debian Stretch, Ubuntu 16.04 and later:
        #     /usr/share/keyrings/nxadm-pkgs-rakudo-pkg-archive-keyring.gpg
        #   for Debian Jessie, Ubuntu 15.10 and earlier:
        #     /etc/apt/trusted.gpg.d/nxadm-pkgs-rakudo-pkg.gpg
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
    }

    sub os-version-parts(Str $version --> Hash) is export { 
        # break version.parts into integer and string parts
        my @parts = $version.split('.');
        my $s = "";
        my $n = "";
        my @n;
        for @parts -> $p {
            if $p ~~ /^\d+$/ { # Int {
                $n ~= '.' if $n;
                $n ~= $p;
                @n.push: $p;
            }
            elsif $p ~~ Str {
                $s ~= ' ' if $s;
                $s ~= $p;
            }
            else {
                die "FATAL: Version part '$p' is not an Int nor a Str";
            }
        }
        my $vname   = $s; # don't downcase here.lc;
        my $vnumber = $n; #.Num;    # 10, 11, 20.4, ...
        if not @n.elems {
            @n.push: 0;
            $vnumber = 0;
        }
        my $num = @n.elems > 1 ?? (@n[0] ~ '.' ~ @n[1]) !! @n.head;
        # return the hash
        my %h = %(
            version-number => $vnumber,
            version-name   => $vname,
            num            => $num.Num,
        );
        %h
    }
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

