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
        
        const Frame frame = controller->frame();
        
        // TODO: Only continue with valid Frame?
        
        FREObject freCurrentFrame;
        FRENewObject( (const uint8_t*) "com.leapmotion.leap.Frame", 0, NULL, &freCurrentFrame, NULL);
        
        //AS SOON AS I TRY TO GET / SET A PROPERTY ON A CLASS OF MY OWN, IT CRASHES WHEN USING THE ASC 2.0 COMPILER
        //THIS CODE RUNS FINE IN THE CLASSIC COMPILER
        FREObject freFrameId;
        FRENewObjectFromInt32((int32_t) frame.id(), &freFrameId);
        FRESetObjectProperty(freCurrentFrame, (const uint8_t*) "id", freFrameId, NULL);
        
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
                
                const Matrix rotation = hand.rotationMatrix(frame);
                FRESetObjectProperty(freHand, (const uint8_t*) "rotation", createMatrix(
                                     createVector3(rotation.xBasis[0], rotation.xBasis[1], rotation.xBasis[2]),
                                     createVector3(rotation.yBasis[0], rotation.yBasis[1], rotation.yBasis[2]),
                                     createVector3(rotation.zBasis[0], rotation.zBasis[1], rotation.zBasis[2]),
                                     createVector3(rotation.origin[0], rotation.origin[1], rotation.origin[2])
                ), NULL);
                
                FREObject freScaleFactor;
                FRENewObjectFromDouble(hand.scaleFactor(frame), &freScaleFactor);
                FRESetObjectProperty(freHand, (const uint8_t*) "scaleFactor", freScaleFactor, NULL);
                
                FRESetObjectProperty(freHand, (const uint8_t*) "sphereCenter", createVector3(hand.sphereCenter()[0], hand.sphereCenter()[1], hand.sphereCenter()[2]), NULL);
                
                FREObject freSphereRadius;
                FRENewObjectFromDouble(hand.sphereRadius(), &freSphereRadius);
                FRESetObjectProperty(freHand, (const uint8_t*) "sphereRadius", freSphereRadius, NULL);
                
                const Vector translation = hand.translation(frame);
                FRESetObjectProperty(freHand, (const uint8_t*) "translationVector", createVector3(translation.x, translation.y, translation.z), NULL);
                
                FRESetArrayElementAt(freHands, i, freHand);
                
                freHandsMap[hand.id()] = freHand;
            }
        }
        
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
            }
        }
        
        return freCurrentFrame;
    }
}
