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
        virtual void onFocusGained(const Controller&);
        virtual void onFocusLost(const Controller&);
        virtual void onServiceConnect(const Controller&);
        virtual void onServiceDisconnect(const Controller&);
        virtual void onDeviceChange(const Controller&);
    
    private:
    
        FREContext* m_ctx;
    };
}

#endif /* defined(__LeapNative__LNLeapListener__) */
