[![Actions Status](https://github.com/tbrowder/RakudoPkg/actions/workflows/test.yml/badge.svg)](https://github.com/tbrowder/RakudoPkg/actions)

NAME
====

**RakudoPkg** - Provides tools for easing installation and use of the 'rakudo-pkg' system for Debian and Ubuntu

SYNOPSIS
========

```raku
use RakudoPkg;
```

DESCRIPTION
===========

**RakudoPkg** is a Raku module with programs for the root user to bootstrap the 'rakudo-pkg' installation by use of a system 'rakudo' package installation. After successful bootstrapping, the system's 'rakudo' package should be deleted to avoid conflicts.

Note this package is designed for the purpose of standardizing multi-user Linux hosts for classrooms or computer laboratories.

Procedures
----------

Normally you will be using this module on a system which has not had Raku installed other than with its normal package installation, but it will uninstall completely any previous `rakudo-pkg` installation in an existing `/opt/rakudo-pkg` directory.

There are three steps to follow.

### Step 1 - Install the Debian or Ubuntu `rakudo` package

    $ sudo apt-get install rakudo

We use the distro's version to 'bootstrap' our desired Rakudo framework.

### Step 2 - Install the `rakudo-pkg` framework

    $ sudo install-rakudo-pkg

The command does the following:

  * deletes any existing /opt/rakudo-pkg directory

  * installs the rakudo-pkg framework

  * installs the new rakudo package

### Step 3 - Remove the system's 'rakudo' package

    $ sudo apt-get remove rakudo

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2023 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

