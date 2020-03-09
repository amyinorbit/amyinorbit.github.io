---
title: "Functions, Overloading, and Nesting, Oh My!"
layout: post
series: "OrbitVM Diaries"
date: 2020-03-09 11:30:00 GMT
tags: language, programming
---

I've started working on Orbit again. Over the last year or so, slowly, I've re-written most of the runtime. Nothing major changed, and yet everything has changed a bit. I've also finally made progress on [semantic analysis][sema] and [code generation][codegen], to the point that orbit now has a (small, and simple) REPL! It can parse, check, and run simple expressions as well as conditional logic (`if`/`else`/`while`, `for ... in` will come later).

![GIF demo of Orbit's REPL][repl]{: .tiny}

Now that the basics are working, the main thing missing from the language before it can be used for writing small scripts (aside from any kind of standard library) are functions. I've talked a lot about the fine details of functions invocation, but what I've realised over the past couple of weeks trying to implement the code-generation side of things is that I don't have a clear idea of the *semantics* of Orbit's functions.

 [repl]: /static/media/2020/0300-orbit.gif
 [sema]: https://github.com/amyinorbit/orbitvm/tree/f03b3f45c697ada977b1c7be2ccc82cfee33e773/libs/sema
 [codegen]: https://github.com/amyinorbit/orbitvm/tree/f03b3f45c697ada977b1c7be2ccc82cfee33e773/libs/codegen

## First Class

One thing I know for sure is that I want functions to be first-class in orbit. If you want to store a reference to a function and invoke that later, you should be able to. A function declaration should essentially be a literal, which tells the compiler about a bit of data (in this case, bytecode).
s is reflected by a slight change I've made to the syntax. Until then, a function was declared like that:

```c
fun sayHello(name: String) -> Void {
    print("Hello, " + name + "!")
}
```

In the current version of Orbit, the syntax is more in-line with the variable declaration syntax:

```c
fun sayHello = (name: String) -> Void {
    print("Hello, " + name + "!")
}
```

It's mostly an aesthetic change, but I want the syntax to reflect the semantics. I also made it so that nested functions can be parsed. If functions are treated just like any other bit of data, it makes sense that you could declare one in a limited scope. In theory, that's all fine and dandy, but no plan survives contact with the enemy. Which brings me to...

## Overloading

I really, really want overloading in orbit. I think it's one of those "small" features that go a long way to making a language friendlier to use. I want this to compile and run properly:

```c
fun test(value: Int) {} // (1)
fun test(value: String) {} // (2)

test(123) // calls (1)
test("Hello!") // calls (2)
```

The way I was going to handle this is using a function table tweaked so that lookup cares not only about the name of the function being invoked, but also its parameter list. When seeing something like `test("hello")`, the semantic analyser would go through the table and only compile if it found a function declared as `test(_: String)`.
Behind the scenes, this means we can have multiple functions declared with the same name, which does not gel too well. We solve this with name mangling: the *actual* name of the function is doctored by the compiler to include data about the parameters and return type. `test(_:String) -> Void` is actually called `_OF4testpNsev` (the grammar for this is [defined on GitHub][mangling] too). So far, so good.

 [mangling]: https://github.com/amyinorbit/orbitvm/blob/f03b3f45c697ada977b1c7be2ccc82cfee33e773/specs/name-mangling.md

Except we are not quite out of the woods. Let's say we have this:

```c
fun test(value: Int) {} // (1)
fun test(value: String) {} // (2)

fun main = {
    var captured = test
    captured(123)
}
```

In this case, `captured` is a local variable and contains a reference to... what? The compiler cannot tell, when it's compiled the declaration, which version of `test()` we intend to store. There are two solutions to this: we could forbid storing overloaded functions in variables (easy), or provide a way to tell the compiler which function we want to capture, for example `var captured = test(Int)` (not as easy, but doable). One problem solved.

But there's more. When the compiler (in its current state) sees the call to `captured(123)`, it is going to go look in the module/file's function table, and then throw an error because it cannot find a function called `captured` in there. Technically, this is right. One way to solve this is to delay throwing the error:

 1. Do a lookup in the scope stack for a variable called `captured`.
     - If no variable is found, go to 2.
     - If the variable is not callable with arguments of type `(Int)`, throw an error.
     - Otherwise, resolve the call and emit bytecode.
 2. Do a lookup in the module's function table for `captured(Int)`.
     - If no function matches, throw an error.
     - Otherwise, resolve the call and emit bytecode.
 
The last problem with that method (it never ends!) is overloading. What happens in this case?

```c
fun test(value: Int) {} // (1)
fun test(value: String) {} // (2)

fun main = {
    fun test(value: Float) {}
    test("Hello")`,
}
```

Sema is going to find a variable called `test`, and throw an error because the nested function is not callable with an argument list of `(String)` -- even though there is an overload that exists in the function table. I'm not 100% sure how (or really, if) I want to solve this. It might just be a case that only module-level functions can be overloaded. After all, that's what Swift does, and that's good enough for me!
