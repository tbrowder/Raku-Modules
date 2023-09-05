raku -e 'say $_ for "somefile.txt".IO.lines[^(*-3)]'

