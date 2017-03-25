FCNPC Boss
==========

Introduction
------------

A SA-MP include that makes it possible to create boss fights like in [World of Warcraft](https://worldofwarcraft.com/en-us/start).

Created by [Freaksken](http://forum.sa-mp.com/member.php?u=46764).

[Forum thread](http://forum.sa-mp.com/showthread.php?p=3733074) on the [SA-MP forums](http://forum.sa-mp.com/).

Features
--------

- [Functions](../../wiki/Boss-functions) to control the features of the bosses.
- [Functions](../../wiki/Spell-functions) to control the features of the spells.
- TextDraws that [can](../../wiki/Boss-functions#wow_setbossdisplayrange) show the state of the bosses.
- TextDraws that [can](../../wiki/Boss-functions#wow_setbossdisplayrange) show the state of the spells the bosses cast.
- Ability to change any feature without the need of recreating the boss/spell or waiting for the [update timer](../../wiki/General-defines#wow_update_time) to tick. The change gets executed immediately and any functionality that uses the feature gets updated automatically.
- [Callbacks](../../wiki/Callbacks) that when used together can create a whole [boss encounter](./example/WOWExample.pwn#L192).
- Display large integers with a [thousands separator](../../wiki/General-defines#wow_decimal_mark) for readability.
- Ability to display floats with a different [decimal mark](../../wiki/General-defines#wow_decimal_mark) for languages in which a `'.'` is not used.
- Ability to display [shortened numbers](../../wiki/General-defines#wow_shorten_health) like 1K or 5M.
- Bosses can have a lot more [health](../../wiki/Boss-functions#wow_setbossmaxhealth) than normal players, say for example 1 million.

Media
-----

A couple of demonstrations of what is possible with this include can be found on [YouTube](https://www.youtube.com/watch?v=SFhR3oi12oY&list=PLoh7sSsjdgnS3PPWbZ350A5eUo2HuyoTc&index=3). Demonstrations of earlier versions are present as well.

Documentation
-------------

The workings of every define, function, callback or feature is extensively explained on the [wiki](../../wiki).

Download
--------
The latest version can be found on the [releases page](../../releases).

Example
-------

- An [example script](./example/WOWExample.pwn) is included in the [download](../../releases), which uses [Incognito's streamer](http://forum.sa-mp.com/showthread.php?t=102865) for objects and pickups.
- If you don't use Incognito's streamer, define [USE_STREAMER](./example/WOWExample.pwn#L23) as false.

Bugs
----

Please report any bug with detailed steps on how to reproduce it.

Suggestions
-----------

If you have any constructive criticism or suggestions, please [share](http://forum.sa-mp.com/showthread.php?p=3733074) your opinion.

Possible upcoming changes/features
----------------------------------

- [Status effects](https://en.wikipedia.org/wiki/Status_effect) (buffs and debuffs).
- Status effects stacks.
- Switch aggro (Currently the boss will only switch to another player if his target becomes invalid. You can't for example overaggro right now. You can however manually switch the target with [WOW_SetBossTarget](../../wiki/Boss-functions#wow_setbosstarget)).
- Spell cooldown.
- Spell range.
- Exclude players from threat, aggrorange and displayrange.
- Reduce cast progress a bit when the boss takes damage.
- Boss adds.
- [Party](http://wowwiki.wikia.com/wiki/Party)/[raid](http://wowwiki.wikia.com/wiki/Raid_group)-like system
- Implement the various [SPELL_TYPES](../../wiki/Spell-types) and [PERFCENT_TYPES](../../wiki/Percent-types).
- Make the [general defines](../../wiki/General-defines) boss/spell specific.
- Use MySQL or change to plugin, instead of using the various [WOW_MAX_BOSS](../../wiki/Boss-defines) and [WOW_MAX_SPELL](../../wiki/Spell-defines) defines.
- Change to plugin, so everything is shared server-wide. Currently only the callbacks are called server-wide.

License
-------

See [license](./LICENSE.md).

Credits
-------

See [credits](./CREDITS.md).