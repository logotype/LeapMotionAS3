package com.leapmotion.leap
{
import com.leapmotion.leap.interfaces.DefaultListener;
import com.leapmotion.leap.interfaces.ILeapConnection;
import com.leapmotion.leap.namespaces.leapmotion;
import com.leapmotion.leap.native.LeapNative;
import com.leapmotion.leap.socket.LeapSocket;

import flash.events.EventDispatcher;

/**
 * Called once, when the Controller is initialized.
 */
[Event( name = "leapmotionInit", type = "com.leapmotion.leap.events.LeapEvent" )]

/**
 * Called when the Controller object connects to the Leap Motion software.
 */
[Event( name = "leapmotionConnected", type = "com.leapmotion.leap.events.LeapEvent" )]

/**
 * Called when the Controller object disconnects from the Leap Motion software.
 */
[Event( name = "leapmotionDisconnected", type = "com.leapmotion.leap.events.LeapEvent" )]

/**
 * Called when a timeout occurs from the socket connection.
 */
[Event( name = "leapmotionTimeout", type = "com.leapmotion.leap.events.LeapEvent" )]

/**
 * Called when this Controller instance is destroyed.
 */
[Event( name = "leapmotionExit", type = "com.leapmotion.leap.events.LeapEvent" )]

/**
 * Called when a new frame of hand and finger tracking data is available.
 */
[Event( name = "leapmotionFrame", type = "com.leapmotion.leap.events.LeapEvent" )]

/**
 * The Controller class is your main interface to the Leap Motion Controller.
 *
 * <p>Create an instance of this Controller class to access frames of tracking
 * data and configuration information. Frame data can be polled at any time using
 * the <code>Controller::frame()</code> function. Call <code>frame()</code> or <code>frame(0)</code>
 * to get the most recent frame. Set the history parameter to a positive integer
 * to access previous frames. A controller stores up to 60 frames in its frame history.</p>
 *
 * <p>Polling is an appropriate strategy for applications which already have an
 * intrinsic update loop, such as a game. You can also implement the Leap::Listener
 * interface to handle events as they occur. The Leap Motion dispatches events to the listener
 * upon initialization and exiting, on connection changes, and when a new frame
 * of tracking data is available. When these events occur, the controller object
 * invokes the appropriate callback function defined in the Listener interface.</p>
 *
 * <p>To access frames of tracking data as they become available:</p>
 *
 * <ul>
 * <li>Implement the Listener interface and override the <code>Listener::onFrame()</code> function.</li>
 * <li>In your <code>Listener::onFrame()</code> function, call the <code>Controller::frame()</code> function to access the newest frame of tracking data.</li>
 * <li>To start receiving frames, create a Controller object and add event listeners to the <code>Controller::addEventListener()</code> function.</li>
 * </ul>
 *
 * <p>When an instance of a Controller object has been initialized,
 * it calls the <code>Listener::onInit()</code> function when the listener is ready for use.
 * When a connection is established between the controller and the Leap,
 * the controller calls the <code>Listener::onConnect()</code> function. At this point,
 * your application will start receiving frames of data. The controller calls
 * the <code>Listener::onFrame()</code> function each time a new frame is available.
 * If the controller loses its connection with the Leap Motion software or
 * device for any reason, it calls the <code>Listener::onDisconnect()</code> function.
 * If the listener is removed from the controller or the controller is destroyed,
 * it calls the <code>Listener::onExit()</code> function. At that point, unless the listener
 * is added to another controller again, it will no longer receive frames of tracking data.</p>
 *
 * @author logotype
 *
 */
public class Controller extends EventDispatcher
{
    /**
     * The default policy.
     *
     * <p>Currently, the only supported policy is the background frames policy,
     * which determines whether your application receives frames of tracking
     * data when it is not the focused, foreground application.</p>
     */
    static public const POLICY_DEFAULT:uint = 0;

    /**
     * Receive background frames.
     */
    static public const POLICY_BACKGROUND_FRAMES:uint = ( 1 << 0 );

    /**
     * Receive raw images.
     */
    static public const POLICY_IMAGES:uint = ( 1 << 1 );

    /**
     * Optimize for top-down tracking/VR mount.
     */
    static public const POLICY_OPTIMIZE_HMD:uint = ( 1 << 2 );

    /**
     * @private
     * The Listener subclass instance.
     */
    leapmotion var listener:Listener;

    /**
     * @private
     * Current connection, either native or socket.
     */
    public var connection:ILeapConnection;

    /**
     * @private
     * History of frame of tracking data from the Leap Motion.
     */
    public var frameHistory:Vector.<Frame> = new Vector.<Frame>();

    /**
     * @private
     * Native Extension context object.
     *
     */
    public var context:Object;

    /**
     * Constructs a Controller object.
     * @param host IP or hostname of the computer running the Leap Motion software.
     * (currently only supported for socket connections).
     *
     */
    public function Controller( host:String = null, port:int = 6437 )
    {
        leapmotion::listener = new DefaultListener();

        if( !host && LeapNative.isSupported() )
        {
            connection = new LeapNative( this );
        }
        else
        {
            connection = new LeapSocket( this, host, port );
        }
    }

    /**
     * Returns a frame of tracking data from the Leap Motion.
     *
     * <p>Use the optional history parameter to specify which frame to retrieve.
     * Call <code>frame()</code> or <code>frame(0)</code> to access the most recent frame;
     * call <code>frame(1)</code> to access the previous frame, and so on. If you use a history value
     * greater than the number of stored frames, then the controller returns
     * an invalid frame.</p>
     *
     * @param history The age of the frame to return, counting backwards from
     * the most recent frame (0) into the past and up to the maximum age (59).
     *
     * @return The specified frame; or, if no history parameter is specified,
     * the newest frame. If a frame is not available at the specified
     * history position, an invalid Frame is returned.
     *
     */
    final public function frame( history:int = 0 ):Frame
    {
        if( history >= frameHistory.length )
            return Frame.invalid();
        else if( history == 0 )
            return connection.frame;
        else
            return frameHistory[ history ];
    }

    /**
     * Update the object that receives direct updates from the Leap Motion Controller.
     *
     * <p>The default listener will make the controller dispatch flash events.
     * You can override this behaviour, by implementing the IListener interface
     * in your own classes, and use this method to set the listener to your
     * own implementation.</p>
     *
     * @param listener
     */
    public function setListener( listener:Listener ):void
    {
        this.leapmotion::listener = listener;
    }

    /**
     * The list of currently attached and recognized Leap Motion controller devices.
     *
     * <p>The Device objects in the list describe information such as the range and tracking volume.</p>
     *
     * <p>Currently, the Leap Motion Controller only recognizes a single device at a time.</p>
     *
     * @return A list of Device objects.
     *
     */
    public function devices():Vector.<Device>
    {
        var deviceList:Vector.<Device> = new Vector.<Device>();
        deviceList.push( new Device( this ) );
        return deviceList;
    }

    /**
     * Enables or disables reporting of a specified gesture type.
     *
     * <p>By default, all gesture types are disabled. When disabled, gestures of
     * the disabled type are never reported and will not appear in the frame
     * gesture list.</p>
     *
     * <p>As a performance optimization, only enable recognition for the types
     * of movements that you use in your application.</p>
     *
     * @param type The type of gesture to enable or disable. Must be a member of the Gesture::Type enumeration.
     * @param enable True, to enable the specified gesture type; False, to disable.
     *
     */
    public function enableGesture( type:int, enable:Boolean = true ):void
    {
        connection.enableGesture( type, enable );
    }

    /**
     * Reports whether the specified gesture type is enabled.
     *
     * @param type The Gesture.TYPE parameter.
     * @return True, if the specified type is enabled; false, otherwise.
     *
     */
    public function isGestureEnabled( type:int ):Boolean
    {
        return connection.isGestureEnabled( type );
    }

    /**
     * Gets the active policy settings.
     *
     * <p>Use this function to determine the current policy state.
     * Keep in mind that setting a policy flag is asynchronous, so changes are
     * not effective immediately after calling <code>setPolicyFlag()</code>. In addition, a
     * policy request can be declined by the user. You should always set the
     * policy flags required by your application at startup and check that the
     * policy change request was successful after an appropriate interval.</p>
     *
     * <p>If the controller object is not connected to the Leap, then the default
     * policy state is returned.</p>
     *
     * @returns The current policy flags.
     */
    public function policyFlags():uint
    {
        return connection.policyFlags();
    }

    /**
     * Requests a change in policy.
     *
     * <p>A request to change a policy is subject to user approval and a policy
     * can be changed by the user at any time (using the Leap Motion settings window).
     * The desired policy flags must be set every time an application runs.</p>
     *
     * <p>Policy changes are completed asynchronously and, because they are subject
     * to user approval, may not complete successfully. Call
     * <code>Controller.policyFlags()</code> after a suitable interval to test whether
     * the change was accepted.</p>
     *
     * <p>Currently, the background frames policy is the only policy supported.
     * The background frames policy determines whether an application
     * receives frames of tracking data while in the background. By
     * default, the Leap Motion only sends tracking data to the foreground application.
     * Only applications that need this ability should request the background
     * frames policy.</p>
     *
     * <p>At this time, you can use the Leap Motion applications Settings window to
     * globally enable or disable the background frames policy. However,
     * each application that needs tracking data while in the background
     * must also set the policy flag using this function.</p>
     *
     * <p>This function can be called before the Controller object is connected,
     * but the request will be sent to the Leap Motion after the Controller connects.</p>
     *
     * @param flags A PolicyFlag value indicating the policies to request.
     */
    public function setPolicyFlags( flags:uint ):void
    {
        connection.setPolicyFlags( flags );
    }

    /**
     * Reports whether this Controller is connected to the Leap Motion Controller.
     *
     * <p>When you first create a Controller object, <code>isConnected()</code> returns false.
     * After the controller finishes initializing and connects to
     * the Leap, <code>isConnected()</code> will return true.</p>
     *
     * <p>You can either handle the onConnect event using a event listener
     * or poll the <code>isConnected()</code> function if you need to wait for your
     * application to be connected to the Leap Motion before performing
     * some other operation.</p>
     *
     * @return True, if connected; false otherwise.
     *
     */
    public function isConnected():Boolean
    {
        return connection.isConnected;
    }

    /**
     * Reports whether your application has a connection to the Leap Motion
     * daemon/service. Can be true even if the Leap Motion hardware is not available.
     * @return
     *
     */
    public function isServiceConnected():Boolean
    {
        return connection.isServiceConnected;
    }

    /**
     * Returns a Config object, which you can use to query the
     * Leap Motion system for configuration information.
     *
     * @return
     *
     */
    public function config():Config
    {
        return new Config( this );
    }

    /**
     * Reports whether this application is the focused, foreground application.
     *
     * <p>Only the foreground application receives tracking information from
     * the Leap Motion Controller.</p>
     * @return
     *
     */
    public function hasFocus():Boolean
    {
        return context.call( "hasFocus" );
    }
}
}
