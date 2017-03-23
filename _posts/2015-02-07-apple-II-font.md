---
date: 2015-02-07 23:21:00
tags: programming, typography
permalink: /post/apple-II-font/
layout: post
title: Making fonts like it’s ’77
---

![Apple II font](/static/media/2015/02/appleiifont.png)

For my second year CS degree project, I'm making a virtual machine from top to bottom (instruction set, assembler, virtual processor). I am not Intel, so the instruction set is limited, inspired by the Motorola 6800. Since I was going to have an old-style processor, I had to get a matching font. I have a weakness for the one that shipped with the different variants of Apple _][_: it has some inconsistencies, but I find the glyphs very pleasing to the eye.

My only problem was that I could not find a version of the font encoded for use with C/C++. Image and TrueType versions can easily be found, but no raw bits, so I made one. It took a while —ninety-six glyphs, five columns of eight pixels each— but I now have a brilliant retro font ready to use in any of my projects. The source file is available [over at GitHub](https://github.com/cesarparent/Apple-Bitmap-Font) and is completely free to use.

_If you like retro computing and have a thing for typography, Damien Guard has made an [excellent post](http://damieng.com/blog/2011/02/20/typography-in-8-bits-system-fonts) on 8-bit fonts used in early computers._