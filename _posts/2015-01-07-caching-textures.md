---
date: 2015-01-07 21:00:00
tags: gamedev, engine, tools
redirect_from: /post/caching-textures/
layout: post
title: SDL and Caching
published: false
---

While I've not kept working on my [game-a-month project](http://amyparent.com/2014/04/one-game-a-month/), it has made me want to dive a bit deeper in Games Developement. Since I don't really want to re-write all the basics everytime I start a new project, I decided to write my own small engine, PixelKit.

[SDL](https://www.libsdl.org), the library I use to draw on the screen, loads images as `SDL_Surfaces`, but the most efficient way to draw to one on the screen is to convert it to a [gpu-stored `SDL_Texture`](http://stackoverflow.com/questions/21392755/difference-between-surface-and-texture-sdl-general), which can be done easily. Once this is done, the temporary surface can be deleted from memory.



{% highlight cpp %}
    // load the image
    SDL_Surface* tempSurface = IMG_Load("assets/image.png");
    if(tempSurface == nullptr)
    {
    	// error handling
    }
    // convert the surface to a hardware texture
    SDL_Texture* finalTexture = SDL_CreateTextureFromSurface(currentRenderer,
    			                                             tempSurface);
    // Delete the surface from memory
{% endhighlight %}

To avoid loading a same image multiple times —say, for example, I wanted to make a tileset— I wrote a resource cache: If I request an image that has already been loaded, it's already stored in memory and can be used right away.

Caching surfaces seems quite useless: it would still require a conversion to texture each time a node is created from an image, and there would be, in the end, multiple similar textures in memory. A test programme with 100 nodes using the same image takes about twenty megs of RAM, compared to a hundred megs with 1,000 nodes. With 10,000 and the conversion process takes too long for the programme to start in a reasonable amount of time.

The solution, which was my first idea when I wrote the cache, is to store textures instead. That way, each node stores a pointer to a shared texture instead of a pointer to its own. There's a downside, though: Some functions need to change the actual texture data to change the way it is displayed. Changing the alpha value on a node will change it for every other node using the same texture. Not quite what's needed.

I'm still trying to think of a way to solve that. The solution I'm leaning towards is store the alpha value in the Node class and have each node change its texture's alpha just before doing the draw call. This adds some processing, but the SDL source code shows it's just changing the value of a `SDL_Texture` struct member, so it might be worth it. Chances are, there won't be so many alpha changes that it would become an issue anyway.