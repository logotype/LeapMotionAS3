//
//  LNLeapDevice.h
//  LeapNative
//
//  Created by Wouter Verweirder on 01/02/13.
//  Copyright (c) 2013 Wouter Verweirder. All rights reserved.
//

#ifndef __LeapNative__LNLeapDevice__
#define __LeapNative__LNLeapDevice__

#include <iostream>

#ifdef LEAPNATIVE_OS_WINDOWS
#include "FlashRuntimeExtensions.h"
#else
#include <Adobe AIR/Adobe AIR.h>
#endif

#include "Leap.h"
using namespace Leap;

#include "LNLeapListener.h"

namespace leapnative {
    class LNLeapDevice {
    public:
        LNLeapDevice(FREContext ctx);
        ~LNLeapDevice();
        
        Controller*     controller;

        FREObject getFrame();
        FREObject getClosestScreenHitPointable(int pointableId);
        FREObject getClosestScreenHit(Vector position, Vector direction);
        FREObject hasFocus();
        
        //frame class
        FREObject frameProbability(int frameId, int sinceFrameId, int type);
        
        //hand class
        FREObject handProbability(int handId, int frameId, int sinceFrameId, int type);
        
        //screen class
        FREObject getScreenDistanceToPoint(int screenId, Vector point);
        FREObject getScreenHeightPixels(int screenId);
        FREObject getScreenWidthPixels(int screenId);
        FREObject getScreenHorizontalAxis(int screenId);
        FREObject getScreenVerticalAxis(int screenId);
        FREObject getScreenBottomLeftCorner(int screenId);
        FREObject getScreenIntersect(int screenId, Vector position, Vector direction, bool normalize, float clampRatio = 1.0f);
        FREObject getScreenProject(int screenId, Vector position, bool normalize, float clampRatio = 1.0f);
        FREObject getScreenIsValid(int screenId);
        FREObject getScreenNormal(int screenId);
        
        //device class
        FREObject getDeviceDistanceToBoundary(Vector position);
        FREObject getDeviceHorizontalViewAngle();
        FREObject getDeviceVerticalViewAngle();
        FREObject getDeviceIsEmbedded();
        FREObject getDeviceIsStreaming();
        FREObject getDeviceIsValid();
        FREObject getDeviceRange();
        
        //config class
        FREObject getConfigBool(uint32_t len, const uint8_t* key);
        FREObject getConfigFloat(uint32_t len, const uint8_t* key);
        FREObject getConfigInt32(uint32_t len, const uint8_t* key);
        FREObject getConfigString(uint32_t len, const uint8_t* key);
        FREObject getConfigType(uint32_t len, const uint8_t* key);
        FREObject setConfigBool(uint32_t len, const uint8_t* key, bool value);
        FREObject setConfigFloat(uint32_t len, const uint8_t* key, float value);
        FREObject setConfigString(uint32_t len, const uint8_t* key, uint32_t valueLen, const uint8_t* valueArray);
        FREObject setConfigSave();
        
        //policy flags
        FREObject setPolicyFlags(uint32_t flags);
        FREObject getPolicyFlags();

    private:
        FREContext m_ctx;
        
        LNLeapListener* listener;
        Frame           lastFrame;
        
        FREObject createVector3(double x, double y, double z);
        FREObject createMatrix(FREObject xVector3, FREObject yVector3, FREObject zVector3, FREObject originVector3);
    };
}

#endif /* defined(__LeapNative__LNLeapDevice__) */
