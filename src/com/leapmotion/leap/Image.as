package com.leapmotion.leap
{
import flash.display.BitmapData;

/**
 * The Image class represents a single greyscale image from one of the the Leap Motion cameras.
 *
 * <p>In addition to image data, the Image object provides a distortion map for correcting lens distortion.</p>
 *
 * <p>Note that Image objects can be invalid, which means that they do not contain valid image data.
 * Get valid Image objects from Frame::frames().
 * Test for validity with the Image::isValid() function.</p>
 *
 * @author logotype
 *
 */
public class Image
{
    /**
     * The image ID.
     *
     * <p>Images with ID of 0 are from the left camera; those with an ID of 1 are from the
     * right camera (with the device in its standard operating position with
     * the green LED facing the operator).</p>
     */
    public var id:int;

    /**
     * The image data.
     *
     * <p>The original image data is a set of 8-bit intensity values.</p>
     *
     * <p>A BitmapData object contains an array of pixel data. This data can represent either
     * a fully opaque bitmap or a transparent bitmap that contains alpha channel data.
     * Either type of BitmapData object is stored as a buffer of 32-bit integers.
     * Each 32-bit integer determines the properties of a single pixel in the bitmap.</p>
     *
     * <p>Each 32-bit integer is a combination of four 8-bit channel values (from 0 to 255)
     * that describe the alpha transparency and the red, green, and blue (ARGB) values
     * of the pixel. (For ARGB values, the most significant byte represents the alpha
     * channel value, followed by red, green, and blue.)</p>
     *
     */
    public var data:BitmapData;

    /**
     * The distortion calibration map for this image.
     *
     * <p>The calibration map is a 64x64 grid of points. Each point is defined by
     * a pair of 32-bit floating point values. Each point in the map
     * represents a ray projected into the camera. The value of
     * a grid point defines the pixel in the image data containing the brightness
     * value produced by the light entering along the corresponding ray. By
     * interpolating between grid data points, you can find the brightness value
     * for any projected ray. Grid values that fall outside the range [0..1] do
     * not correspond to a value in the image data and those points should be ignored.</p>
     *
     * <p>The calibration map can be used to render an undistorted image as well as to
     * find the true angle from the camera to a feature in the raw image. The
     * distortion map itself is designed to be used with GLSL shader programs.
     * In other contexts, it may be more convenient to use the <code>Image::rectify()</code>
     * and <code>Image::warp()</code> functions.</p>
     *
     * <p>Distortion is caused by the lens geometry as well as imperfections in the
     * lens and sensor window. The calibration map is created by the calibration
     * process run for each device at the factory (and which can be rerun by the
     * user).</p>
     *
     * <p>Note, in a future release, there will be two distortion maps per image;
     * one containing the horizontal values and the other containing the vertical values.</p>
     */
    public var distortion:Vector.<Number> = new Vector.<Number>();

    /**
     * The image width.
     *
     */
    public var width:Number;

    /**
     * The image height.
     *
     */
    public var height:Number;

    /**
     * The stride of the distortion map.
     *
     * <p>Since each point on the 64x64 element distortion map has two values in the
     * buffer, the stride is 2 times the size of the grid. (Stride is currently fixed
     * at 2 * 64 = 128).</p>
     */
    public var distortionWidth:Number;

    /**
     * The distortion map height.
     *
     */
    public var distortionHeight:Number;

    /**
     * The horizontal ray offset.
     *
     * <p>Used to convert between normalized coordinates in the range [0..1] and the
     * ray slope range [-4..4].</p>
     */
    public var rayOffsetX:Number;

    /**
     * The vertical ray offset.
     *
     * <p>Used to convert between normalized coordinates in the range [0..1] and the
     * ray slope range [-4..4].</p>
     */
    public var rayOffsetY:Number;

    /**
     * The horizontal ray scale factor.
     *
     * <p>Used to convert between normalized coordinates in the range [0..1] and the
     * ray slope range [-4..4].</p>
     */
    public var rayScaleX:Number;

    /**
     * The vertical ray scale factor.
     *
     * <p>Used to convert between normalized coordinates in the range [0..1] and the
     * ray slope range [-4..4].</p>
     */
    public var rayScaleY:Number;

    /**
     * @private
     * Reference to the Controller which created this object.
     */
    public var controller:Controller;

    /**
     * Constructs a Image object.
     *
     * <p>An uninitialized image is considered invalid.
     * Get valid Image objects from a ImageList vector obtained from the <code>Frame::images()</code> method.</p>
     *
     */
    public function Image()
    {
    }

    /**
     * Provides the corrected camera ray intercepting the specified point on the image.
     *
     * <p>Given a point on the image, <code>rectify()</code> corrects for camera distortion
     * and returns the true direction from the camera to the source of that image point
     * within the Leap Motion field of view.</p>
     *
     * <p>This direction vector has an x and y component [x, y, 0], with the third element
     * always zero. Note that this vector uses the 2D camera coordinate system
     * where the x-axis parallels the longer (typically horizontal) dimension and
     * the y-axis parallels the shorter (vertical) dimension. The camera coordinate
     * system does not correlate to the 3D Leap Motion coordinate system.</p>
     *
     * @param uv A Vector containing the position of a pixel in the image.
     * @return A Vector containing the ray direction (the z-component of the vector is always 0).
     */
    public function rectify( uv:Vector3 ):Vector3
    {
        if( !controller.context )
            throw new Error( "Method only supported for Native connections." );
        else
            return controller.context.call( "imageRectify", id, uv.x, uv.y, uv.z );
    }

    /**
     * Provides the point in the image corresponding to a ray projecting from the camera.
     *
     * <p>Given a ray projected from the camera in the specified direction, <code>warp()</code>
     * corrects for camera distortion and returns the corresponding pixel
     * coordinates in the image.</p>
     *
     * <p>The ray direction is specified in relationship to the camera. The first
     * vector element corresponds to the "horizontal" view angle; the second
     * corresponds to the "vertical" view angle.</p>
     *
     * @param xy A Vector containing the ray direction.
     * @return A Vector containing the pixel coordinates [x, y, 0] (with z always zero).
     */
    public function warp( xy:Vector3 ):Vector3
    {
        if( !controller.context )
            throw new Error( "Method only supported for Native connections." );
        else
            return controller.context.call( "imageWarp", id, xy.x, xy.y, xy.z );
    }

    /**
     * Reports whether this is a valid Image object.
     * @return True, if this Image object contains valid image data.
     *
     */
    public function isValid():Boolean
    {
        return width > 0 && height > 0;
    }

    /**
     * Compare Image equality/inequality component-wise.
     * @param other The Image to compare with.
     * @return True; if equal, False otherwise.
     *
     */
    final public function isEqualTo( other:Image ):Boolean
    {
        if( width != other.width || height != other.height || id != other.id )
            return false;
        else
            return true;
    }

    /**
     * Returns an invalid Image object.
     *
     * <p>You can use the instance returned by this function in
     * comparisons testing whether a given Image instance
     * is valid or invalid.
     * (You can also use the <code>Image.isValid()</code> function.)</p>
     *
     * @return The invalid Image instance.
     *
     */
    static public function invalid():Image
    {
        return new Image();
    }

    /**
     * Returns a string containing this Image in a human readable format.
     * @return
     *
     */
    public function toString():String
    {
        return "[Image id:" + id + " width:" + width + " height:" + height + "]";
    }
}
}
