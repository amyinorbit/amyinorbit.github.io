---
title: "Return of the Function Call"
date: 2017-01-16 22:00:00
layout: post
series: "OrbitVM Diaries"
redirect_from: /post/orbitvm-diary-5/
excerpt_separator: 
---

I have discussed function invocation in Orbit before, but then it was all about
[resolving functions][1] and handing control. This part is (I think) done. like
I'd said [last time][2], I've gone with a hybrid message/direct dispatch system.
On first invocation, the function is resolved by name, in a hashmap. The
bytecode is then doctored so that future invocations are just a matter of
following a pointer to the function's bytecode ([code on github][3]).

## Calling Convention

Something I need to think about now is how I do parameter passing and local
variables. OrbitVM is stack-based, so parameters must be passed, well, on the
stack.



I want functions to behave exactly like opcodes, stack wise: after a function
returns, all of its parameters must have been popped off the stack, and the
return value pushed on top of it. The stack before the function call might look
like this (the stack grows downwards):


    |---------------|
    | some value    |
    | param 0       |
    | param 1       |
    | param 2       |
    |               |<-- Stack Pointer
    |               |
    |_______________|
    
When preparing the function call, we create a new call frame. It holds a  base
pointer points to the base of the frame, which should be the first element in
the parameter list. This way, a simple `currentFrame->stackBase[0]` gives us
the first parameter. good.


    |---------------|
    | some value    |
    | param 0       |<-- Base Pointer
    | param 1       |
    | param 2       |
    |               |<-- Stack Pointer
    |               |
    |_______________|

There are two opcodes in Orbit that deal with local variables: `load_local` and
`store_local`. What they do is pretty obvious: they either push a value from
a local variable slot to the top of the stack, or pop one from the stack into a
local variable slot. So we need an array of locals, somewhere.

Once in a function, parameters are used like local variables, thus there's no
need to handle them any differently. When we call the function, instead of
leaving the stack pointer untouched, we move it down by the number of local
variables slots required by the function (this is know at compile time, and
embedded in the bytecode file). For example, if our example function requires
two local variables, the stack right after invocation will look like this:


    |---------------|
    | some value    |
    | param 0       |<-- Base Pointer
    | param 1       |
    | param 2       |
    | local 0       |<-- (Old Stack Pointer)
    | local 1       |
    |_______________|<-- Stack Pointer

"local 0" and "local 1" is not completely accurate. To push the first local
variable's value onto, the stack, the bytecode will actually push the value
at index #4 in the locals/parameter array (`load_local, 0x04`) . I could have a
second pointer that points to the start of the local variables, but that would
require a second pair of opcodes (`load_param`, `store_param`), while the
compiler can just offset local variable access by the number of parameters.

## Returning

Returning is pretty simple. We've stored where the stack pointer (minus our
parameters were) in the frame's base pointer, So we can restore that. There's
one gotcha: if there was a return value (and we called `return_val` instead of
just `return`), it was on top of the stack, and we just lost track of that when
we restored the stack pointer. So if we're returning a value, `return_val` must
pop the return value, restore the stack pointer, and then push the return value
back on the (newly restored) top of the stack.


    |---------------|
    | some value    |
    | return value  |<-- (Old Base Pointer)
    |               |<-- Stack Pointer
    |               |
    |               |
    |               |
    |_______________|

And this achieves exactly what I want: the three parameters were popped off the
stack, never to be seen again, and the return value is on top. The only change
I need to make the the current implementation is add the number of local
variables to the (work-in-progress) bytecode file format.

  [1]: https://amyparent.com/blog/orbitvm-diary-2
  [2]: https://amyparent.com/blog/orbitvm-diary-3
  [3]: https://github.com/amyinorbit/orbitvm/blob/a0059f238f7bd97ffdbf39d83523c84a0067dca1/src/liborbit/orbit_vm.c#L217
