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
	FREObject LeapNative_enableGesture(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
	FREObject LeapNative_isGestureEnabled(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
	FREObject LeapNative_hasFocus(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getClosestScreenHitPointable(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getClosestScreenHit(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

    //frame class
    FREObject LeapNative_frameRotationProbability(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_frameScaleProbability(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_frameTranslationProbability(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    
    //hand class
    FREObject LeapNative_handRotationProbability(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_handScaleProbability(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_handTranslationProbability(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    
    //screen class
    FREObject LeapNative_getScreenDistanceToPoint(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getScreenHeightPixels(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getScreenWidthPixels(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getScreenHorizontalAxis(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getScreenVerticalAxis(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getScreenBottomLeftCorner(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getScreenIntersect(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getScreenProject(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getScreenIsValid(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getScreenNormal(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

    //device class
    FREObject LeapNative_getDeviceDistanceToBoundary(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getDeviceHorizontalViewAngle(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getDeviceVerticalViewAngle(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getDeviceIsEmbedded(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getDeviceIsStreaming(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getDeviceIsValid(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getDeviceRange(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    
    //config class
    FREObject LeapNative_getConfigBool(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getConfigFloat(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getConfigInt32(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getConfigString(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getConfigType(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_setConfigBool(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_setConfigFloat(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_setConfigString(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_setConfigSave(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    
    //policy
    FREObject LeapNative_setPolicyFlags(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    FREObject LeapNative_getPolicyFlags(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
    
    
    //initializer / finalizer
    void contextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctions, const FRENamedFunction** functions);
    void contextFinalizer(FREContext ctx);
    
    LEAPNATIVE_API void LeapNativeInitializer(void** extData, FREContextInitializer* ctxInitializer, FREContextFinalizer* ctxFinalizer);
	LEAPNATIVE_API void LeapNativeFinalizer(void* extData);
}

#endif /* defined(__LeapNative__LNExtension__) */
