---
tags: blogging, programming
title: Searching a static blog
layout: post
date: 2014-01-07 00:00:00
permalink: /post/searching-a-static-blog/
---

![Search Form on the blog](/static/media/2014/01/search.png)

One of the biggest advantages of dynamic blog systems (Wordpress, for example), is the search feature. Since every page is rendered when it's requested, after fetching some information in the database, the engine can also search for a set of words in _all_ the titles of _all_ the posts on the website.

<!--more-->

A shame I don't use Wordpress, then. I am not a big user of search forms myself — well, not on blogs — but I admit they can be useful[^1]. The problem is, on a static blog like that one, everything is, well, static. Each post, page and archive is just a plain HTML file, generated once, and served whenever a visitor arrives, which means there's no consolidated database of all the content, and most of all no software that runs searches when a user requests it. I've been hesitating between what I think are the two main solutions:

## Use Google

After all, it's in my best interest that the blog is indexed by Google. If so, why not just redirect the search to a [custom Google search][1]? That's what I did on the blog's first version. That worked, but I certainly didn't like it. Because it sends the reader outside of the blog, but mainly because it looks wrong, and that the function is dependant on Google: If they're down — which, to be honest, probably hasn't happened in quite a while — or if a page isn't indexed, the results aren't good.

## Javascript

That leaves us with Javascript. Today, most browsers have a fairly good support of javascript, and there are seldom chances that the user has it disabled.

The problem is, javascript works locally, on the user's computer. Which means it can't access the markdown files from which the posts are generated. I could try to send requests for each of them when a user submit a search, but the high volume of data would make the whole thing slow and basically useless.

After some googling, it turns out the most used solution is, surprise surprise, _indexing_. After all, isn't it what Google does?

So, when the blog files are regenerated, a `search.json` file is generated at the root of the blog. It contain one entry for each post, formatted that way:

{% highlight json %}
    {
    	"title": "Some great post",
    	"url": "http://cesarparent.com/2014-01-great-post/",
    	"date": "Jan 2, 2013",
    	"readingTime": 2,
    	"tags": [
    		"blogging",
    		"jquery",
    		"programming"
    	]
    }
{% endhighlight %}

That way, when the search page is loaded, the script sends only one request, for that file (which currently weighs about three kilobytes) instead of one request per post (of a few kilobytes each).

Then, each time the content of the search field changes, it's compared against the titles and tags of each post in the JSON file. If there's a match, the content of the page is dynamically updated with the current results, without having to reload the page.

{% highlight js %}
    // basic search logic
    // the function is triggered each time the search changes

    var matchScore = 0;

    if (article.tags) { // if there are tags set for the post
    	$.each(article.tags, function(id, tag) {
    		// if the current search is included in the tag, add one to the match score
    		if (tag.toLowerCase().indexOf(search_term) !== -1) {
    			matchScore ++;
    		}
    	});
    }

    // if the current search is included in the title,…
    if (titleLowerCase.indexOf(search_term) !== -1) {
    	matchScore ++;
    };

    // if the score is higher than 0, add the post to the results
    if (matchScore > 0) {
    	results.push(article);
    }
{% endhighlight %}
    

## Pros and cons

I barely finished implementing that on . The first version didn't use tags, as Asteroid didn't have those, but that made the whole thing mostly useless, since your search had to match a title to return something.

That's probably the main drawback compared to the Google solution: my index file contains only titles and _manually defined_ tags, whereas Google's engines are able to pick up keywords in the content of a page on their own.

The big advantage is that I can have instant-updating search: once the JSON file is loaded, no request is needed, and everything is done locally.

I would have liked to not have to use tags on [Asteroid][2], but I think it's a decent compromise for a better-tailored search. And after all, nothing forces me to make them public.

***

## update

As I expected, I found some flaws in the search algorithm quite quickly. The main one was that, if multiple words were typed, they had to be in the exact same order as in a post's title for the search to return anything. Not optimal.

The new algorithm is a tad bit more complicated, but much more satisfactory (to me anyway):

* The searched string is broken down into an array of words.
* Each word in this array is compared against post titles and tags.
* If all the searched words have a score higher than zero, then the post is added to the results.

{% highlight js %}
    var titleLowerCase = article.title.toLowerCase();
    var totalScore = []; // create a score array for that post
    $.each(search, function(id, term){ // loop through each searched word
    	var singleScore = 0; // initiate that word's score
    	if (article.tags) {
    		$.each(article.tags, function(id, tag) {
    			if (tag.toLowerCase().indexOf(term) !== -1) {
    				singleScore ++;
    			}
    		});
    	}
    	if (titleLowerCase.indexOf(term) !== -1) {
    		singleScore ++;
    	}
    	totalScore.push(singleScore); // the searched word's score is added to the array
    });

    if (totalScore.indexOf(0) == -1) {
    	results.push(article); // if all searched words have a score better than 0, add the article
    }
{% endhighlight %}

So now, for example, a search for "commercial space" returns all the posts tagged "commercial" and "space", or that contain "space" in their title.


[^1]: I am trying to build a good 404 page for the blog, and I think it's important that a 404 doesn't just tell the user he's in the wrong place: if there's just a typo in the URL, there's a great chance a search will give him the page he was looking for.

[1]: https://www.google.fr/search?client=safari&rls=en&q=site:cesarparent.com&20mars
[2]: http://github.com/cesarparent/Asteroid