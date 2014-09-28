package com.leapmotion.leap
{
/**
 * The Arm class represents the forearm.
 *
 */
public class Arm
{
    /**
     * The estimated length of the arm in millimeters.
     *
     * @returns The length of the arm in millimeters.
     * @since 2.0
     */
    public var length:Number;

    /**
     * The average width of the arm.
     *
     * @returns The width of the arm in millimeters.
     * @since 2.0.3
     */
    public var width:Number;

    /**
     * The normalized direction in which the arm is pointing (from elbow to wrist).
     * @since 2.0.3
     */
    public var direction:Vector3;

    /**
     * The position of the elbow.
     *
     * <p>If not in view, the elbow position is estimated based on typical human
     * anatomical proportions.</p>
     *
     * @since 2.0.3
     */
    public var elbowPosition:Vector3;

    /**
     * The position of the wrist.
     *
     * <p>Note that the wrist position is not colocated with the end of any bone in
     * the hand. There is a gap of a few centemeters since the carpal bones are
     * not included in the skeleton model.</p>
     *
     * @since 2.0.3
     */
    public var wristPosition:Vector3;

    /**
     * The orthonormal basis vectors for the Arm bone as a Matrix.
     *
     * <p>Basis vectors specify the orientation of a bone.</p>
     *
     * <p>* xBasis. Perpendicular to the longitudinal axis of the
     *   bone; exits the arm laterally through the sides of the wrist.</p>
     * <p>* yBasis or up vector. Perpendicular to the longitudinal
     *   axis of the bone; exits the top and bottom of the arm. More positive
     *   in the upward direction.</p>
     * <p>* zBasis. Aligned with the longitudinal axis of the arm bone.
     *   More positive toward the wrist.</p>
     *
     * <p>The bases provided for the right arm use the right-hand rule; those for
     * the left arm use the left-hand rule. Thus, the positive direction of the
     * x-basis is to the right for the right arm and to the left for the left
     * arm. You can change from right-hand to left-hand rule by multiplying the
     * basis vectors by -1.</p>
     *
     * <p>Note that converting the basis vectors directly into a quaternion
     * representation is not mathematically valid. If you use quaternions,
     * create them from the derived rotation matrix not directly from the bases.</p>
     *
     * @returns The basis of the arm bone as a matrix.
     * @since 2.0.3
     */
    public var basis:Matrix;

    /**
     * Constructs an invalid Arm object.
     *
     * <p>Get valid Arm objects from a Finger object.</p>
     */
    public function Arm()
    {
    }

    /**
     * Reports whether this is a valid Arm object.
     *
     * @returns True, if this Arm object contains valid tracking data.
     * @since 2.0.3
     */
    public function isValid():Boolean
    {
        return direction && direction.isValid();
    }

    /**
     * Compare Arm object equality.
     *
     * <p>Two Arm objects are equal if and only if both Arm objects represent the
     * exact same physical arm in the same frame and both Arm objects are valid.</p>
     * @since 2.0.3
     */
    public function isEqualTo( other:Arm ):Boolean
    {
        if( !isValid() || !other.isValid() )
            return false;

        if( length != other.length )
            return false;

        if( width != other.width )
            return false;

        return true;
    }

    /**
     * Constructs an invalid Arm object.
     *
     * <p>Get valid Arm objects from a Hand object.</p>
     *
     * @since 2.0.3
     */
    static public function invalid():Arm
    {
        return new Arm();
    }

    /**
     * A string containing a brief, human readable description of the Arm object.
     *
     * @returns A description of the Arm object as a string.
     * @since 2.0.3
     */
    public function toString():String
    {
        return "[Arm direction: " + direction + " length: " + length + " width: " + width + " elbowPosition: " + elbowPosition + " wristPosition: " + wristPosition + "]";
    }
}
}