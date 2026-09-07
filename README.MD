# Game for CSCI 4140, Homework 2

This homework assignment had us follow a [GDQuest tutorial video](https://www.youtube.com/watch?v=GwCiGixlqiU) about how to make a simple vampire survivors style top down shooter game.

## Changes:

### Make weapon fire by player input instead of auto-aim/shoot  

I implemented this across 1 scene, 1 script, and added an input binding in the project settings. The gun scene had to be changed by changing the script on the gun node, where I added a variable for the timer reference so that I could control when to start and stop it based on input. And, in the _process function, I had to poll for input against the new "Shoot" binding. When that was held down by the player I started the timer to flag when the weapon was ready for firing, or if it was ready the `fire()` method would be called.

### Increase weapon fire rate while standing still  

This was implemented mostly in the `hero` script. I added two variables for the different fire rates, and set the gun's fire rate based on whether or not the hero was moving. In the `gun` script, I implemented the firerate variable and whenever the timer was started after calling the `fire()` method, it was passed in the firerate variable as a parameter to set the timer's length to whatever the firerate was currently set to on the gun.

### Add gameplay music loop  

This took me the longest, since I had to make a little looping music track for it. I was able to use an audio synthesis tool called beepbox to create the music track, and then export it as a .wav file. Then, in Godot, I imported the audio track and set the 'loop mode' import setting to 'Forward' which causes it to loop indefinitely when played. In the 'Game' scene I added a new `AudioStramPlayer` node and set it to autoplay my music .wav file on load.

## Credit:

* [GDQuest tutorial video](https://www.youtube.com/watch?v=GwCiGixlqiU)  
* Asset pack, including visuals for all characters and trees and slime death effect -
[GDQuest Tutorial Assets](https://www.gdquest.com/library/first_2d_game_godot4_vampire_survivor/)  
* Music created with [beepbox](https://www.beepbox.co/#9n31s7k0l00e07t2ca7g0fj07r1i0o433T5v1u24f0q0w10n5d03HTZIzrih9004000h0E1b7T0v4u58f0q0x10ob1d03w5h1E1b7T7v5u41f0q011d08H_RJSIrsAArrrrrh0IaE0T2v1u15f10w4qw02d03w0E0b4ich8M00001it18Q0000014h000000004h400000000p22AIOUAyBcLhjBkkVhjBkqdcyUybmbmbOb5ekkVl5ekbgbBkkVgI0bBSbC2S2RyYyNjB5elhjB5elgKmbkbobASbC2RyQywKrnVjFlllllllAkkBllllllm3XBllllllmZbRlllllllPtfVyaGGREFaGH1tOGGManGGE000)  
