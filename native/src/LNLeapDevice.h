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

        //screen class
        FREObject getScreenDistanceToPoint(int screenId, float pX, float pY, float pZ);
        FREObject getScreenHeightPixels(int screenId);
        FREObject getScreenWidthPixels(int screenId);
        FREObject getScreenHorizontalAxis(int screenId);
        FREObject getScreenVerticalAxis(int screenId);
        FREObject getScreenBottomLeftCorner(int screenId);
        FREObject getScreenIntersect(int screenId, Pointable pointable, bool normalize, float clampRatio);
        FREObject getScreenIsValid(int screenId);
        FREObject getScreenNormal(int screenId);
        
    private:
        FREContext m_ctx;
        
        LNLeapListener* listener;
        Frame           lastFrame;
        
        FREObject createVector3(double x, double y, double z);
        FREObject createMatrix(FREObject xVector3, FREObject yVector3, FREObject zVector3, FREObject originVector3);
    };
}

#endif /* defined(__LeapNative__LNLeapDevice__) */
