---
title: Automating Rocket Launches
date: 2016-12-15 15:33:00
layout: post
excerpt_separator: <!--more-->
---

A few months ago, I published [a video][1] of a completely automatic launch to
orbit in KSP. I've gotten a few questions about it in the comments, so I'll try
to answer them here in bulk.

## Basic Tech

The software runs on [kOS][2], a KSP plugin and scripting language that gives
you access to the spaceship and most of the KSP world. My KSP save runs at twice
the scale of the stock game, making it a bit more expensive to get to orbit,
but makes single-burn to orbit launches closer to real-life launches.

A launch is made of five main phases.

<!--more-->

 1. Liftoff and vertical ascent: the rocket holds a purely vertical altitude,
    to gain some vertical speed and clear the launch pad.
 
 2. Pitch & Roll programme: the rocket rolls towards the launch azimuth that
    matches the target orbit's inclination, and pitches down to a set angle
    over a set duration. The angle and duration are given as parameters, and
    depend a lot on the rocket's Thrust/Weight ratio and the orbit insertion
    altitude.
    
 3. Zero-alpha boost phase: the rocket follows its velocity vector to keep the
    angle of attack close to 0° and avoid instabilities. This lasts until the
    first stages depletes its fuel. Depending on the profile, the acceleration
    can be limited by throttling towards the burn's end.

 4. Staging: stage separation is commanded, followed by a few seconds of RCS
    firing to push the second stage away. The second stage then ignites its
    engine and waits to be out of the tick layers of the atmosphere to get rid
    of the payload fairing if there is one.

 5. Closed-loop guidance kicks in. I implemented a version of the [Powered
    Explicit Guidance][3] algorithm, which was developed for the Space Shuttle.
    The algorithm tries to solve for a pitch, a pitch rate and a burn time based
    on the current state vector (velocity and location) to achieve the target
    orbit (defined by a target velocity and location).

## FAQ

> How do you figure out what time each event occurs, and especially, how do
> you calculate the pitch timetable?

The timing of the launch is a mix of controlled and automatic events. The
pitch programme's start time, angle and duration are variables set by me before
the launch. Other events (throttle reduction around Mach 1, staging, SECO) are
triggered automatically by the autopilot on certain conditions like fuel
depletion, velocity or on reaching the target orbit.

The pitch programme is very simple: I give the programme the start and end time
as well as the pitch angle, and the autopilot commands the pitch to move from 0°
to the target angle over the duration of the programme. Finding the angle, start
time and duration is trickier, and so far I've always started with a programme
pitching by 12° from ~T+20s to ~T+50s. From there, the only method I have is
trial and error. As a rule of thumb, a vehicle with more power or going to a
lower orbit will start the pitch kick earlier, and pitch harder (my Atlas V
look-alike with four solid boosters pitches by 28° from T+4s to T+30s on
launches to 130km*130km orbits).

A good sign that I've found a good pitch programme is when the second stage
corrects very little its attitude when closed-loop guidance kicks in. In the
future, I want to write a simulation tool that runs multiple iterations to try
and find the optimum pitch programme (probably by minimising propellant use in
the upper stage).

> Can this take a rocket to an arbitrary orbit at any inclination?

It can, with a few constraints. The obvious one is that you can't reach an
inclination lower than the launch site's latitude, but it shouldn't be an
issue in stock KSP since the space centre is located spot on the equator.

Inclination targeting is pretty tricky. The first version of the code would
just compute a launch azimuth from the target inclination and just go with the
velocity vector after the pitch and roll programme. The current version uses
a modified version of [BriarAndRye's][4] instantaneous azimuth calculations:
the function returns the heading to burn at to reach the exact inclination by
the time the upper stage reaches orbit insertion.

As far as orbit altitude is concerned, it depends a lot on the rocket, how
much fuel the upper stage carries, and the upper stage's thrust/weight ratio.
as in real life, most launches target a low periapsis and an apoapsis close to
the target orbit's. If needed, the upper stage can finalise the orbit with a
second burn, or let the spacecraft handle it.

> Could you share your code?

You can [download the three files][5] (PEG & Launch library, inclination control
and an example rocket script). It's ugly and full of global variables (I should
really do something about that) but it works. And seeing your upper stage guide
itself pulling the same moves at Atlas V's Centaur is pretty cool.


 [1]: https://www.youtube.com/watch?v=hIuU0ZMOCVY
 [2]: https://ksp-kos.github.io/KOS/
 [3]: http://www.orbiterwiki.org/wiki/Powered_Explicit_Guidance
 [4]: https://www.reddit.com/r/Kos/comments/3a5hjq/instantaneous_azimuth_function/
 [5]: /static/files/gnc-lib.zip