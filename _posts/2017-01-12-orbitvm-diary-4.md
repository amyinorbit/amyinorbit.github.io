---
title: "OrbitVM Execution"
date: 2017-01-12 14:25:00
layout: post
series: "OrbitVM Diaries"
redirect_from: /post/orbitvm-diary-4/
excerpt_separator: 
---

So I now have the beginning of a [type system][1] (need to write about this) and
a [garbage collector][2] for Orbit, which means I need to start thinking about
how bytecode actually runs.

I want to have system close to java's, where the machine takes in compiled
object files that contain the bytecode for a script, along with the constant
pool and user-defined type. That's step 1.

Where it gets a bit less clear to me is what happens when I want to start
running the newly loaded module (let's call it a module). Ideally, it's a call
to `orbit_run(OrbitVM* vm, VMModule* module, const char* signature)`. So in
order to have that, I have to do a few things.



 1. Resolve the function that matches `signature` in the module.
 
 2. Create a new object that represents this execution. Let's call it `VMTask`.
    Each task will probably need its own operand stack and call frames stack.
    
 3. Push a frame in the task's call stack that points to the start function.
 
 4. Start running bytecode, pushing more functions as we go, until the call
    frame stack is empty.

For the moment, I'm fairly happy with this. Global variables live in their
module, and as long as I have a way to save a module from being garbage
collected in between tasks, I can reuse it multiple times -- say, once per game
loop if it were used for game engine scripting. Plus, `VMTask` could easily
become a co-routine or thread system.

  [1]: https://github.com/amyinorbit/orbitvm/blob/1c1d39e3bf32bcf02643968f2ccd40f54de809f2/src/liborbit/orbit_value.h
  [2]: https://github.com/amyinorbit/orbitvm/blob/1c1d39e3bf32bcf02643968f2ccd40f54de809f2/src/liborbit/orbit_gc.c
