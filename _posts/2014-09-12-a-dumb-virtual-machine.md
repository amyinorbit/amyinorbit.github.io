---
tags: programming, hardware
title: A dumb virtual machine
layout: post
date: 2014-09-12 12:32:32
permalink: /post/a-dumb-virtual-machine/
---

![DumbVM in action][1]{: .small}  
_DumbVM in action, running a [21-line programme][2]_

Last year, my course had a module called "Computer Hardware and Operating System". For someone like me who loves understanding how things work, it was a blast: we went from the concept of basic logic gates to building a simplistic working processor. The fact that our lecturer was passionate about his subject probably helped a lot as well.

Since I have been slacking off my game-a-month project, I though it could be interesting to try and implement what I learnt in that class to build a very simple virtual machine in C that could read, assemble and run very simple programmes.

<!--more-->

It was easier than I first expected it to be, and in two days I managed to get at least an assembler and a processor working. The whole virtual machine is quite simple: it has a cpu, four 8-bit registers used for storage and calculation, one output register, and should eventually have an input register, storing whichever key was last pressed. It doesn't even have RAM for the moment, except for the one in which the program is loaded when the machine is booted.

The instruction set is very simple as well: two registers can be added (`add`), subtracted (`sub`), multiplied (`mul`) or divided (`div`). Unconditional and conditional jumps are _very_ basic.

Programmes are written in a custom assembly language, and the assembler converts them to machine code before loading them in the programme memory. Machine instructions are represented as four-byte words.

The [whole "documentation"][3] for the language can be found on [GitHub][4], along with the (probably awful) source code for the machine and the assembler. Feel free to fork it or send me pull request if you think I've done something horrible or simply want to make it better.


[1]: /static/media/2014/09/cesar-1410520829504-raw.png
[2]: http://cesarparent.com/files/raw/virtual.asm
[3]: https://github.com/cesarparent/DumbVM#instruction-set
[4]: https://github.com/cesarparent/DumbVM