---
date: 2015-08-24 23:25:00
tags: gamedev, tools
redirect_from: /post/game-making-tools/
layout: post
title: Game Making Tools
---

[Last weekend]({% post_url 2015-08-19-dare-protpoplay %}), I got asked by a few visitors how to get started in game development, and what tools I use to make my games. I'm probably not that qualified to answer the former — I'll still try to make a longer article some time in the future — but I thought I'd make a quick list of my game making tools.



## Graphics

I use [Photoshop CC](http://www.adobe.com/products/photoshop/features.html) for sprites, posters and everything that requires some image editing. I used to work with [Pixelmator](http://www.pixelmator.com), which is more than enough for my pixel art needs, but Photoshop is a bit better in a lot of small ways, and handles my Wacom tablet with less lag.

Photoshop requires a bit of setup to play well with pixel art. I usually turn on the pixel grid (`View > Show > Pixel Grid`) and work with the pencil tool (long click on the brush tool to select it). Most tools (Magic Wand, Lasso, Eraser) can be set to pencil mode to prevent anti-aliasing and half pixels. When resampling/resizing, always use the *Nearest Neighbour* algorithm, and stick to integer scaling factors.

When working with guides, Photoshop can get a bit finicky and disabling _Snap To Guides_ (`View > Snap To > Snap To Guides`) usually solves that. When working on an animation spritesheet, I use the animation feature (`window > Timeline`) to check if it looks right without going through a full export to the game engine.

![Photoshop CC 2015](/static/media/2015/08/tools-pscc.png) 

I have tried [Pixen](http://www.pixenapp.com) in the past and found it to be OK, but I prefer working in a complete environment where I can go from high resolution line art to pixel art sprites.

## Game Design

For that bit, everything's fair game. I carry a notebook and .05 marker all the time, and that's usually where I write down and doodle ideas first. I've used markers and pencils, cut out cardboard characters, played with Lego to try to flesh out an idea, but there's no magic recipe. Sometimes you just find that one thing that makes the game fun, and that's all you need.

Once I get a pretty good idea of what I want to do, I usually code a very quick prototype that allows me to adjust mechanics until I'm happy with the result. Even during that phase I keep a pen and some paper at hand.

## Code Editing

For the language bit, I stick to C++ (and C for Ghosts, although this might change). I like it (and hate it) because I love programming in general, and I like how close to the metal both languages are. I've made myself a small game engine (PixelKit, which is getting a rewrite as [Meteor](https://github.com/amyinorbit/Meteor)) which abstracts away drawing, audio and input. For the moment, those section of the engine rely on [SDL&nbsp;2](https://www.libsdl.org), but I'm planning to switch to raw OpenGL at some point.

I use the [Clang/LLVM compiler](http://clang.llvm.org), which works perfectly for what I do. It supports the latest standards (C++14 and C11), and compiles fast enough even on my slow processor. For windows builds I use a cross-compiled version of MingW running GCC 5.1. It's not as nice as having a Windows virtual machine to compile from, but it's enough for my small games.

![Xcode 7](/static/media/2015/08/tools-xcode.png)

I usually program in [Xcode](https://developer.apple.com/xcode/): it gives me good code completion, and takes away the pain of packaging `.app` bundles for the OS&nbsp;X. I've tried to make a compiler plugin for MingW, but it turned out much too complex and I now rely on a Makefile for Windows builds. For quick edits and for Ghosts, I edit source files with [TextMate&nbsp;2](https://macromates.com) and compile from the command line with `make` (or `xcodebuild`). Instruments (part of Apple's developer tools) can help a lot when it's time to optimise and chase down memory leaks.

## Hardware & various apps

All those tools run fairly well on my late-2013 MacBook Air (the low-end model, at 1.3GHz) running OS&nbsp;X 10.10 (Yosemite). I use an Xbox&nbsp;360 wired controller (with [TattieBoogie's driver](http://tattiebogle.net/index.php/ProjectRoot/Xbox360Controller/OsxDriver)) for game testing. I don't have the space — or, really, the power — needed to run Windows in a virtual machine, so I usually test Windows builds on University computers.

For backups — which have come in handy more than once — I use Time Machine on a 1TB portable hard drive (WD MyPassport) and keep all my game-related files in Dropbox, which keeps a file history for thirty days. This has been enough so far, but I should probably invest in online backup as well.

***

These few tools are the ones I spend 99% of my time in. They'll be different than the next game developer's and some are specific to Mac, but most of them have good (if not better) equivalents on Windows. Tools don't make a game anyway. If you have an idea, use what you feel the most comfortable with and you'll be fine!