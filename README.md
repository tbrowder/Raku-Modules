[![Actions Status](https://github.com/tbrowder/RakudoPkg/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/RakudoPkg/actions)

NAME
====

**RakudoPkg** - Provides tools for easing installation and use of the `rakudo-pkg` system for Debian and Ubuntu

SYNOPSIS
========

```raku
use RakudoPkg;
```

DESCRIPTION
===========

**WARNING** - This module cannot be installed by `zef`. Its repository must be downloaded onto the desired host and then installed by the root user from its top-level directory in a similar manner to the way `zef` is installed on a new system.

**RakudoPkg** is a Raku module with programs for the root user to bootstrap the `rakudo-pkg` installation by use of a system `rakudo` package installation. After successful bootstrapping, the system's `rakudo` package should be deleted to avoid conflicts.

Note this package is designed for the purpose of setting up and standardizing multi-user Linux hosts for classrooms or computer laboratories.

Procedures for installation
---------------------------

Normally you will be using this module on a system which has not had Raku installed other than with its normal package installation, but it will uninstall completely any previous `rakudo-pkg` installation in an existing `/opt/rakudo-pkg` directory.

There are three steps to follow.

### Step 1 - Install the Debian or Ubuntu `rakudo` package and its `zef`

Since `zef` depends on `raku` all need to do is install it:

    $ sudo apt-get install perl6-raku

We use the distribution's likely older version to 'bootstrap' our desired Rakudo framework.

### Step 2 - Install the `rakudo-pkg` framework

    $ cd RakudoPkg
    $ sudo -s
    # raku -I ./bin/install-rakudo-pkg

The command does the following:

  * deletes any existing `/opt/rakudo-pkg` directory

  * installs the `rakudo-pkg` framework

  * installs the new `rakudo` package

Prompts are shown at critical points so you can abort the process if necessary.

### Step 3 - Remove the system's `rakudo` package

After becoming a normal user again:

    $ sudo apt-get remove rakudo

After this step, you may have to logout and login again to update your path.

Note the Raku package manager `zef` is not involved at this point. Any previous installation by any user is not touched. The author is planning a separate module, tentatively named `ZefAdmin`, which will help install `Zef` for non-conflicting use by both the root user and normal users.

Procedures for **complete** removal
-----------------------------------

Should you ever want to remove the `rakudo-pkg` installation, run the following program as root: `remove-rakudo-pkg`.

The pertinent parts of that bash script are shown here:

    echo "Starting removal of 'rakudo-pkg'..."

    apt-get remove rakudo-pkg
    rm -rf /opt/rakudo-pkg
    rm -rf /etc/profile.d/rakudo-pkg.sh
    apt-get update

    # clean repository info
    rm /etc/apt/sources.list.d/nxadm-pkgs-rakudo-pkg.list
    apt-get clean
    rm -rf /var/lib/apt/lists/*
    apt-get update

    echo "Removal of 'rakudo-pkg' is complete."
    exit

Note the removal does not delete anything in any users' home directory, so there may be `raku`- or `zef`-related artifacts remaining in those places.

Related modules
===============

  * ZefAdmin (NYI)

  * SysAdmin (NYI)

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2023 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

