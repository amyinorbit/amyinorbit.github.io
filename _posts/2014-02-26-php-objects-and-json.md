---
title: PHP, objects and json
layout: post
date: 2014-02-26 00:00:00
permalink: /post/php-objects-and-json/
---

For the last three personal projects I've worked on, I needed some kind of way to save objects (let's say, for example, a [review][1]) on the server. After all, there wouldn't be much use in creating those objects if they were to be deleted as soon as the user looks away.

<!--more-->

The most obvious way to do that would have been to use a database, PHP has [built-in functions][2] for that. But databases (namely, SQLite and MySql) make me uneasy for three reasons:

* My only server for the moment is a shared hosting plan, which allows me to create only one MySql database (and to use only PHP, which I would have fled otherwise);

* I like portability _a lot_. If I wanted to use the saved data anywhere else, I would need to do a database dump, hardly readable by humans, and then convert it to any format needed;

* I'm lazy: I am not at all fluent in SQL, the language used to make queries to databases, and didn't want to delay a project to learn it.

Instead, those three projects use flat files, containing json-formatted objects. A movie review, for example, would look something like this:

{% highlight json %}
    {
       "actors": "Jennifer Lawrence, Josh Hutcherson, Liam Hemsworth",
       "director": "Francis Lawrence",
       "title": "Hunger Games: Catching Fire",
       "rating": 4,
       "genre": "Science fiction",
       "mediaType": "movie",
       "uid": 0,
       "lastmod": 1390428994,
       "body": "some description",
    }
{% endhighlight %}

It's relatively easy to read, and almost any modern language can parse this. So each of those three projects has its own functions to handle the conversion between those files and objects. It's probably not as fast as a database, but it's good enough for my simple, small projects.

Instead of rewriting the same thing again, I've tried to clean up the code a bit, and make it a library, [JSONStorage, available on GitHub][3]. The Read Me file and its examples should be detailed enough to understand how to use it.

It work, and I plan to replace the different project's version with this one, but it's not perfect by any means. there are probably edge cases I haven't though of, security problems I haven't yet picked up. If you find some, don't go bananas: tell me, I'm eager to do better, and learn along the way. Or, you can fork the project and submit your modifications. In any case, I'll be pleased to hear from you if you decide to use it.


[1]: http://reviews.cesarparent.com/?media=movie&id=0
[2]: http://uk1.php.net/PDO
[3]: https://github.com/amyinorbit/JSONStorage