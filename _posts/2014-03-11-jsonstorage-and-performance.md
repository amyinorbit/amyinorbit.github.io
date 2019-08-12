---
tags: programming, php
title: JSONStorage's performance
layout: post
date: 2014-03-11 11:58:51
permalink: /blog/jsonstorage-and-performance/
---

It turns out my trivial [object-to-json-and-back library][1] might not be so trivial after all.

On the current version, querying an object requires that you know its unique ID and call `$storage->objectAtIndex("someIndex")`. [The method][2] is quite simple: since each object is stored in its own JSON file, the code just checks if the right file exists, and then loads only that object. Whatever the number of stored objects, you only ever load a small one-object file.

<!--more-->

Things get worse when you request all of the stored object. The method will have to loop through all the files, load each of them, and process them. This is much less efficient than loading one big file, but this isn't a case I'd thought I'd encounter often.

I was wrong. For my current project, I need to be able to make "complex" queries. For example, all objects with a `sync_id` greater than a certain number. And for that, as far as I know, I need to load all the objects, and sort them, which means loading a thousand small files if there are a thousand objects. The obvious solution would be to change the way [JSONStorage][3] works, to store every object in one big JSON file. But there is a trade-off: global queries will be quicker, but queries for an object which ID you know will load all the objects and sort through them, like any other query.

I don't know yet what the solution is going to be. I have started making changes to JSONStorage to try and see which method is the fastest. Maybe I'm overestimating the problem, since the library is meant for small sets of data (programmatically speaking, a thousand three-key objects is still a small set). Maybe I'm not, in which case I might consider switching to SQLite. _Sigh._


[1]: http://amyparent.com/2014/02/php-objects-and-json/
[2]: https://github.com/amyinorbit/JSONStorage/blob/master/Storage.php#L83
[3]: https://github.com/amyinorbit/JSONStorage/