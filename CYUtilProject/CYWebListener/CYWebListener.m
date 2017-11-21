//
//  CYWebListener.m
//  CYUtilProject
//
//  Created by xn011644 on 02/03/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYWebListener.h"

@interface CYWebListener ()

@property (nonatomic, strong) NSMutableDictionary *objectHandlers;
@property (nonatomic, strong) NSMutableDictionary *blockHandlers;

@end

@implementation CYWebListener

- (instancetype)initWithWebView:(UIWebView *)webView
                     controller:(UIViewController *)controller {
    if (self = [super init]) {
        _webView = webView;
        _controller = controller;
    }
    return self;
}

- (BOOL)canHandleEvent:(NSString *)event {

    return ([self.objectHandlers objectForKey:event] != nil)
            || ([self.blockHandlers objectForKey:event] != nil);
}

- (BOOL)handleEvent:(NSString *)event params:(NSDictionary *)params {

    id<CYWebHandler> handler = [self.objectHandlers objectForKey:event];
    if (handler) {
        return [handler handleEvent:event params:params];
    }

    CYWebHandlerBlock handlerBlock = [self.blockHandlers objectForKey:event];
    if (handlerBlock) {
        return handlerBlock(event, params, self);
    }
    return NO;
}

// CYWebListener has a strong reference to handler
- (void)registerHandler:(id<CYWebHandler>)handler
               forEvent:(NSString *)event {

    if (!handler
        || !event) {
        return;
    }
    if (!self.objectHandlers) {
        self.objectHandlers = [NSMutableDictionary dictionary];
    }
    if ([self.blockHandlers objectForKey:event]) {
        [self.blockHandlers removeObjectForKey:event];
    }
    [self.objectHandlers setObject:handler forKey:event];
}

// CYWebListener copy handler
// handler 实现的时候，小心内存泄漏
- (void)registerHandlerBlock:(CYWebHandlerBlock)handler
                    forEvent:(NSString *)event {

    if (!handler
        || !event) {
        return;
    }
    if (!self.blockHandlers) {
        self.blockHandlers = [NSMutableDictionary dictionary];
    }
    if ([self.objectHandlers objectForKey:event]) {
        [self.objectHandlers removeObjectForKey:event];
    }
    [self.blockHandlers setObject:[handler copy] forKey:event];
}

@end
