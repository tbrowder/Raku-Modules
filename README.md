[![Actions Status](https://github.com/tbrowder/RakudoPkg/actions/workflows/test.yml/badge.svg)](https://github.com/tbrowder/RakudoPkg/actions)

NAME
====

**RakudoPkg** - Provides tools for easing use of the 'rakudo-pkg' system for Debian and Ubuntu

SYNOPSIS
========

```raku
use RakudoPkg;
```

DESCRIPTION
===========

**RakudoPkg** is a Raku module with one script for the root user to bootstrap the 'rakudo-pkg' installation on a rudumentary 'rakudo' package installation. After successful bootstrapping, the system's 'rakudo' package should be deleted.

Note this package is designed for the purpose of standardizing multi-user Linux hosts for classrooms or computer laboratories.

Procedures
----------

### Assure you have the prerequisites for the use case

  * The `/opt/rakudo-pkg` directory does not exist.

        $ sudo rm -rf /opt/rakudo-pkg

  * The root user has no existing .raku, .zef, or zef directories.

        $ sudo -i; cd root; rm -rf .raku .zef zef

  * No normal users have any existing .raku, .zef, or zef directories.

        $ cd; rm -rf .raku .zef zef

### Install the Debian or Ubuntu `rakudo` package

    $ sudo apt-get install rakudo

We use the distro's version to 'bootstrap' our desired Rakudo framework.

### Install the `rakudo-pkg` framework

    $ sudo rp-root install

The command does the following:

  * deletes any existing /opt/rakudo-pkg directory

  * deletes any existing .raku, .zef, or zef directories for root.

  * installs the rakudo-pkg framework

  * installs the new rakudo package

  * removes the system rakudo package

  * installs and updates zef for root

### Install a curated set of modules for public use

A list of modules the author uses is in `%?RESOURCES`, but another list may be provided if desired. The input list must be a text file with one module name per line (along with any adverbs desired).

### Install zef for a user

    $ rp-user install

The command does the following:

  * deletes any existing .raku, .zef, or zef directories for the user.

  * installs and updates zef for the user.

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2023 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

