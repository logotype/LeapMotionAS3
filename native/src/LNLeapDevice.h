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
        
        FREObject getFrame();
        
    private:
        FREContext m_ctx;
        
        Controller*     controller;
        LNLeapListener* listener;
        
        FREObject createVector3(double x, double y, double z);
        FREObject createMatrix(FREObject xVector3, FREObject yVector3, FREObject zVector3, FREObject originVector3);
    };
}

#endif /* defined(__LeapNative__LNLeapDevice__) */
