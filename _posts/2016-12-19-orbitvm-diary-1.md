---
title: "Adventures in Language Design: OrbitVM diary 1"
date: 2016-12-19 12:00:00
layout: post
---

Apparently, my brain isn't satisfied with having to manage fourth year and my
honours project, so I needed (yet another) side project. I'm making my own
programming language, probably called Orbit (or OrbitVM).

The (far-away) end goal would be to use the language for scripting in the
upcoming rewrite of my game engine (look ma, another side project!). For the
time being though, I'll be happy if I can run simple scripts with the basics of
any language: a type system, functions, flow control, possibly some lightweight
object system.

I don't particularly fancy going all the way down to machine code, so it'll be
VM-based, very much like Java: a compiler that compiles each script file to a
bytecode file, and a VM that loads those files and runs the `main()` function.

So far, my specs for the language are:

 * Bytecode-based with a C virtual machine that can be embedded in other
   programs. I'm going for a stack-based VM, which makes compiling a lot easier
   than using registers.

 * C function interface. I want to be able to expose C functions to the language
   and call language functions from C.

 * Static typing enforced in compiler, possibly with type inference (very much
   like Swift's `var varName (:type) = literal`. Values in the VM will be some
   sort of tagged union to enable runtime introspection. No full-dynamic,
   string-magically-becomes-an-int typing.

 * Procedural language, at least at the beginning. Like C, data-only structs and
   functions. Some object orientation could be added later by passing `self` as
   a function's first parameter (like every OOP language I know of), maybe even
   inheritance.

 * Garbage-collected language. I tend to prefer reference counting over garbage
   collection, mostly because it means resources are deallocated the very moment
   they aren't needed anymore, but I want the language to be accessible to game
   designers without having to worry about strong and weak references.

 * Int, Float, String, Array and Map as native types - implemented as much as
   possible through C native functions for speed. Strings are immutable (like in
   Java or Objective-C), Arrays and Dict can contain objects of different types.

 * All operators, even standard ones, implemented as functions. I'm not sure
   about the syntax yet (probably something like `infix +(Int a, Int b): Int`).
   The most common (maths) would be implemented as core library C functions.

 * Runtime dynamically dispatched calls. Like in [Objective-C][1] or in
   [Java][2], function calls are done by name, and resolved at call time. Each
   function call will be normalised (`int dosomething(int a, int b)` in C would
   become for example `dosomething(i,i)i`) and that normalised handle is used as a
   key into the VM's dispatch table.

A lot of this is inspired pretty heavily by Swift and Objective-C, which I have
always liked working with. I'm only just getting started, so much of it might
change as I dive deeper into language design. I've already made a quick sandbox
VM to play around with that can run some rudimentary bytecode, but it looks like
the compiler is going to be the most complex part. Luckily, it turns out that one
of my classes next semester is called... "compilers & languages".

In the meantime, I am going to keep a diary of my progress – I found
Brent Simmon's [Vesper Sync Diary][3] series to be incredibly invaluable, and I
like talking about nerdy things like compilers, VMs and programming languages.

 [1]: https://www.mikeash.com/pyblog/friday-qa-2012-11-16-lets-build-objc_msgsend.html
 [2]: https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-6.html#jvms-6.5.invokedynamic
 [3]: http://inessential.com/vespersyncdiary

