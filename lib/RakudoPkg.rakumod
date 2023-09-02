unit module  RakudoPkg;

class OS is export {
    has $.name;            # debian, xenial, ...
    has $.version-number;  # 10, 11, ...
    has $.version-name;    # buster, bookworm, ...
}

sub os-version(--> OS) is export {
    my $name = $*DISTRO.name;
    my $v    = $*DISTRO.version.Str; # 11.buster

    my ($version-number, $version-name) = $v.split(/\./);
    OS.new: :$name, :$version-name, :$version-number;
}

sub my-resources is export {
    %?RESOURCES
}


