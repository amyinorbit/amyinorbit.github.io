---
title: "Functions, Overloading, and Nesting, Oh My!"
layout: post
series: "OrbitVM Diaries"
---

I've started working on Orbit again. Over the last year or so, slowly, I've re-written most of the runtime. Nothing major changed, and yet everything has changed a bit. I've also finally made progress on [semantic analysis]() and [code generation](), to the point that orbit now has a (small, and simple) REPL! It can parse, check, and run simple expressions as well as conditional logic (`if`/`else`/`while`, `for ... in` will come later).

Now that the basics are working, the main thing missing from the language before it can be used for writing small scripts (aside from any kind of standard library) are functions. I've talked a lot about the fine details of functions invocation, but what I've realised over the past couple of weeks trying to implement the code-generation side of things is that I don't have a clear idea of the *semantics* of Orbit's functions.

## First Class

One thing I know for sure is that I want functions to be first-class in orbit. If you want to store a reference to a function and invoke that later, you should be able to. A function declaration should essentially be a literal, which tells the compiler about a bit of data (in this case, bytecode).
s is reflected by a slight change I've made to the syntax. Until then, a function was declared like that:

    fun sayHello(name: String) -> Void {
        print("Hello, " + name + "!")
    }

In the current version of Orbit, the syntax is more in-line with the variable declaration syntax:

    fun sayHello = (name: String) -> Void {
        print("Hello, " + name + "!")
    }

It's mostly an aesthetic change, but I want the syntax to reflect the semantics. I also made it so that nested functions can be parsed. If functions are treated just like any other bit of data, it makes sense that you could declare one in a limited scope. In theory, that's all fine and dandy, but no plan survives contact with the enemy. Which brings me to...

## Overloading

I really, really want overloading in orbit. I think it's one of those "small" features that go a long way to making a language friendlier to use.



















