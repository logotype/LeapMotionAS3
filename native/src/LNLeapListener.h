//
//  LNLeapListener.h
//  LeapNative
//
//  Created by Wouter Verweirder on 01/02/13.
//  Copyright (c) 2013 Wouter Verweirder. All rights reserved.
//

#ifndef __LeapNative__LNLeapListener__
#define __LeapNative__LNLeapListener__

#include <iostream>

#ifdef LEAPNATIVE_OS_WINDOWS
#include "FlashRuntimeExtensions.h"
#else
#include <Adobe AIR/Adobe AIR.h>
#endif

#include "Leap.h"

using namespace Leap;

namespace leapnative {
    class LNLeapListener : public Listener {
    public:
    
        LNLeapListener(FREContext* ctx);
        ~LNLeapListener();
    
        virtual void onInit(const Controller&);
        virtual void onConnect(const Controller&);
        virtual void onDisconnect(const Controller&);
        virtual void onExit(const Controller&);
        virtual void onFrame(const Controller&);
    
    private:
    
        FREContext* m_ctx;
    };
}

#endif /* defined(__LeapNative__LNLeapListener__) */
