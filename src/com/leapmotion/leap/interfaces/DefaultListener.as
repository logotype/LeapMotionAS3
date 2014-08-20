package com.leapmotion.leap.interfaces
{
import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.events.LeapEvent;
import com.leapmotion.leap.Listener;

public class DefaultListener implements Listener
{

    public function DefaultListener()
    {
    }

    public function onInit( controller:Controller ):void
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_INIT ) );
    }

    public function onConnect( controller:Controller ):void
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_CONNECTED ) );
    }

    public function onDisconnect( controller:Controller ):void
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_DISCONNECTED ) );
    }

    public function onExit( controller:Controller ):void
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_EXIT ) );
    }

    public function onFrame( controller:Controller, frame:Frame ):void
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_FRAME, frame ) );
    }

    public function onFocusGained( controller:Controller ):void
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_FOCUSGAINED ) );
    }

    public function onFocusLost( controller:Controller ):void
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_FOCUSLOST ) );
    }

    public function onServiceConnect( controller:Controller ):void
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_FOCUSLOST ) );
    }

    public function onServiceDisconnect( controller:Controller ):void
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_FOCUSLOST ) );
    }

    public function onDeviceChange( controller:Controller ):void
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_FOCUSLOST ) );
    }
}
}
