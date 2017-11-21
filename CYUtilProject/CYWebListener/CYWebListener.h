//
//  CYWebListener.h
//  CYUtilProject
//
//  Created by xn011644 on 02/03/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CYWebListener;

@protocol CYWebHandler

@property (nonatomic, weak) CYWebListener *listener;

- (BOOL)handleEvent:(NSString *)event params:(NSDictionary *)params;

@end

typedef BOOL (^CYWebHandlerBlock)(NSString *event, NSDictionary *params, CYWebListener *listener);

@interface CYWebListener : NSObject

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) UIViewController *controller;

- (instancetype)initWithWebView:(UIWebView *)webView controller:(UIViewController *)controller;

- (BOOL)canHandleEvent:(NSString *)event;
- (BOOL)handleEvent:(NSString *)event params:(NSDictionary *)params;

// CYWebListener has a strong reference to handler
- (void)registerHandler:(id<CYWebHandler>)handler
               forEvent:(NSString *)event;
// CYWebListener copy handler
// handler 实现的时候，小心内存泄漏
- (void)registerHandlerBlock:(CYWebHandlerBlock)handler
                    forEvent:(NSString *)event;

@end
