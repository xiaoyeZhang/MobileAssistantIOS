//
//  UIColor+Random.m
//  GH
//
//  Created by xy on 15/11/5.
//  Copyright © 2015年 dxw. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+(UIColor *)randomColor
{
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        (time(NULL));
    }
    CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
