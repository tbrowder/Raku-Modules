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

# key locations 
# newest key
constant $KEY1 is export = "/usr/share/keyrings/nxadm-pkgs-rakudo-pkg-archive-keyring.gpg";
# key for older versions
constant $KEY2 is export = "/etc/apt/trusted.gpg.d/nxadm-pkgs-rakudo-pkg.gpg";

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
    # the serial part
    has $.version-serial = "";    # 10, 11, 20.4, ...
    # the string part
    has $.version-name   = "";      # buster, bookworm, xenial, ...
    # a numerical part for comparison between Ubuntu versions (x.y.z ==> x.y)
    # also used for debian version comparisons
    has $.vnum = 0;

    # a hash to contain the parts
    # %h = %(
    #     version-serial => value,
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
        $!version-serial = %h<version-serial>; 
        $!version-name   = %h<version-name>; 
        # we have to support multiple integer chunks for numerical comparison
        $!vnum           = %h<vnum>; 

        $!keyring-location = key-location($!name, $!vnum);
    }

    # using info from rakudo-pkg, the keyring_location varies:
    #   for Debian Stretch, Ubuntu 16.04 and later:
    #     /usr/share/keyrings/nxadm-pkgs-rakudo-pkg-archive-keyring.gpg
    #   for Debian Jessie, Ubuntu 15.10 and earlier:
    #     /etc/apt/trusted.gpg.d/nxadm-pkgs-rakudo-pkg.gpg
    sub key-location($name, Num $vnum --> Str) is export {
        my $keyloc = "";
        if $name eq 'ubuntu' {
            # need to know numerical version number
            if $vnum >= 16.04 {
                $keyloc = $KEY1; #"/usr/share/keyrings/nxadm-pkgs-rakudo-pkg-archive-keyring.gpg";
            }
            else {
                $keyloc = $KEY2; #"/etc/apt/trusted.gpg.d/nxadm-pkgs-rakudo-pkg.gpg";
            }
        }
        elsif $name eq 'debian' {
            # need to know numerical version number of Stretch
            my $dn = %debian-vnam<stretch>;
            if $vnum >= $dn {
                $keyloc = $KEY1; #"/usr/share/keyrings/nxadm-pkgs-rakudo-pkg-archive-keyring.gpg";
            }
            else {
                $keyloc = $KEY2; #"/etc/apt/trusted.gpg.d/nxadm-pkgs-rakudo-pkg.gpg";
            }
        }
        $keyloc
    }

    sub os-version-parts(Str $version --> Hash) is export { 
        # break version.parts into serial and string parts
        # create a numerical part for serial comparison
        my @parts = $version.split('.');
        my $s = ""; # string part
        my $n = ""; # serial part
        my @c;      # numerical parts
        for @parts -> $p {
            if $p ~~ /^\d+$/ { # Int {
                # assign to the serial part ($n, NOT a Num)
                # separate parts with periods
                $n ~= '.' if $n;
                $n ~= $p;
                # save the integers for later use
                @c.push: $p;
            }
            elsif $p ~~ Str {
                # assign to the string part ($s)
                # separate parts with spaces
                $s ~= ' ' if $s;
                $s ~= $p;
            }
            else {
                die "FATAL: Version part '$p' is not an Int nor a Str";
            }
        }
        my $vname   = $s; # don't downcase here.lc;
        my $vserial = $n; # 10, 11, 20.04.2, ...
        if not @c.elems {
            # not usual, but there is no serial part, so make it zero
            @c.push: 0;
            $vserial = 0;
        }
        # for numerical comparison
        # only zero or one decimal places
        my $vnum = @c.elems > 1 ?? (@c[0] ~ '.' ~ @c[1]) !! @c.head;
        # return the hash
        my %h = %(
            version-serial => $vserial,
            version-name   => $vname,
            vnum           => $vnum.Num, # it MUST be a number
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

