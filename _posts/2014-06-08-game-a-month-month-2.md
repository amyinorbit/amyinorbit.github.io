---
date: 2014-06-08 18:32:40
tags: gamedev
permalink: /post/game-a-month-month-2/
layout: post
title: "Game a Month: Month 2"
---

![Ghosts characters][1]

My goal for this month was to learn at least a little about procedural map generation, handling tile maps with SDL, and having larger-than-screen, scrolling maps. That led me to choose a top-down RPG-style world. Once this was settled, I got the idea for the game mechanics quite quickly: the player is dropped on an unknown island, where ghosts appear randomly, and must survive for as long as possible.

<!--more-->

The other main goal was to keep the code much cleaner than last month's, and have a more polished game (with a main menu, a game over screen…)

## The good things

I managed to get a first playable version of the game way earlier in the month: I was able to publish a first beta around the twentieth of April, leaving me about ten days to polish the game, the AI, and actually use feedback from the few players.

![Ghosts beta 9 screenshot][2]

Overall, the game turned out pretty well: maps are generated using a [Cellular Automaton][3], and I managed to implement a simple flood-fill algorithm to check that there is only one Island on the map. I have a reusable menu system, and even managed to have a simple [online high scores system][4].

The AI, in charge of making ghosts appear and move, is working pretty well too: after fifteen seconds of play time, ghosts appears every two second, and they try to aim for the player when s•he is nearby.

But the most gratifying part of this month was seeing people enjoy the game for real. [Scott Pilgrim][5] was stale, badly made, completely unpolished, and had weird behaviours. This time, I actually enjoyed playing the finished game, as a few other people did. Nothing could have made me happier than my brother trying to beat his high score again and again.

And on top of that, I managed to keep the code much cleaner than last month. I forced myself to break it down in smaller, single-purpose functions, instead of having hundred-line nested `if/else` statements. I managed to comment every function. I can still get way better at this, but at least I can go through my code again and understand the way it works.

## The less good things

I had a few ideas that I wanted to implement in the game to make it a bit more complex: either weapons that the player could pick up to defend him•herself, or at least "time-freezers", that would prevent all the ghosts to move for a short time. I dropped the weapons idea quite early in the process, because I preferred to keep my goals relatively low. I managed to implement time freezers in one of the builds I made a few people try, but I didn't manage to make them fun. They would be either useless, or make the game too easy.

The AI could do with some improvements too. For the moment, ghosts pick a new random direction every second, except if the player is in range. In that case, they change directions to aim for she•him every 750 milliseconds. The range I chose being a bit small, they tend to give up following the player quite quickly.

And once again, I didn't pay enough attention to the audio part of the game. I managed to find a soundtrack, and a few sound effects, but the game could really use some polishing in that domain.

## Onwards

This month made me a bit more confident that I was able to make proper games. I still have no idea at all for June, except that I would like to switch to some higher-level game engine. I'm still tempted by [Cocos2D-X][6], but the hassle needed to compile for different platform repels me a bit. From the few quick tests I put together those last few days, [SpriteKit][7] seems lovely, but it means compiling for iOS and OS X only. Since there was a load of new things introduced at WWDC, I'm tempted to take a one-or-two-month break to learn about them.

In the meantime, you can find the game (compiled for Windows and OS X) at [cesarparent.com/ghosts][8], and the source code (which should compile for Linux, even tough I haven't tried) at [GitHub][9]


[1]: /static/media/2014/06/cesar-1402247541886-raw.png
[2]: /static/media/2014/06/cesar-1402247864579-raw.png
[3]: http://gamedevelopment.tutsplus.com/tutorials/generate-random-cave-levels-using-cellular-automata--gamedev-9664
[4]: http://cesarparent.com/ghosts/
[5]: http://cesarparent.com/2014/05/game-a-month-month-1/
[6]: http://www.cocos2d-x.org
[7]: https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Introduction/Introduction.html
[8]: http://cesarparent.com/ghosts/
[9]: https://github.com/cesarparent/gam2-ghosts