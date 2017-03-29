---
tags: writing, programming
title: Counting my words
layout: post
date: 2013-10-28 00:00:00
permalink: /post/counting-my-words/
---

This year, I decided to tag along for [NaNoWriMo][1]. I've had quite a few attempts at writing fiction, but every single one ended with a chapter, sometimes two, rotting on my computer. Plus, I went from forty-five hours of class each week to only thirteen this year, so the not–enough–time excuse won't work anymore.

<!--more-->

NaNoWriMo starts in two days, and I only have a very vague idea of my plot, so, of course, I procrastinate by coding. To ease the guilt, I decided to code something that would be more or less useful for this month: a way to display a word count here, on my blog. I could probably have used the official widget, but I didn't want the count to be an image, and I had a few special requirements.

here comes [WriCount][2] (yes, the name's lame). I plan to write my novel in [markdown][3], one file per chapter. Each time the ruby script runs, it will count the words in all the files in my working directory, and poke the server-side script, which updates a small file on my site. Every time my blog is loaded, a small javascript function will load and print my word count wherever I want. Simple.

if your setup is close enough and you're interested in using WriCount (I definitely have to find a better name), [head over to GitHub][2]. If you need to adapt your script, you can fork the repository and contribute. And if you see something in the code that makes you want to hit me with a baseball bat, (1) please don't, and (2) [give me a shout][4], I'll be eager to learn more!

[1]: http://nanowrimo.org
[2]: https://github.com/amyinorbit/wricount
[3]: http://daringfireball.net/projects/markdown/
[4]: http://cesarparent.com/me/#contact