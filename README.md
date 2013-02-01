[LeapMotionAS3](http://github.com/logotype/LeapMotionAS3)
=================

<img src="http://logotype.se/leapImage.png">

This is the AS3 framework for working with the Leap.

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

What you'll get from the `LEAPMOTION_FRAME` handler is a `Frame` object, with strongly
typed properties such as `Hands`, `Pointables`, `Direction` and more:

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

Features
--------

<img src="http://logotype.se/leapImageTelemetry.png">
+ High performance, less than 1ms processing per frame (typically 2% CPU usage on a recent MacBook Pro)
+ Same structure as official API
+ Clean, lightweight and documented code
+ No external dependencies, creates a optimized socket directly to the Leap
+ Uses ASC 2.0 compiler features (be sure to add the `-inline` and `-swf-version=19` compiler arguments)
+ Connect multiple computers to the same Leap device (via an optional "host" argument)
+ Works great with [Starling](https://github.com/PrimaryFeather/Starling-Framework) and [Away3D](https://github.com/away3d/away3d-core-fp11)
+ Compatible with Mac and PC

Upcoming features
-----------------

+ Multi-threading using Workers
+ Optional dispatch model using Signals
+ Interpolation for even smoother performance
+ AIR Native Extension (ANE) which directly interfaces with the C++ library
+ Additional example code will be added

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
