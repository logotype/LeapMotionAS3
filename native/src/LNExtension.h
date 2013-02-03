//
//  LNExtension.h
//  LeapNative
//
//  Created by Wouter Verweirder on 01/02/13.
//  Copyright (c) 2013 Wouter Verweirder. All rights reserved.
//

#ifndef __LeapNative__LNExtension__
#define __LeapNative__LNExtension__

#ifdef LEAPNATIVE_OS_WINDOWS
#ifdef LEAPNATIVE_EXPORTS
#define LEAPNATIVE_API __declspec(dllexport)
#else
#define LEAPNATIVE_API __declspec(dllimport)
#endif
#include "FlashRuntimeExtensions.h"
#else
#define LEAPNATIVE_API __attribute__((visibility("default")))
#include <Adobe AIR/Adobe AIR.h>
#endif

extern "C" {
    
    //methods
    FREObject LeapNative_isSupported(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
	FREObject LeapNative_getFrame(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    
    //initializer / finalizer
    void contextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctions, const FRENamedFunction** functions);
    void contextFinalizer(FREContext ctx);
    
    LEAPNATIVE_API void LeapNativeInitializer(void** extData, FREContextInitializer* ctxInitializer, FREContextFinalizer* ctxFinalizer);
	LEAPNATIVE_API void LeapNativeFinalizer(void* extData);
}

#endif /* defined(__LeapNative__LNExtension__) */
