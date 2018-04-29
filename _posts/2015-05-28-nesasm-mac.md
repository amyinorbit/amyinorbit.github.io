---
date: 2015-05-28 11:30:00
tags: gamedev, nintendo
permalink: /post/nesasm-mac/
layout: post
title: NESASM for Mac
excerpt_separator: ""
---

I have (slowly) started to learn how to make game for the NES. I knew most of its processor's (6502) instruction set from working on processor design all semester, but it turns out coding in assembly means much more than knowing the language.

I made up my mind and decided to follow the series of tutorial most forums point to, [_Nerdy Nights_](http://nintendoage.com/pub/faq/NA/nerdy_nights_out.html). The only problem is that most of its toolchain is available only on windows. There are plenty emulators that will run on OS X, but NESASM does not. There are other more complete 6502 assemblers — lots of developer seem to like ca65 — but they lack NES-specific features that can remove some friction in the development process.

After a bit of digging, I found the source of NESASM 3.1, which seems to be the latest version to date. As it turns out, it is written in C, is open-source and does not rely on any Windows-specific libraries. Getting it to compile with Clang was just a matter of writing a small Makefile.

If you are developing for the NES on a Mac, I put the Makefile — and, for convenience, the source under its original license — on [GitHub](https://github.com/amyinorbit/NESAsm-3.1-Mac). You will need Xcode, or at least its Command Line Tools installed to build it.