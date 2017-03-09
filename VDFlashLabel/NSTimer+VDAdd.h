//
//  NSTimer+VDAdd.h
//  VDFlashLabel
//
//  Created by Harwyn T'an on 2017/3/9.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (VDAdd)

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

@end
