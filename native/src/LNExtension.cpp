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
    
    FRENamedFunction _Shared_methods[] = {
        { (const uint8_t*) "isSupported", 0, LeapNative_isSupported }
	};
    
	FRENamedFunction _Instance_methods[] = {
  		{ (const uint8_t*) "getFrame", 0, LeapNative_getFrame }
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