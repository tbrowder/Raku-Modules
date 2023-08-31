unit module  RakudoPkg;

class OS is export {
    has $.name;    # debian, xenial, ...
    has $.version; # buster
    has $.vnumber; # 10, 11, ...
}

sub os-ver(--> OS) is export {
    my $name = $*DISTRO.name;
    my $v    = $*DISTRO.version; # 11.buster
    my ($vnumber, $version) = $v.split('.');
    OS.new: :$name, :$version, :$vnumber;
}

sub my-resources is export {
    %?RESOURCES
}


