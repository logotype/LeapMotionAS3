//
//  LNLeapDevice.cpp
//  LeapNative
//
//  Created by Wouter Verweirder on 01/02/13.
//  Copyright (c) 2013 Wouter Verweirder. All rights reserved.
//

#include "LNLeapDevice.h"
#include <map>

namespace leapnative {
    LNLeapDevice::LNLeapDevice(FREContext ctx) {
        std::cout << "LNLeapDevice::constructor" << std::endl;
        m_ctx = ctx;
        controller = new Controller();
        listener = new LNLeapListener(&m_ctx);
        controller->addListener(*listener);
    }
    
    LNLeapDevice::~LNLeapDevice() {
        std::cout << "LNLeapDevice::destructor" << std::endl;
        controller->removeListener(*listener);
        delete listener;
        listener = NULL;
        delete controller;
        controller = NULL;
    }
    
    FREObject LNLeapDevice::createVector3(double x, double y, double z) {
        FREObject obj;
		FREObject freX, freY, freZ;
		FRENewObjectFromDouble(x, &freX);
		FRENewObjectFromDouble(y, &freY);
        FRENewObjectFromDouble(z, &freZ);
		FREObject params[] = {freX, freY, freZ};
		FRENewObject( (const uint8_t*) "com.leapmotion.leap.Vector3", 3, params, &obj, NULL);
        return obj;
    }
    
    FREObject LNLeapDevice::createMatrix(FREObject xVector3, FREObject yVector3, FREObject zVector3, FREObject originVector3) {
        FREObject obj;
		FREObject params[] = {xVector3, yVector3, zVector3, originVector3};
		FRENewObject( (const uint8_t*) "com.leapmotion.leap.Matrix", 4, params, &obj, NULL);
        return obj;
    }
    
    FREObject LNLeapDevice::getFrame() {
        
        Frame frame = controller->frame();
        
        // TODO: Only continue with valid Frame?
        
        FREObject freCurrentFrame;
        FRENewObject( (const uint8_t*) "com.leapmotion.leap.Frame", 0, NULL, &freCurrentFrame, NULL);
        
        //AS SOON AS I TRY TO GET / SET A PROPERTY ON A CLASS OF MY OWN, IT CRASHES WHEN USING THE ASC 2.0 COMPILER
        //THIS CODE RUNS FINE IN THE CLASSIC COMPILER
        FREObject freFrameId;
        FRENewObjectFromInt32((int32_t) frame.id(), &freFrameId);
        FRESetObjectProperty(freCurrentFrame, (const uint8_t*) "id", freFrameId, NULL);
        
        const Vector frameTranslation = frame.translation(lastFrame);
        FRESetObjectProperty(freCurrentFrame, (const uint8_t*) "translationVector", createVector3(frameTranslation.x, frameTranslation.y, frameTranslation.z), NULL);
        
        const Matrix frameRotation = frame.rotationMatrix(lastFrame);
        FRESetObjectProperty(freCurrentFrame, (const uint8_t*) "rotation", createMatrix(
                     createVector3(frameRotation.xBasis[0], frameRotation.xBasis[1], frameRotation.xBasis[2]),
                     createVector3(frameRotation.yBasis[0], frameRotation.yBasis[1], frameRotation.yBasis[2]),
                     createVector3(frameRotation.zBasis[0], frameRotation.zBasis[1], frameRotation.zBasis[2]),
                     createVector3(frameRotation.origin[0], frameRotation.origin[1], frameRotation.origin[2])
        ), NULL);
        
        FREObject freFrameScaleFactor;
        FRENewObjectFromDouble(frame.scaleFactor(lastFrame), &freFrameScaleFactor);
        FRESetObjectProperty(freCurrentFrame, (const uint8_t*) "scaleFactorNumber", freFrameScaleFactor, NULL);
        
        FREObject freTimestamp;
        FRENewObjectFromInt32((int32_t) frame.timestamp(), &freTimestamp);
        FRESetObjectProperty(freCurrentFrame, (const uint8_t*) "timestamp", freTimestamp, NULL);
        
        std::map<int, FREObject> freHandsMap;
        if (!frame.hands().empty()) {
            
            FREObject freHands;
            FREGetObjectProperty(freCurrentFrame, (const uint8_t*) "hands", &freHands, NULL);
            
            for(int i = 0; i < frame.hands().count(); i++) {
                const Hand hand = frame.hands()[i];
                
                FREObject freHand;
                FRENewObject( (const uint8_t*) "com.leapmotion.leap.Hand", 0, NULL, &freHand, NULL);
                FRESetObjectProperty(freHand, (const uint8_t*) "frame", freCurrentFrame, NULL);
                FRESetObjectProperty(freHand, (const uint8_t*) "direction", createVector3(hand.direction()[0], hand.direction()[1], hand.direction()[2]), NULL);
                
                FREObject freHandId;
                FRENewObjectFromInt32(hand.id(), &freHandId);
                FRESetObjectProperty(freHand, (const uint8_t*) "id", freHandId, NULL);
                FRESetObjectProperty(freHand, (const uint8_t*) "palmNormal", createVector3(hand.palmNormal()[0], hand.palmNormal()[1], hand.palmNormal()[2]), NULL);
                FRESetObjectProperty(freHand, (const uint8_t*) "palmPosition", createVector3(hand.palmPosition()[0], hand.palmPosition()[1], hand.palmPosition()[2]), NULL);
                FRESetObjectProperty(freHand, (const uint8_t*) "palmVelocity", createVector3(hand.palmVelocity()[0], hand.palmVelocity()[1], hand.palmVelocity()[2]), NULL);
                
                const Matrix rotation = hand.rotationMatrix(lastFrame);
                FRESetObjectProperty(freHand, (const uint8_t*) "rotation", createMatrix(
                                     createVector3(rotation.xBasis[0], rotation.xBasis[1], rotation.xBasis[2]),
                                     createVector3(rotation.yBasis[0], rotation.yBasis[1], rotation.yBasis[2]),
                                     createVector3(rotation.zBasis[0], rotation.zBasis[1], rotation.zBasis[2]),
                                     createVector3(rotation.origin[0], rotation.origin[1], rotation.origin[2])
                ), NULL);
                
                FREObject freScaleFactor;
                FRENewObjectFromDouble(hand.scaleFactor(lastFrame), &freScaleFactor);
                FRESetObjectProperty(freHand, (const uint8_t*) "scaleFactorNumber", freScaleFactor, NULL);
                
                FRESetObjectProperty(freHand, (const uint8_t*) "sphereCenter", createVector3(hand.sphereCenter()[0], hand.sphereCenter()[1], hand.sphereCenter()[2]), NULL);
                
                FREObject freSphereRadius;
                FRENewObjectFromDouble(hand.sphereRadius(), &freSphereRadius);
                FRESetObjectProperty(freHand, (const uint8_t*) "sphereRadius", freSphereRadius, NULL);
                
                const Vector translation = hand.translation(lastFrame);
                FRESetObjectProperty(freHand, (const uint8_t*) "translationVector", createVector3(translation.x, translation.y, translation.z), NULL);
                
                FRESetArrayElementAt(freHands, i, freHand);
                
                freHandsMap[hand.id()] = freHand;
            }
        }
        
        std::map<int, FREObject> frePointablesMap;
        if(!frame.pointables().empty()) {
            
            FREObject frePointables;
            FREGetObjectProperty(freCurrentFrame, (const uint8_t*) "pointables", &frePointables, NULL);
            
            for(int i = 0; i < frame.pointables().count(); i++) {
                const Pointable pointable = frame.pointables()[i];
                
                FREObject frePointable;
                if(pointable.isTool()) {
                    FRENewObject( (const uint8_t*) "com.leapmotion.leap.Tool", 0, NULL, &frePointable, NULL);
                } else {
                    FRENewObject( (const uint8_t*) "com.leapmotion.leap.Finger", 0, NULL, &frePointable, NULL);
                }
                
                FRESetObjectProperty(frePointable, (const uint8_t*) "frame", freCurrentFrame, NULL);
                
                FREObject frePointableId;
                FRENewObjectFromInt32(pointable.id(), &frePointableId);
                FRESetObjectProperty(frePointable, (const uint8_t*) "id", frePointableId, NULL);
                
                FREObject frePointableLength;
                FRENewObjectFromInt32(pointable.length(), &frePointableLength);
                FRESetObjectProperty(frePointable, (const uint8_t*) "length", frePointableLength, NULL);

                FREObject frePointableWidth;
                FRENewObjectFromInt32(pointable.width(), &frePointableWidth);
                FRESetObjectProperty(frePointable, (const uint8_t*) "width", frePointableWidth, NULL);

                FRESetObjectProperty(frePointable, (const uint8_t*) "direction", createVector3(pointable.direction().x, pointable.direction().y, pointable.direction().z), NULL);
                FRESetObjectProperty(frePointable, (const uint8_t*) "tipPosition", createVector3(pointable.tipPosition().x, pointable.tipPosition().y, pointable.tipPosition().z), NULL);
                FRESetObjectProperty(frePointable, (const uint8_t*) "tipVelocity", createVector3(pointable.tipVelocity().x, pointable.tipVelocity().y, pointable.tipVelocity().z), NULL);
                
                //map to hand & back
                if(pointable.hand().isValid()) {
                    FREObject freHand = freHandsMap[pointable.hand().id()];
                    FRESetObjectProperty(frePointable, (const uint8_t*) "hand", freHand, NULL);
                    
                    FREObject frePointables;
                    FREGetObjectProperty(freHand, (const uint8_t*) "pointables", &frePointables, NULL);
                    
                    uint32_t numPointables;
                    FREGetArrayLength(frePointables, &numPointables);
                    FRESetArrayElementAt(frePointables, numPointables, frePointable);
                    
                    FREObject freSpecificHandPointables;
                    if(pointable.isTool()) {
                        FREGetObjectProperty(freHand, (const uint8_t*) "tools", &freSpecificHandPointables, NULL);
                    } else {
                        FREGetObjectProperty(freHand, (const uint8_t*) "fingers", &freSpecificHandPointables, NULL);
                    }
                    uint32_t numSpecificHandTools;
                    FREGetArrayLength(freSpecificHandPointables, &numSpecificHandTools);
                    FRESetArrayElementAt(freSpecificHandPointables, numSpecificHandTools, frePointable);
                }
                
                //push it in current frame
                FRESetArrayElementAt(frePointables, i, frePointable);
                
                //specific
                FREObject freSpecificPointables;
                if(pointable.isTool()) {
                    FREGetObjectProperty(freCurrentFrame, (const uint8_t*) "tools", &freSpecificPointables, NULL);
                } else {
                    FREGetObjectProperty(freCurrentFrame, (const uint8_t*) "fingers", &freSpecificPointables, NULL);
                }
                uint32_t numSpecificTools;
                FREGetArrayLength(freSpecificPointables, &numSpecificTools);
                FRESetArrayElementAt(freSpecificPointables, numSpecificTools, frePointable);
                frePointablesMap[pointable.id()] = frePointable;
            }
        }
        
        if(!frame.gestures().empty()) {
            
            FREObject freGestures;
            FREGetObjectProperty(freCurrentFrame, (const uint8_t*) "_gestures", &freGestures, NULL);
            
            for(int i = 0; i < frame.gestures().count(); i++) {
                const Gesture gesture = frame.gestures()[i];
                
                int state;
                switch (gesture.state()) {
                    case Gesture::STATE_INVALID:
                        state = 0;
                        break;
                    case Gesture::STATE_START:
                        state = 1;
                        break;
                    case Gesture::STATE_UPDATE:
                        state = 2;
                        break;
                    case Gesture::STATE_STOP:
                        state = 3;
                        break;
                        
                    default:
                        break;
                }
                
                int type;
                FREObject freGesture;
                switch (gesture.type()) {
                    case Gesture::TYPE_SWIPE:
                    {
                        type = 5;
                        SwipeGesture swipe = gesture;
                        
                        FRENewObject( (const uint8_t*) "com.leapmotion.leap.SwipeGesture", 0, NULL, &freGesture, NULL);
                        
                        FRESetObjectProperty(freGesture, (const uint8_t*) "direction", createVector3(swipe.direction().x, swipe.direction().y, swipe.direction().z), NULL);
                        FRESetObjectProperty(freGesture, (const uint8_t*) "position", createVector3(swipe.position().x, swipe.position().y, swipe.position().z), NULL);
                        FRESetObjectProperty(freGesture, (const uint8_t*) "startPosition", createVector3(swipe.startPosition().x, swipe.startPosition().y, swipe.startPosition().z), NULL);
                        
                        FREObject freSwipeGestureSpeed;
                        FRENewObjectFromDouble(swipe.speed(), &freSwipeGestureSpeed);
                        FRESetObjectProperty(freGesture, (const uint8_t*) "speed", freSwipeGestureSpeed, NULL);

                        break;
                    }
                    case Gesture::TYPE_CIRCLE:
                    {
                        type = 6;
                        CircleGesture circle = gesture;

                        FRENewObject( (const uint8_t*) "com.leapmotion.leap.CircleGesture", 0, NULL, &freGesture, NULL);
                        
                        FRESetObjectProperty(freGesture, (const uint8_t*) "center", createVector3(circle.center().x, circle.center().y, circle.center().z), NULL);
                        FRESetObjectProperty(freGesture, (const uint8_t*) "normal", createVector3(circle.normal().x, circle.normal().y, circle.normal().z), NULL);
                        
                        FREObject freCircleGestureProgress;
                        FRENewObjectFromDouble(circle.progress(), &freCircleGestureProgress);
                        FRESetObjectProperty(freGesture, (const uint8_t*) "progress", freCircleGestureProgress, NULL);
                        
                        FREObject freCircleGestureRadius;
                        FRENewObjectFromDouble(circle.radius(), &freCircleGestureRadius);
                        FRESetObjectProperty(freGesture, (const uint8_t*) "radius", freCircleGestureRadius, NULL);
                    
                        FREObject frePointable = frePointablesMap[circle.pointable().id()];
                        if(frePointable != NULL)
                        {
                            FRESetObjectProperty(freGesture, (const uint8_t*) "pointable", frePointable, NULL);
                        }

                        break;
                    }
                    case Gesture::TYPE_SCREEN_TAP:
                    {
                        type = 7;
                        ScreenTapGesture screentap = gesture;
                        
                        FRENewObject( (const uint8_t*) "com.leapmotion.leap.ScreenTapGesture", 0, NULL, &freGesture, NULL);

                        FRESetObjectProperty(freGesture, (const uint8_t*) "direction", createVector3(screentap.direction().x, screentap.direction().y, screentap.direction().z), NULL);
                        FRESetObjectProperty(freGesture, (const uint8_t*) "position", createVector3(screentap.position().x, screentap.position().y, screentap.position().z), NULL);

                        break;
                    }
                    case Gesture::TYPE_KEY_TAP:
                    {
                        type = 8;
                        KeyTapGesture tap = gesture;
                        
                        FRENewObject( (const uint8_t*) "com.leapmotion.leap.KeyTapGesture", 0, NULL, &freGesture, NULL);

                        FRESetObjectProperty(freGesture, (const uint8_t*) "direction", createVector3(tap.direction().x, tap.direction().y, tap.direction().z), NULL);
                        FRESetObjectProperty(freGesture, (const uint8_t*) "position", createVector3(tap.position().x, tap.position().y, tap.position().z), NULL);
                        
                        break;
                    }
                    default:
                    {
                        type = 4;
                        FRENewObject( (const uint8_t*) "com.leapmotion.leap.Gesture", 0, NULL, &freGesture, NULL);
                        break;
                    }
                }
                
                FREObject freGestureState;
                FRENewObjectFromInt32(state, &freGestureState);
                FRESetObjectProperty(freGesture, (const uint8_t*) "state", freGestureState, NULL);
                
                FREObject freGestureType;
                FRENewObjectFromInt32(type, &freGestureType);
                FRESetObjectProperty(freGesture, (const uint8_t*) "type", freGestureType, NULL);

                FREObject freGestureDuration;
                FRENewObjectFromInt32((int32_t) gesture.duration(), &freGestureDuration);
                FRESetObjectProperty(freGesture, (const uint8_t*) "duration", freGestureDuration, NULL);
                
                FREObject freGestureDurationSeconds;
                FRENewObjectFromDouble(gesture.durationSeconds(), &freGestureDurationSeconds);
                FRESetObjectProperty(freGesture, (const uint8_t*) "durationSeconds", freGestureDurationSeconds, NULL);
                
                FRESetObjectProperty(freGesture, (const uint8_t*) "frame", freCurrentFrame, NULL);
                
                FREObject freGestureId;
                FRENewObjectFromInt32(gesture.id(), &freGestureId);
                FRESetObjectProperty(freGesture, (const uint8_t*) "id", freGestureId, NULL);
                
                if (!gesture.hands().empty()) {
                    
                    FREObject freGestureHands;
                    FREGetObjectProperty(freGesture, (const uint8_t*) "hands", &freGestureHands, NULL);
                    
                    for(int i = 0; i < gesture.hands().count(); i++) {
                        const Hand hand = gesture.hands()[i];
                        
                        FREObject freHand = freHandsMap[hand.id()];
                        FRESetArrayElementAt(freGestureHands, i, freHand);
                    }
                }
                
                if (!gesture.pointables().empty()) {
                    
                    FREObject freGesturePointables;
                    FREGetObjectProperty(freGesture, (const uint8_t*) "pointables", &freGesturePointables, NULL);
                    
                    for(int i = 0; i < gesture.pointables().count(); i++) {
                        const Pointable pointable = gesture.pointables()[i];
                        
                        FREObject frePointable = frePointablesMap[pointable.id()];
                        FRESetArrayElementAt(freGesturePointables, i, frePointable);
                    }
                }
                
                //push it in current gesture vector
                FRESetArrayElementAt(freGestures, i, freGesture);
            }
        }
        
        lastFrame = frame;
        
        return freCurrentFrame;
    }

    //screen class
    FREObject LNLeapDevice::getScreenDistanceToPoint(int screenId, float pX, float pY, float pZ) {
        ScreenList screenList = controller->calibratedScreens();
        Screen screen = screenList[screenId];
        
        Vector vectorPoint = Vector(pX, pY, pZ);
        
        FREObject freScreenDistance;
        FRENewObjectFromDouble((double) screen.distanceToPoint(vectorPoint), &freScreenDistance);
        
        return freScreenDistance;
    }
    
    FREObject LNLeapDevice::getScreenHeightPixels(int screenId) {
        ScreenList screenList = controller->calibratedScreens();
        Screen screen = screenList[screenId];
        
        FREObject freReturnValue;
        FRENewObjectFromInt32((int32_t) screen.heightPixels(), &freReturnValue);
        
        return freReturnValue;
    }
    
    FREObject LNLeapDevice::getScreenWidthPixels(int screenId) {
        ScreenList screenList = controller->calibratedScreens();
        Screen screen = screenList[screenId];
        
        FREObject freReturnValue;
        FRENewObjectFromInt32((int32_t) screen.widthPixels(), &freReturnValue);
        
        return freReturnValue;
    }
    
    FREObject LNLeapDevice::getScreenHorizontalAxis(int screenId) {
        ScreenList screenList = controller->calibratedScreens();
        Screen screen = screenList[screenId];
        
        const Vector vector = screen.horizontalAxis();
        return createVector3(vector.x, vector.y, vector.z);
    }
    
    FREObject LNLeapDevice::getScreenVerticalAxis(int screenId) {
        ScreenList screenList = controller->calibratedScreens();
        Screen screen = screenList[screenId];
        
        const Vector vector = screen.verticalAxis();
        return createVector3(vector.x, vector.y, vector.z);
    }
    
    FREObject LNLeapDevice::getScreenBottomLeftCorner(int screenId) {
        ScreenList screenList = controller->calibratedScreens();
        Screen screen = screenList[screenId];
        
        const Vector vector = screen.bottomLeftCorner();
        return createVector3(vector.x, vector.y, vector.z);
    }
    
    FREObject LNLeapDevice::getScreenIntersect(int screenId, Pointable pointable, bool normalize, float clampRatio) {
        ScreenList screenList = controller->calibratedScreens();
        Screen screen = screenList[screenId];
        
        const Vector vector = screen.intersect(pointable, normalize, clampRatio);
        return createVector3(vector.x, vector.y, vector.z);
    }
    
    FREObject LNLeapDevice::getScreenIsValid(int screenId) {
        ScreenList screenList = controller->calibratedScreens();
        Screen screen = screenList[screenId];
        
        FREObject freReturnValue;
        FRENewObjectFromBool(screen.isValid(), &freReturnValue);
        
        return freReturnValue;
    }
    
    FREObject LNLeapDevice::getScreenNormal(int screenId) {
        ScreenList screenList = controller->calibratedScreens();
        Screen screen = screenList[screenId];
        
        const Vector vector = screen.normal();
        return createVector3(vector.x, vector.y, vector.z);
    }
    
    FREObject LNLeapDevice::getClosestScreenHit(Pointable pointable) {
        ScreenList screenList = controller->calibratedScreens();
        Screen screen = screenList.closestScreenHit(pointable);
        
        FREObject freReturnValue;
        FRENewObjectFromInt32((int32_t) screen.id(), &freReturnValue);
        return freReturnValue;
    }
    //screen class
}
