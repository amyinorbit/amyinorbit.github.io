---
title: "OrbitVM Diary #3 - More Dispatch"
date: 2016-12-30 20:00:00
layout: post
---

I've read a bunch, and thought more about my [problem][1] with the dispatch
table I have so far for Orbit. I really don't like having the possibility of a
hash collision breaking a function call. This is one of the most basic building
blocks of the language, and I can't have that not be 100% predictable.

back to the drawing board then. I was worried about potentially comparing
multiple strings every time a function is invoked, but I can avoid that. If I
store both the function signature's length, hash and string pointer, I only need
to compare strings if both the lengths and hashes match (which is unlikely). So
now I'm down to somewhere between one and "a few" string comparisons on for each
call, even though it should be one 99.99% of the time, and it's _very_ unlikely
to be more than two. Better.

Better but still not great. Comparing strings is slow. You need to walk both of
them and compare the two byte per byte. And I can't guarantee that a user won't
write a `doSomethingReallyGreatButAwfullyVerboseEveryThousandthOfASecond()`
function. If that's called frequently, that's not awesome.

One way I can still mitigate that is by using some sort of string pool. That
way, every single (immutable) string in memory saying `"doSomething()"` will be
a pointer to the same bytes in memory. And now, I can check the strings are the
same with `key == signature` instead of `strcmp(key, signature) == 0`. Again,
better.

As an alternative, I'm considering a less dynamic option, like [java does][2]:
The first time a function is called, do the whole signature lookup, with
`strcmp` if necessary. That's pretty slow, but I can then swap the value (in
the run-time constant pool) that held the signature string to one that holds a
pointer to the function object. On future calls, I can just jump there directly.

{% highlight c %}
case opcode_invoke:
    // Get the reference from the constant pool.
    uint8_t index = bytecode_pop();
    VMValue* ref = constants[index];
    
    // If it's a symbolic reference, resolve it and replace it
    // with a direct reference.
    if(ref->type == TYPE_STRING) {
        VMFunction* func = vtableLookup(ref->stringValue);
        ref->type = TYPE_FUNCTION;
        ref->functionValue = func;
    }

    invoke_function(ref);
    break;
{% endhighlight %}


I'm not sure which of the two solutions I prefer. Provided I don't have plans
for a complex object model with inheritance, I'm thinking full dynamic dispatch
might be overkill, though that doesn't mean the string pool isn't a good idea. 

   [1]: https://cesarparent.com/post/orbitvm-diary-2/
   [2]: http://www.artima.com/insidejvm/ed2/linkmod12.html
