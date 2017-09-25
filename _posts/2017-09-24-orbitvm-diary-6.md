---
title: "OrbitVM Diary #6 - VM & Parser"
date: 2017-09-24 22:50:00 BST
layout: post
---

So between the end of fourth year, my summer job and now gearing for my PhD, I
haven't had much time to work on Orbit, even less write about it. That's not
great, since the changes I've made over eight months are fairly significant
once you add all of them up, and I have little record of the development, save
for the git history.

I thought I'd at least do a quick recap here, before I can go back to 
(hopefully) more regular posts about the many wonderful horrors of compiler
building I'm discovering!

 * The VM runs! That includes the garbage collector, the memory allocator and
   the run loop. Not surprisingly, the last few days of development before
   getting it to run were the most frustrating -- that's when you find all of
   the silly bugs and such. Since I didn't have a compiler yet to generate
   bytecode, I had to write an assembler-ish that takes in a language halfway
   between assembly and imperative code, and generate an orbit module file. I've
   recorded a demo of all that [on youtube][1].
 
 * It's just one of the silly bugs, but it's such a common and stupid one that
   it bears repeating: C macros can bite you, hard. In the run loop, popping
   something off the stack is implemented as a macro:
   
       #define POP() (*(--task->sp))

   Now, checking that a value evaluates to `true` (true boolean, or non-zero) is
   *also* done using a macro:
   
       #define IS_TRUE(val)    ((val).type == TYPE_TRUE || (IS_NUM(val) && AS_NUM(val) != 0.0))
   
   Which led to that deliciously stupid bug in branch execution:
   
       if (IS_TRUE(POP())) {
           ...
       }
       
   See it? when `IS_TRUE` is expanded, `POP()` is called three times. It seems
   evident in retrospect, but that one cost me a few hours of head scratching -- I did not think to look there when I was seeing my stack shrinking faster than it should have been.

 * I've moved the build system to [CMake][2], cause my Makefile was becoming a
   bit unwieldy. I've also split Orbit in a bunch of libraries in the process,
   LLVM-style. My goal is to have one library for each module, and have the
   executables (`orbitc`, `orbit`) be as skinny as possible and import the right
   modules.
   
 * I have a lexer! And a parser-ish. It took a week or so going through unicode
   tables and stuff like that, but thanks to Apple's very good
   [Swift grammar][3] page, The parser supports unicode identifiers and strings.
   Yes, that includes emoji, but its mostly so that variables names can be made
   of non-roman characters. I also some sort of error reporting system (prints
   the error location, underlines the problematic bit of source code), which
   proved fun with unicode support (go figure the number of tildes required to
   underline a word that potentially contains multibyte characters).

And that's pretty much where I'm at. Right now, my next step is putting
together an abstract syntax tree system that the parser can build, and that can
then be used by following phases (semantic analysis, optimisation, code
generation). And when that's done, I'll have to have a sit down and finally
figure what in the stars the type system is going to look like, because that's
going to impact everything else pretty badly.

 [1]: https://www.youtube.com/watch?v=3t0tb3qwjl0
 [2]: https://cmake.org
 [3]: https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/zzSummaryOfTheGrammar.html
       