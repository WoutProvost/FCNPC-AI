# FCNPC-A.I.
[![sampctl](https://img.shields.io/badge/sampctl-FCNPC--A.I.-2f2f2f.svg?style=for-the-badge)](https://github.com/WoutProvost/FCNPC-A.I.)
[![Latest Release](https://img.shields.io/github/release/WoutProvost/FCNPC-A.I..svg?label=latest%20release)](https://github.com/WoutProvost/FCNPC-A.I./releases)
[![Total Downloads](https://img.shields.io/github/downloads/WoutProvost/FCNPC-A.I./total.svg?label=total%20downloads)](http://www.somsubhra.com/github-release-stats/?username=WoutProvost&repository=FCNPC-A.I.)
[![License](https://img.shields.io/github/license/WoutProvost/FCNPC-A.I..svg)](https://github.com/WoutProvost/FCNPC-A.I./blob/master/LICENSE.md)
[![Build Status](https://travis-ci.com/WoutProvost/FCNPC-A.I..svg?branch=master)](https://travis-ci.com/WoutProvost/FCNPC-A.I.)

FCNPC-A.I. is an include for SA-MP servers that extends on the [FCNPC](https://github.com/ziggi/FCNPC) plugin by adding a simple targeting and threat artificial intelligence system to the NPCs. See the [changelog](./CHANGELOG.md) for a full list of versions and their updates and the [license](./LICENSE.md) for any legal rules.

If you encounter a bug, create an issue in the [issues section](../../issues) with detailed steps on how to reproduce it. For more elaborate discussions or script examples, see the [forum thread](http://forum.sa-mp.com/showthread.php?p=3733074).

## Installation
Simply install to your project:
```bash
sampctl package install WoutProvost/FCNPC-A.I.
```

Include in your code and begin using the library:
```pawn
// When you only need the A.I. functionality
#include <FAI>

// When you also need the MMO functionality (textdraws, spells, ...)
#include <MMO>
```

## Usage
For detailed documentation, see the [wiki](../../wiki).
### Constants
```pawn
//TODO
```
### Functions
```pawn
//TODO
```
### Callbacks
```pawn
//TODO
```

## Testing
<!--
What sampctl package run does - run unit tests or prompt user to connect as a player.

Whether your library is tested with a simple `main()` and `print`,
unit-tested, or demonstrated via prompting the player to connect, you should
include some basic information for users to try out your code in some way.

Depending on whether your package is tested via in-game "demo tests" or
y_testing unit-tests, you should indicate to readers what to expect below here.
-->
To test, simply run the package:
```bash
sampctl package run
```

## Special thanks
Many people have (indirectly) contributed to make this system possible. See the [credits](./CREDITS.md) to see who.
