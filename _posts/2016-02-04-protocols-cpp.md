---
date: 2016-02-04 10:00:00
tags: programming, gamedev, c++
permalink: /post/protocols-cpp/
layout: post
title: Protocol-Oriented C++ & Data Locality
---

I discovered what Apple calls _Protocol Oriented_ programming last summer, thanks to [one of the WWDC videos](https://developer.apple.com/videos/play/wwdc2015-408/) (great presentation). The whole thing is clearly aimed at Swift, but some of it can be applied to C++: it doesn’t have protocols but it does multiple inheritance and abstract classes, which is pretty close.

{% highlight swift %}
    protocol Component {
        func Start();
        func Update(delta: Float);
    }

    struct Transform : Component {
        func Start() { ... }
        func Update(delta: Float) { ... }
    }
{% endhighlight %}

This bit of Swift could be translated to that chunk of C++:

{% highlight cpp %}
    struct Component {
        virtual ~Component() {}
        virtual void Start() = 0;
        virtual void Update(float delta) = 0;
    };

    struct Transform : public Component {
        virtual void Start() { ... }
        virtual void Update(float delta) { ... }
    };
{% endhighlight %}

Now, if I want to store objects that implement `Component` in a collection, I need to use pointers — the standard library containers cannot handle arrays of abstract value types:

{% highlight cpp %}
    struct GameObject {
    
        typename<typename Type>
        shared_ptr<Type> AddComponent() {
            _components.push_back(make_shared<Type>())
        }
    
    private:
        vector<shared_ptr<Component>> _components;
    };

    GameObject go;
    go.AddComponent<Transform>(); // Returns a pointer to a Transform object.
{% endhighlight %}

That works, but it's indirection hell: if I try to iterate over each component in a `GameObject` and call, for example, `Component::Update()`, the processor is going to spend a good chunk of its time just [waiting for components](http://gameprogrammingpatterns.com/data-locality.html) to arrive from memory.

The whole reason why I want to switch to an Entity-Component system for my engine is to avoid having deep inheritance tree and pointers everywhere, so I need to find a way around that. I'm thinking object pools at the moment, but I'm open to other ideas.