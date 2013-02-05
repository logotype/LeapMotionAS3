//
//  LNLeapListener.cpp
//  LeapNative
//
//  Created by Wouter Verweirder on 01/02/13.
//  Copyright (c) 2013 Wouter Verweirder. All rights reserved.
//

#include "LNLeapListener.h"

namespace leapnative {

    LNLeapListener::LNLeapListener(FREContext* ctx) {
        m_ctx = ctx;
    }

    LNLeapListener::~LNLeapListener() {
        m_ctx = NULL;
    }

    void LNLeapListener::onInit(const Controller& controller) {
        std::cout << "LNLeapListener::Initialized" << std::endl;
        FREDispatchStatusEventAsync(*m_ctx, (const uint8_t*) "onInit", (const uint8_t*) "");
    }

    void LNLeapListener::onConnect(const Controller& controller) {
        std::cout << "LNLeapListener::Connected" << std::endl;
        FREDispatchStatusEventAsync(*m_ctx, (const uint8_t*) "onConnect", (const uint8_t*) "");
    }

    void LNLeapListener::onDisconnect(const Controller& controller) {
        std::cout << "LNLeapListener::Disconnected" << std::endl;
        FREDispatchStatusEventAsync(*m_ctx, (const uint8_t*) "onDisconnect", (const uint8_t*) "");
    }

    void LNLeapListener::onExit(const Controller& controller) {
        std::cout << "LNLeapListener::Exited" << std::endl;
        FREDispatchStatusEventAsync(*m_ctx, (const uint8_t*) "onExit", (const uint8_t*) "");
    }

    void LNLeapListener::onFrame(const Controller& controller) {
        FREDispatchStatusEventAsync(*m_ctx, (const uint8_t*) "onFrame", (const uint8_t*) "");
    }
    
}