---
date: 2015-10-10 22:55:00
tags: gamedev, graphics
permalink: /blog/glitch-effect-without-shaders/
layout: post
title: Glitch Effects Without Shaders
---

![Glitch in Slow Motion](/static/media/2015/10/glitch-fullspeed.gif){: .right}

For [last weekend's game jam](/blog/double-jam-postmortem/), I needed to create a CRT-style glitch effect. The proper way to do this would be to use shaders — Unity, SpriteKit & all let you add custom shaders to game objects — but my engine does not (at the moment) support shaders, because the current version uses SDL to draw to the screen. I found a way around that may not look as good as it would have with shaders, but still works.

_The code examples in the article use Meteor's API (C++), but they are simple enough that they could be translated for SpriteKit, Cocos2D or other 2D engines with very little work._

<!--more-->

The idea is to mix a colour overlay with fast screen shake to give the illusion that pixels are being drawn off-colour and slightly offset from their correct position. Most engines that I know of allow you to blend a scene's texture with a colour, which is overlaid on the scene's content.

So let's set up a simple scene to work with. The `MyScene.hpp` interface is quite simple, only a few method declarations there:

{% highlight cpp %}
    #include <Meteor/Meteor.h>

    // Our scene
    class MyScene : public Meteor::Scene, public Meteor::ControlsDelegate {
    public:
        // The function called when the scene starts being shown.
        void didMoveToView() override;
        
        // The function called each frame.
        void update(double deltaTime) override;
    
        // Called when a key is pressed. We'll use that to trigger a glitch
        void keyDown(Meteor::Key aKey) override;
    
    private:
    
        // Used to count glitch frames.
        int     _glitchCounter;
    
        // The function that we'll call each frame to render the effect.
        void stepGlitch();
    };
{% endhighlight %}

The implementation in `MyScene.cpp` isn't that much more complicated: each frame when the scene is glitching, we'll change its position randomly and change its overlay a random colour from a list.

{% highlight cpp %}
    #include "MyScene.hpp"
    using namespace Meteor;
    
    // Colours to pick from when glitching
    const Color kGlitchColours[] = {
        Color(1.f, .7f, .7f),
        Color(.5f, 1.f, .5f),
    };
    
    // (1) Set up a basic scene and initialise the effect
    void MyScene::didMoveToView() {
        addChild(alloc<SpriteNode>("sprite_demo.png"));
        // reset the effect counter.
    }
    
    // (2) Effect logic.
    void MyScene::stepGlitch() {
        setPosition(1 - rand() % 3, 0);
        setXScale(1.f + float(rand() % 30) / 1000.f);
        setColor(kGlitchColours[rand() % 2]);
    
        if(--_glitchCounter <= 0) {
            setPosition(0, 0);
            setXScale(1);
            setColor(Color::clearColor);
        }
    }
    
    // (3) Trigger the effect when space is pressed
    void MyScene::keyDown(Key aKey) {
        if(aKey == Key::SPACE) {
            _glitchCounter = 5;
        }
    }
    
    // (4) Update the scene each frame
    void MyScene::update(double delta) {
        if(_glitchCounter > 0) {
            stepGlitch();
        }
    }
{% endhighlight %}

If we go through each function in the scene class:

1. We set up the scene. Nothing fancy here, we create a sprite from an image and add it to the scene
tree, so that we have some content to show. Once we've done that, we reset the effect's frame counter to `0` for safety.

2. `stepGlitch()` is where [the magic happens](https://www.youtube.com/watch?v=NVl8o85YGNE&t=15m09s): we give the scene a random horizontal position (here, capped between `-1` and `1`), a random horizontal scale to simulate tearing, and overlay a colour picked at random from a pre-made list — ours contains a light red and a light green.
    
    Once this is done, we decrement the frame counter, and if it reached `0`, put the scene back in its normal place and scale and remove the overlay. 

3. Here we listen for key presses. When the player presses the space bar, we set the effect's frame counter to a value greater than zero to start the effect. Five frames seems to work well: longer and the effects would bother the player, shorter and it might be missed.

4. Before each frame is rendered (when `update(double)` is called), we checked that the effect's frame counter is positive, and if yes we call `stepGlitch()` to render the effect.

Here's the result once again, slowed down to show what's going on a bit better:

![Glitch in Slow Motion](/static/media/2015/10/glitch-slowmo.gif){: .small}

In a real game, you would probably trigger the glitch some other way than by user input: random time interval, when the player dies — whatever suits your game. The result is not perfect, but it's good enough to give the illusion that the game is glitchy. And now I'll get back to learning OpenGL so I can avoid dirty hacks like this one.