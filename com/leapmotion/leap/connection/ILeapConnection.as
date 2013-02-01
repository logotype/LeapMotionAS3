package com.leapmotion.leap.connection
{
    import com.leapmotion.leap.Frame;

    public interface ILeapConnection
    {
        function get isConnected():Boolean;
        function get frame():Frame;
    }
}
