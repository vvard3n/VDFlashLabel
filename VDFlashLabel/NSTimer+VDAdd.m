//
//  NSTimer+VDAdd.m
//  VDFlashLabel
//
//  Created by Harwyn T'an on 2017/3/9.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import "NSTimer+VDAdd.h"

@implementation NSTimer (VDAdd)

+ (void)vd_timerBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(vd_timerBlock:) userInfo:[block copy] repeats:repeats];
}

@end
