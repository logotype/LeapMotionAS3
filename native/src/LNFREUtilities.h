//
//  LNFREUtilities.h
//  LeapNative
//
//  Created by Wouter Verweirder on 05/03/13.
//  Copyright (c) 2013 Wouter Verweirder. All rights reserved.
//

#ifndef LeapNative_LNFREUtilities_h
#define LeapNative_LNFREUtilities_h

#ifdef LEAPNATIVE_OS_WINDOWS
#include "FlashRuntimeExtensions.h"
#else
#include <Adobe AIR/Adobe AIR.h>
#endif

unsigned int createUnsignedIntFromFREObject(FREObject freObject)
{
	unsigned int value;
	FREGetObjectAsUint32(freObject, &value);
	return value;
}

double createDoubleFromFREObject(FREObject freObject)
{
	double value;
	FREGetObjectAsDouble(freObject, &value);
	return value;
}

bool createBoolFromFREObject(FREObject freObject)
{
	unsigned int value;
	FREGetObjectAsBool(freObject, &value);
    return (value != 0);
}

FREObject createFREObjectForUTF8(const char* str)
{
	FREObject fre;
	FRENewObjectFromUTF8(strlen(str), (const uint8_t*) str, &fre);
	return fre;
}

FREObject createFREObjectForUnsignedInt(unsigned int i)
{
	FREObject fre;
	FRENewObjectFromUint32(i, &fre);
	return fre;
}

FREObject createFREObjectForDouble(double d)
{
	FREObject fre;
	FRENewObjectFromDouble(d, &fre);
	return fre;
}

FREObject createFREObjectForBool(bool b)
{
	FREObject fre;
	FRENewObjectFromBool((b) ? 1 : 0, &fre);
	return fre;
}

#endif
