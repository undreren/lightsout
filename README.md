## Lights Out ##

A small puzzle game, implemented in Elm!

### Object of the game ###

To complete a level you must turn off all the lights, but that can be harder than it sounds. When you click a light, it turns on or off, depending on its current state. But so does its neighbors!

There are currently no levels, so all lights are turned on by default. Have fun!

[Try it out!](https://undreren.github.io/lightsout)

### TODO ###

In no particular order, these are the scheduled tasks:

- Make the time actually show the correct amount of time passed while playing.
- Msg NewGame should use the random seed on Game.Model, and generate a new seed.
- Add tailored levels.
- Make ports to save local state.
- Implement achievements!
- Add background music and sounds.
- Make the app pretty.