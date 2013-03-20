//
//  LNExtension.cpp
//  LeapNative
//
//  Created by Wouter Verweirder on 01/02/13.
//  Copyright (c) 2013 Wouter Verweirder. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include "LNExtension.h"
#include "LNLeapDevice.h"
#include "LNFREUtilities.h"

extern "C" {
    
    FREObject LeapNative_isSupported(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
		std::cout << "LeapNative_isSupported" << std::endl;
		FREObject isSupported;
		FRENewObjectFromBool(1, &isSupported);
		return isSupported;
	}
    
    FREObject LeapNative_getFrame(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);
        return device->getFrame();
    }
    
    FREObject LeapNative_enableGesture(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);
        
        int gestureClassType;
        FREGetObjectAsInt32(argv[0], &gestureClassType);
        
        bool gestureEnabled = createBoolFromFREObject(argv[1]);
        
        switch (gestureClassType) {
            case 5:
                device->controller->enableGesture(Gesture::TYPE_SWIPE, gestureEnabled);
                break;
            case 6:
                device->controller->enableGesture(Gesture::TYPE_CIRCLE, gestureEnabled);
                break;
            case 7:
                device->controller->enableGesture(Gesture::TYPE_SCREEN_TAP, gestureEnabled);
                break;
            case 8:
                device->controller->enableGesture(Gesture::TYPE_KEY_TAP, gestureEnabled);
                break;
            default:
                std::cout << "LeapNative_enableGesture: invalid argument" << std::endl;
                break;
        }
        return NULL;
    }
    
    FREObject LeapNative_isGestureEnabled(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);
        
        int gestureClassType;
        FREGetObjectAsInt32(argv[0], &gestureClassType);
        
        bool gestureEnabled;

        switch (gestureClassType) {
            case 5:
                gestureEnabled = device->controller->isGestureEnabled(Gesture::TYPE_SWIPE);
                break;
            case 6:
                gestureEnabled = device->controller->isGestureEnabled(Gesture::TYPE_CIRCLE);
                break;
            case 7:
                gestureEnabled = device->controller->isGestureEnabled(Gesture::TYPE_SCREEN_TAP);
                break;
            case 8:
                gestureEnabled = device->controller->isGestureEnabled(Gesture::TYPE_KEY_TAP);
                break;
            default:
                std::cout << "LeapNative_isGestureEnabled: invalid argument" << std::endl;
                gestureEnabled = false;
                break;
        }
        
        return createFREObjectForBool(gestureEnabled);
    }
    
    FREObject LeapNative_getClosestScreenHit(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);
        
        int pointableId;
        FREGetObjectAsInt32(argv[0], &pointableId);
        
        return device->getClosestScreenHit(pointableId);
    }

    //start screen class
    FREObject LeapNative_getScreenDistanceToPoint(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);

        int screenId;
        double pX;
        double pY;
        double pZ;
        FREGetObjectAsInt32(argv[0], &screenId);
        FREGetObjectAsDouble(argv[1], &pX);
        FREGetObjectAsDouble(argv[2], &pY);
        FREGetObjectAsDouble(argv[3], &pZ);
        return device->getScreenDistanceToPoint(screenId, (float) pX, (float) pY, (float) pZ);
    }
    
    FREObject LeapNative_getScreenHeightPixels(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);
        
        int screenId;
        FREGetObjectAsInt32(argv[0], &screenId);
        
        return device->getScreenHeightPixels(screenId);
    }
    
    FREObject LeapNative_getScreenWidthPixels(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);
        
        int screenId;
        FREGetObjectAsInt32(argv[0], &screenId);
        
        return device->getScreenWidthPixels(screenId);
    }
    
    FREObject LeapNative_getScreenHorizontalAxis(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);
        
        int screenId;
        FREGetObjectAsInt32(argv[0], &screenId);
        
        return device->getScreenHorizontalAxis(screenId);
    }
    
    FREObject LeapNative_getScreenVerticalAxis(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);
        
        int screenId;
        FREGetObjectAsInt32(argv[0], &screenId);
        
        return device->getScreenVerticalAxis(screenId);
    }
    
    FREObject LeapNative_getScreenBottomLeftCorner(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);
        
        int screenId;
        FREGetObjectAsInt32(argv[0], &screenId);
        
        return device->getScreenBottomLeftCorner(screenId);
    }
    
    FREObject LeapNative_getScreenIntersect(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);
        
        int screenId;
        FREGetObjectAsInt32(argv[0], &screenId);

        int pointableId;
        FREGetObjectAsInt32(argv[1], &pointableId);
        
        bool normalize = createBoolFromFREObject(argv[2]);

        double clampRatio;
        FREGetObjectAsDouble(argv[3], &clampRatio);
        
        return device->getScreenIntersect(screenId, pointableId, normalize, (float) clampRatio);
    }
    
    FREObject LeapNative_getScreenIsValid(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);
        
        int screenId;
        FREGetObjectAsInt32(argv[0], &screenId);
        
        return device->getScreenIsValid(screenId);
    }
    
    FREObject LeapNative_getScreenNormal(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);
        
        int screenId;
        FREGetObjectAsInt32(argv[0], &screenId);
        
        return device->getScreenNormal(screenId);
    }
    //end screen class
    
    FRENamedFunction _Shared_methods[] = {
        { (const uint8_t*) "isSupported", false, LeapNative_isSupported }
	};
    
	FRENamedFunction _Instance_methods[] = {
  		{ (const uint8_t*) "getFrame", false, LeapNative_getFrame },
  		{ (const uint8_t*) "enableGesture", false, LeapNative_enableGesture },
  		{ (const uint8_t*) "isGestureEnabled", false, LeapNative_isGestureEnabled },
  		{ (const uint8_t*) "getClosestScreenHit", false, LeapNative_getClosestScreenHit },
  		{ (const uint8_t*) "getScreenDistanceToPoint", false, LeapNative_getScreenDistanceToPoint },
  		{ (const uint8_t*) "getScreenHeightPixels", false, LeapNative_getScreenHeightPixels },
  		{ (const uint8_t*) "getScreenWidthPixels", false, LeapNative_getScreenWidthPixels },
  		{ (const uint8_t*) "getScreenHorizontalAxis", false, LeapNative_getScreenHorizontalAxis },
  		{ (const uint8_t*) "getScreenVerticalAxis", false, LeapNative_getScreenVerticalAxis },
  		{ (const uint8_t*) "getScreenBottomLeftCorner", false, LeapNative_getScreenBottomLeftCorner },
  		{ (const uint8_t*) "getScreenIntersect", false, LeapNative_getScreenIntersect },
  		{ (const uint8_t*) "getScreenIsValid", false, LeapNative_getScreenIsValid },
  		{ (const uint8_t*) "getScreenNormal", false, LeapNative_getScreenNormal }
	};
    
    void contextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctions, const FRENamedFunction** functions) {
        std::cout << "context initializer" << std::endl;
        if ( 0 == strcmp( (const char*) ctxType, "shared" ) )
		{
			*numFunctions = sizeof( _Shared_methods ) / sizeof( FRENamedFunction );
			*functions = _Shared_methods;
		}
		else
        {
            *numFunctions = sizeof( _Instance_methods ) / sizeof( FRENamedFunction );
            *functions = _Instance_methods;
            
            leapnative::LNLeapDevice* device = new leapnative::LNLeapDevice(ctx);
            FRESetContextNativeData(ctx, (void*) device);
        }
	}
    
	void contextFinalizer(FREContext ctx) {
        leapnative::LNLeapDevice* device;
        FREGetContextNativeData(ctx, (void **) &device);
        if(device != NULL)
        {
            delete device;
        }
        std::cout << "context finalizer" << std::endl;
		return;
	}
    
	void LeapNativeInitializer(void** extData, FREContextInitializer* ctxInitializer, FREContextFinalizer* ctxFinalizer) {
		*ctxInitializer = &contextInitializer;
		*ctxFinalizer = &contextFinalizer;
	}
    
	void LeapNativeFinalizer(void* extData) {
		return;
	}
}