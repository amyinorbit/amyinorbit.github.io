---
title: "OrbitVM Diary #2 - Dispatch"
date: 2016-12-28 01:30:00
layout: post
---

I've made some progress on Orbit – well, I've setup the project directory and
started playing around with tagged unions for the `VMValue` type system. I've
also made the [repository][1] public, even though it's still pretty rough.

I'm now getting to the point where I can write a simple interpreter loop, and
start thinking about function dispatch. I really like full dynamic dispatch
like Objective-C does – that is, message-based dispatch: each function call is
done by name, followed by a dispatch table lookup before invocation.

So I've built a [hash map][2]. It's a pretty simple implementation, without any
support for deletion so far, and with linear probing. Strings in orbit are
immutable, which means the hash is only computed once at creation - for function
calls, that means when the constant pool is built, before the code starts
running. So far, so good. Looking for an entry looks a bit like this:

{% highlight c %}
for(size_t index = key->hash % map->capacity;
    map->data[index].used;
    index = (index +  1) & map->capacity)
{
    if(key->hash == map->data[index].key.hash) {
        return map->data[index].data;
    }
}

// Nothing found
return NULL;
{% endhighlight %}

The loop is required in case different hashes modulo-ed to the same index at
insertion. That part doesn't worry me too much, at least right now. What worries
me is the potential for hash collisions: what happens if two strings, both used
as keys into the same table, have the same `hash` member. I could compare both
strings, but that would destroy performance, and I can't allow that.

For now I'm using [FNV-1a][3] to hash my strings, and I want to try out
[MurmurHash][4] also. I'm going to do a few tests to see how likely I am to get
hash collisions.

In the end, I think I'm going to accept that hash collisions might happen very
rarely, but that still feels unsatisfactory, and the failure mode will be bad:
the wrong function will be invoked, followed most certainly by a crash or
corruption since the arguments are unlikely to be the right ones. Not sure I'm
okay with such a fundamental bit of the language not being certain.

   [1]: https://github.com/cesarparent/orbitvm
   [2]: https://github.com/cesarparent/orbitvm/blob/ada48b74e13255b7041644a68521470a5e422b66/src/liborbit/orbit_hashmap.c
   [3]: https://en.wikipedia.org/wiki/Fowler–Noll–Vo_hash_function
   [4]: https://sites.google.com/site/murmurhash/
