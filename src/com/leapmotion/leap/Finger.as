package com.leapmotion.leap
{

/**
 * The Finger class represents a tracked finger.
 *
 * <p>Fingers are Pointable objects that the Leap Motion has classified as a finger.
 * Get valid Finger objects from a Frame or a Hand object.</p>
 *
 * <p>Fingers may be permanently associated to a hand. In this case the
 * angular order of the finger IDs will be invariant. As fingers move in
 * and out of view it is possible for the guessed ID of a finger to be
 * incorrect. Consequently, it may be necessary for finger IDs to be
 * exchanged. All tracked properties, such as velocity, will remain
 * continuous in the API. However, quantities that are derived from the
 * API output (such as a history of positions) will be discontinuous
 * unless they have a corresponding ID exchange.</p>
 *
 * <p>Note that Finger objects can be invalid, which means that they do not
 * contain valid tracking data and do not correspond to a physical finger.
 * Invalid Finger objects can be the result of asking for a Finger object
 * using an ID from an earlier frame when no Finger objects with that ID
 * exist in the current frame. A Finger object created from the Finger
 * constructor is also invalid.<br/>
 * Test for validity with the <code>Finger.sValid()</code> function.</p>
 *
 * @author logotype
 *
 */
public class Finger extends Pointable
{
    /**
     * Enumerates the names of the fingers.
     *
     * <p>Members of this enumeration are returned by Finger::type() to identify a
     * Finger object.</p>
     *
     * @since 1.f
     */

    /**
     * The thumb.
     */
    static public const TYPE_THUMB:int = 0;

    /**
     * The index or fore- finger.
     */
    static public const TYPE_INDEX:int = 1;

    /**
     * The middle finger.
     */
    static public const TYPE_MIDDLE:int = 2;

    /**
     * The ring finger.
     */
    static public const TYPE_RING:int = 3;

    /**
     * The pinky or little finger.
     */
    static public const TYPE_PINKY:int = 4;

    /**
     * The name of this finger.
     *
     * <p>The anatomical type of this finger as a member of the Finger::Type enumeration.</p>
     */
    public var type:int;

    /**
     * The position of the distal interphalangeal joint of the finger.
     * This joint is closest to the tip.
     *
     * <p>The distal interphalangeal joint is located between the most extreme segment
     * of the finger (the distal phalanx) and the middle segment (the intermediate
     * phalanx).</p>
     */
    public var dipPosition:Vector3;

    /**
     * The position of the proximal interphalangeal joint of the finger. This joint is the middle
     * joint of a finger.
     *
     * <p>The proximal interphalangeal joint is located between the two finger segments
     * closest to the hand (the proximal and the intermediate phalanges). On a thumb,
     * which lacks an intermediate phalanx, this joint index identifies the knuckle joint
     * between the proximal phalanx and the metacarpal bone.</p>
     */
    public var pipPosition:Vector3;

    /**
     * The position of the metacarpopophalangeal joint, or knuckle, of the finger.
     *
     * <p>The metacarpopophalangeal joint is located at the base of a finger between
     * the metacarpal bone and the first phalanx. The common name for this joint is
     * the knuckle.</p>
     *
     * <p>On a thumb, which has one less phalanx than a finger, this joint index
     * identifies the thumb joint near the base of the hand, between the carpal
     * and metacarpal bones.</p>
     */
    public var mcpPosition:Vector3;

    /**
     * Bone connected to the wrist inside the palm
     */
    public var metacarpal:Bone;

    /**
     * Bone connecting to the palm
     */
    public var proximal:Bone;

    /**
     * Bone between the tip and the base
     */
    public var intermediate:Bone;

    /**
     * Bone at the tip of the finger
     */
    public var distal:Bone;

    /**
     * Constructs a Finger object.
     *
     * <p>An uninitialized finger is considered invalid.
     * Get valid Finger objects from a Frame or a Hand object.</p>
     *
     */
    public function Finger()
    {
        isFinger = true;
        isTool = false;
    }

    /**
     * The bone at a given bone index on this finger.
     *
     * @param boneIx An index value from the Bone::Type enumeration identifying the bone of interest.
     * @return The Bone that has the specified bone type.
     *
     * @since 1.f
     */
    public function bone( boneIx:int ):Bone
    {
        switch( boneIx )
        {
            case Bone.TYPE_METACARPAL:
                return metacarpal;
                break;
            case Bone.TYPE_PROXIMAL:
                return proximal;
                break;
            case Bone.TYPE_INTERMEDIATE:
                return intermediate;
                break;
            case Bone.TYPE_DISTAL:
                return distal;
                break;
            default:
                return Bone.invalid();
                break;
        }
    }

    /**
     * The joint positions of this finger as a vector in the order base to tip.
     *
     * @return A Vector of joint positions.
     */
    public function positions():Vector.<Vector3>
    {
        var positionsVector:Vector.<Vector3> = new Vector.<Vector3>();
        positionsVector.push(mcpPosition);
        positionsVector.push(pipPosition);
        positionsVector.push(dipPosition);
        positionsVector.push(tipPosition);

        return positionsVector;
    }

    /**
     * Returns an invalid Finger object.
     *
     * <p>You can use the instance returned by this function in
     * comparisons testing whether a given Finger instance
     * is valid or invalid.
     * (You can also use the <code>Finger.isValid()</code> function.)</p>
     *
     * @return The invalid Finger instance.
     *
     */
    static public function invalid():Finger
    {
        return new Finger();
    }
}
}
