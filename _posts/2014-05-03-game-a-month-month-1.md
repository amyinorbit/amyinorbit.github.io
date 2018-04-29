---
date: 2014-05-03 15:33:35
tags: gamedev
permalink: /post/game-a-month-month-1/
layout: post
title: "Game a Month: Month 1"
---

![Scott Pilgrim.png][1]  
_Last version before deadline_

Now that my first month of game development has ended, I thought I'd have a look at what I have done, and what I could or should have done differently.

The goal was to make a simple Super Smash Bros inspired game in C/SDL2, based on the Scott Pilgrim comics. This was my first real project in C, the first time I used SDL, and my first game, so I wasn't really expecting to succeed when I started.

<!--more-->

## The good parts

I managed to get a game working: it launches, takes inputs from two players (using keyboard and/or gamepads), detects and announces when a player wins.

I also enjoyed making it much more than I expected, especially the art part. I decided to go the pixel art way because it seemed easy, which it is absolutely not, but even while re-doing the same sprite image for the tenth time, I had fun.

![Matthew Patel][2]  
_It is I, Matthew Patel!_

Finally, the fact that I had a real project and goal gave me motivation to learn at least the basics of C properly, and I think I'll remember the concepts I learned this time way better than if I had just followed a step-by-step tutorial.

## The less-good parts

This is, unsurprisingly, the easiest part to write. First because the game isn't that fun to play: the physics and collision detections are quite dodgy, dropped frames make characters go through platforms, making the whole thing unpredictable.

I also wish I'd spent more time on the overall game structure: as of now, the game starts as soon as the application is launched, each player has one life, and as soon as one gets thrown out of the stage, the other one wins, and the game quits. There are no menus, no play again screen, no character selection, and it makes the whole thing a bit stale.

And the biggest grudge I have is against my code. I tried to keep it organised, clean and commented, but the further I was into the month, the hacker my code became. Some bits written at the beginning are commented everywhere, whereas the functions I wrote in the last few days are hacky, to say the least[^1].

## Taking some distance

Overall, I'm still happy to have finished a simple version of the game before the deadline. I had fun, learned new things, and I can play Scott Pilgrim on my computer. Granted, the game isn't loads of fun, which is a little failure, but this is also why I'm doing this game a month thing: make mistakes, learn, and do better the next month.

Working with bare C and SDL, without any existing engine, was interesting, but I'm considering switching to Cocos2D-X or even Unity for the next one, which would allow me to cross-compile to any platform, and have some of the basics covered (collision detection and the likes).

[The game][3] (Mac version only for the moment) and its code are [available on GitHub][4]. I'm waiting to get back to University to compile the Windows and Linux versions of the game.

[1]: /static/media/2014/05/img-1398949031321-raw.png
[2]: /static/media/2014/05/img-1399125578609-raw.png
[3]: https://github.com/amyinorbit/GaM1-Scott-Pilgrim/releases/tag/v1
[4]: https://github.com/amyinorbit/GaM1-Scott-Pilgrim

[^1]: This, by the way, led to a scary memory leak. A texture kept being allocated each time the game loop ran, taking about 500MB of RAM in twenty seconds. Ahem.