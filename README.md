LeapMotionAS3
=================

This is the AS3 framework for working with the Leap.

Leap Motion is a motion-control software and hardware company developing the world's most powerful and sensitive 3D motion-control and motion-sensing technology.

[leapmotion.com](http://www.leapmotion.com)

Demos
-----------

[<img src="http://logotype.se/leapmotion/victor1.png">](http://www.youtube.com/watch?v=y9SDf5GSDF8) [<img src="http://logotype.se/leapmotion/victor2.png">](http://www.youtube.com/watch?v=Hduiif_GfsU) [<img src="http://www.aboutme.be/images/labyrinth.png">](https://vimeo.com/60170459)


Quick start
-----------

Clone the repo, `git clone git://github.com/logotype/LeapMotionAS3.git`.

Create an instance of the LeapMotion class:

    leap = new LeapMotion();
    leap.controller.addEventListener( LeapEvent.LEAPMOTION_INIT, onInit );
    leap.controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, onConnect );
    leap.controller.addEventListener( LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect );
    leap.controller.addEventListener( LeapEvent.LEAPMOTION_EXIT, onExit );
    leap.controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );

What you'll get from the `LEAPMOTION_FRAME` handler is a `Frame` instance, with strongly
typed properties such as `Hands`, `Pointables`, `Direction`, `Gestures` and more:

    private function onFrame( event:LeapEvent ):void
    {
        // Get the most recent frame and report some basic information
    	var frame:Frame = event.frame;
    	trace( "Frame id: " + frame.id + ", timestamp: " + frame.timestamp + ", hands: " + frame.hands.length + ", fingers: " + frame.fingers.length + ", tools: " + frame.tools.length );
    
    	if ( frame.hands.length > 0 )
    	{
    		// Get the first hand
    		var hand:Hand = frame.hands[ 0 ];
    
    		// Check if the hand has any fingers
    		var fingers:Vector.<Finger> = hand.fingers;
    		if ( fingers.length > 0 )
    		{
    			// Calculate the hand's average finger tip position
    			var avgPos:Vector3 = Vector3.zero();
    			for each ( var finger:Finger in fingers )
    				avgPos = avgPos.plus( finger.tipPosition );
    
    			avgPos = avgPos.divide( fingers.length );
    			trace( "Hand has " + fingers.length + " fingers, average finger tip position: " + avgPos );
    		}
    
    		// Get the hand's sphere radius and palm position
    		trace( "Hand sphere radius: " + hand.sphereRadius + " mm, palm position: " + hand.palmPosition );
    
    		// Get the hand's normal vector and direction
    		var normal:Vector3 = hand.palmNormal;
    		var direction:Vector3 = hand.direction;
    
    		// Calculate the hand's pitch, roll, and yaw angles
    		trace( "Hand pitch: " + LeapMath.toDegrees( direction.pitch ) + " degrees, " + "roll: " + LeapMath.toDegrees( normal.roll ) + " degrees, " + "yaw: " + LeapMath.toDegrees( direction.yaw ) + " degrees\n" );
    	}
    }

Optionally, you can simply call `leap.frame()` at any time, e.g. in your main loop.

Features
--------

<img src="http://logotype.se/leapImageTelemetry.png">
+ High performance, less than 1ms processing per frame (typically 2% CPU usage on a recent MacBook Pro)
+ Same structure as official API
+ Gestures (Circle, Key Tap, Screen Tap, Swipe)
+ Works great with [Starling](https://github.com/PrimaryFeather/Starling-Framework) and [Away3D](https://github.com/away3d/away3d-core-fp11)
+ Connect multiple computers to the same Leap device (via an optional "host" argument)
+ Clean, lightweight and documented code
+ Uses ASC 2.0 compiler features (be sure to add the `-inline` and `-swf-version=19` compiler arguments)
+ No external dependencies, creates a optimized socket directly to the Leap
+ AIR Native Extension (ANE) which directly interfaces with the C++ library (Mac, PC)
+ Compatible with Mac OSX, Windows, iOS (iPad/iPhone/etc), Android

AIR Native Extension
--------------------

You can use this library on both web and AIR projects. If you are using it on an AIR for Desktop project, you can take advantage of the AIR Native Extension.

[Download the ane-file](https://github.com/logotype/LeapMotionAS3/blob/master/bin/LeapMotionAS3.ane?raw=true) and place it somewhere in your project (preferably in the directory where you would put your swc files). Link the ane file to your project:

####Flash Builder 4.6/4.7


1. Right click on your AIR for desktop project and choose properties.
2. Select Actionscript build path > Library path and click on Add SWC… Select the ane file you just downloaded.
3. In that same window, choose Native Extensions and click on Add ANE… Select that same ane file.
4. Select Actionscript Build Packaging > Native extensions. Check the checkbox next to the native extension. Ignore the warning that says the extension isn't used.

####Flash CS6


1. Select File > Actionscript settings.
2. On the Library Path tab, click on the "Browse to a Native Extension (ANE)" button (button to the right of the SWC button).
3. Choose the ane file you just downloaded.

####IntelliJ IDEA


1. Right-click on your module and choose "Open Module Settings".
2. Select the build configuration for your Module and open the Dependencies tab.
3. Click on the plus (+) button on the bottom of that window and choose "New Library…".
4. Choose the ane file you just downloaded.

###Using the ANE on Windows

If you are using the ANE on Windows, you need to add the Leap Motion program folder to your PATH.

1. From the Desktop, right-click My Computer and click Properties.
2. Click Advanced System Settings link in the left column.
3. In the System Properties window click the Environment Variables button.
4. In the Environment Variables window, highlight the Path variable in the Systems Variable section and click the Edit button.
5. Add the Leap Motion folder from your program files at the end of that line (ex: C:\Program Files (x86)\Leap Motion\Leap).


Authors
-------

**Victor Norgren**

+ http://twitter.com/logotype
+ http://github.com/logotype
+ http://logotype.se

**Wouter Verweirder**

+ http://twitter.com/wouter
+ http://github.com/wouterverweirder
+ http://blog.aboutme.be


Copyright and license
---------------------

Copyright © 2013 logotype

Author: Victor Norgren

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:  The above copyright
notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE. 
