---
image: /static/media/2019/03/mars-traj.png
redirect_from: /post/crew-dragon-reentry/
---
Simulating Spacecraft Reentry
=============================

After years of development, the first Crew Dragon [reached the International Space Station][verge-dragon-docking] on Sunday (this spacecraft is gorgeous!) and is [coming back][verge-dragon-entry] to land tomorrow, off the coast of Florida. Discussing the reentry on twitter with a couple of folks yesterday, I came across an interesting question: do we know how long before splashdown Dragon will fly over which parts of the world?

If you work at SpaceX or NASA, the answer is (I hope) yes. Since I don't work for either, I spent the evening trying to program a (simplistic) reentry simulation to find out for myself. I'd done that years ago but the physics and code were pretty appalling, so I started from scratch.

![Crew Dragon Reentry Trajectory][i-dragon-traj]{: .small}



Reentry is a relatively simple problem to solve as long as you don't look at the details. There are either two or three forces acting on the spacecraft: gravity, aerodynamic drag, and in the case of Dragon -- or really most modern spacecrafts since the introduction of Soyuz -- lift. There are [simplified equations][atmo-drag] for all of these, which I used to derive equations of motion, coded into a quick-and-dirty Euler solver.

There are _major_ issues with this, obviously. Aerodynamic parameters for a spacecraft are both complex -- you go from hypersonic flight in plasma to subsonic flight under parachutes -- and not exactly published in great details. The lift and drag equations I use are also not all that good in very-low-density gases, which is where spacecrafts spend a good chunk of their reentries.

![Crew Dragon g-load vs time][i-dragon-load]{: .right}

Still, I came up with some trajectories and g-loads that look pretty close to what you'd expect. Lifting reentries to low earth orbit are usually between 3G and 5G (Trevino 2008), which we have here. We can see an upwards bend in the trajectory when lift starts to be significant, and it takes the capsule about 8 minutes to go from Entry Interface to parachute deployment, which matches the [timeline obtained by NASASpaceFlight][nsf-timeline] nicely!

![Crew Dragon distance-to-go plot][i-dragon-dtg]{: .right}

I also made a plot that shows how far dragon will be from splashdown compared to the time left before it gets there. Bear in mind, the simulation stops when the parachute would open, so it's not very precise -- Dragon will probably drift due to winds -- and needs a couple of minutes added onto the timeline to get to the predicted splashdown time.

[i-dragon-traj]: /static/media/2019/03/dragon-traj.svg
[i-dragon-load]: /static/media/2019/03/dragon-load_time.svg
[i-dragon-dtg]: /static/media/2019/03/dragon-dtg.svg

[verge-dragon-docking]: https://www.theverge.com/2019/3/3/18244501/spacex-crew-dragon-automatic-docking-international-space-station-nasa
[verge-dragon-entry]: https://www.theverge.com/2019/3/7/18254549/spacex-crew-dragon-iss-nasa-landing-parachutes-splashdown
[atmo-drag]: https://en.wikipedia.org/wiki/Drag_equation
[nsf-timeline]: https://forum.nasaspaceflight.com/index.php?topic=47552.msg1918994#msg1918994

## What if we tried more spacecrafts?

![Mars Entries over time][i-mars-entries]{: .right}

Since I specialise in taking things too far, I tried to find aerodynamic data for more spacecrafts and planets. It turns out you can find a lot of information on NASA's Mars missions, so I tried to plot reentries for Pathfinder, Opportunity and Curiosity. The results are surprisingly okay! Not stellar, but also not too far off compared to a plot found in (Edquist et al. 2009), which is more than I expected given the small amount of time I spent working on this!

![Mars spacecrafts' velocity/altitude profiles][i-mars-vel]{: .left}

Curiosity's profile is probably the one that's further off, and it makes sense. Of those three missions, it's the only one that used body lift to control its entry. In my simulations, that lift is pointed up the whole time, whereas the real mission rolled around to steer and control the descent. As a bonus, I added the now-cancelled Red Dragon's entry, thought it's also probably way off. Had it happened, the plan for the mission was to point the lift downwards (!) to reach the thicker layers of the atmosphere, then modulate it to achieve level-ish flight and shed speed there, instead of skipping back up like it does in my sims.

![Mars spacecrafts' Entry trajectories][i-mars-traj]{: .small}

[i-mars-vel]: /static/media/2019/03/mars-vel.svg
[i-mars-traj]: /static/media/2019/03/mars-traj.svg
[i-mars-entries]: /static/media/2019/03/mars-entries.png

***

Realistically, these kind of simulations don't have a lot of value in terms of real-life applications -- you won't design a mission with one single dirty python script. But they're the kind of things I love spending some time doing once in a while, because they show that first principles are still a good way to get an idea of what a problem looks like. That, and saying that you can (sort of) simulate the next Crew Dragon reentry on your laptop gets you a bunch of cool points 🚶🏻‍♀️🚀

## Source Code

I coded all of this using Python 3, and Matplotlib for plotting. You can get the source from GitHub at [amyinorbit/reentry.py][source]. It's under the MIT license, so feel free to hack it and make changes to it! There's tonnes that could be done – adding more planets, using a more robust solver, etc.

[source]: https://github.com/amyinorbit/reentry.py

## Papers I read & used

1. Trevino, Loretta. [_SpaceX Dragon Re-Entry Vehicle: Aerodynamics and Aerothermodynamics with Application to Base Heat-Shield Design_][ref-1]. Georgia Institute of Technology, 2008.
2. Karcz, John, et al. [_Red dragon: Low-cost access to the surface of mars using commercial capabilities_][ref-2]. 2012.
3. Edquist, Karl, et al. [_Aerothermodynamic design of the Mars Science Laboratory heatshield_][ref-3]. 41st AIAA Thermophysics Conference. 2009.

[ref-1]: https://smartech.gatech.edu/bitstream/handle/1853/26437/107-277-1-PB.pdf?sequence=1&isAllowed=y
[ref-2]: https://ntrs.nasa.gov/search.jsp?R=20120013431
[ref-3]: https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/20090024230.pdf
