//
//  UINavigationItem+iOS7PtFix.m
//  AiPlayUser
//
//  Created by xy on 15/4/2.
//  Copyright (c) 2015年 xy. All rights reserved.
//

#import "UINavigationItem+iOS7PtFix.h"
#import <objc/runtime.h>

#define FIX_TAG -0011223344 //修正item tag

@implementation UINavigationItem (iOS7PtFix)

- (BOOL)isIOS7
{
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending);
}

- (UIBarButtonItem *)spacer
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -10;
    space.tag = FIX_TAG;//标记为修正item
    return space;
}

#pragma mark -

- (void)my_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if ([self isIOS7] && leftBarButtonItem && leftBarButtonItem.customView) { //当为默认的Item时不需要调整
        [self my_setLeftBarButtonItem:nil];
        [self my_setLeftBarButtonItems:@[[self spacer], leftBarButtonItem]];
    } else {
        if ([self isIOS7]) {
            [self my_setLeftBarButtonItems:nil];
        }
        [self my_setLeftBarButtonItem:leftBarButtonItem];
    }
}

- (void)my_setLeftBarButtonItems:(NSArray *)leftBarButtonItems
{
    if ([self isIOS7] && leftBarButtonItems && leftBarButtonItems.count > 0) {
        UIBarButtonItem *item = leftBarButtonItems[0];
        
        if (item.customView) { //当第一个为自定义时需要调整否则不需要调整
            NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:leftBarButtonItems.count + 1];
            [items addObject:[self spacer]];
            [items addObjectsFromArray:leftBarButtonItems];
            
            [self my_setLeftBarButtonItems:items];
        }else{
            [self my_setLeftBarButtonItems:leftBarButtonItems];
        }
    } else {
        [self my_setLeftBarButtonItems:leftBarButtonItems];
    }
}

- (UIBarButtonItem *)my_leftBarButtonItem
{
    if ([self isIOS7]) {
        NSArray *items = [self my_leftBarButtonItems];
        if ([items count] > 0) {
            UIBarButtonItem *item = items[0];
            if (item.tag == FIX_TAG) { //第一个自定义按钮则去除空白否则执行原方法
                return items[1];
            }
        }
    }
    return [self my_leftBarButtonItem];
}

- (NSArray *)my_leftBarButtonItems
{
    if ([self isIOS7]) {
        NSArray *items = [self my_leftBarButtonItems];
        if ([items count] > 1) {
            UIBarButtonItem *item = items[0];
            if (item.tag == FIX_TAG) { //第一个自定义按钮则去除空白否则执行原方法
                return [items subarrayWithRange:NSMakeRange(1, [items count]-1)];
            }
        }
    }
    return [self my_leftBarButtonItems];
}

#pragma mark -

- (void)my_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if ([self isIOS7] && rightBarButtonItem) {
        [self my_setRightBarButtonItem:nil];
        
        // Fix position issue in system vc, eg. cancel button in UIImagePickerController
        if (rightBarButtonItem.customView) {
            [self my_setRightBarButtonItems:@[[self spacer], rightBarButtonItem]];
        } else {
            [self my_setRightBarButtonItem:rightBarButtonItem];
        }
    } else {
        if ([self isIOS7]) {
            [self my_setRightBarButtonItems:nil];
        }
        [self my_setRightBarButtonItem:rightBarButtonItem];
    }
}

- (void)my_setRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    if ([self isIOS7] && rightBarButtonItems && rightBarButtonItems.count > 0) {
        UIBarButtonItem *item = rightBarButtonItems[0];
        
        if (item.customView) {
            NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:rightBarButtonItems.count + 1];
            [items addObject:[self spacer]];
            [items addObjectsFromArray:rightBarButtonItems];
            
            [self my_setRightBarButtonItems:items];
        }else{
            [self my_setRightBarButtonItems:rightBarButtonItems];
        }
    } else {
        [self my_setRightBarButtonItems:rightBarButtonItems];
    }
}

- (UIBarButtonItem *)my_rightBarButtonItem
{
    if ([self isIOS7]) {
        NSArray *items = [self my_rightBarButtonItems];
        if ([items count] > 0) {
            UIBarButtonItem *item = items[0];
            if (item.tag == FIX_TAG) { //第一个自定义按钮则去除空白否则执行原方法
                return items[1];
            }
        }
    }
    return [self my_leftBarButtonItem];
}

- (NSArray *)my_rightBarButtonItems
{
    if ([self isIOS7]) {
        NSArray *items = [self my_rightBarButtonItems];
        if ([items count] > 1) {
            UIBarButtonItem *item = items[0];
            if (item.tag == FIX_TAG) { //第一个自定义按钮则去除空白否则执行原方法
                return [items subarrayWithRange:NSMakeRange(1, [items count]-1)];
            }
        }
    }
    return [self my_rightBarButtonItems];
}

#pragma mark -

+ (void)my_swizzle:(SEL)aSelector
{
    SEL bSelector = NSSelectorFromString([NSString stringWithFormat:@"my_%@", NSStringFromSelector(aSelector)]);
    
    Method m1 = class_getInstanceMethod(self, aSelector);
    Method m2 = class_getInstanceMethod(self, bSelector);
    
    method_exchangeImplementations(m1, m2);
}

+ (void)load
{
    [self my_swizzle:@selector(setLeftBarButtonItem:)];
    [self my_swizzle:@selector(setLeftBarButtonItems:)];
    [self my_swizzle:@selector(leftBarButtonItem)];
    [self my_swizzle:@selector(leftBarButtonItems)];
    [self my_swizzle:@selector(setRightBarButtonItem:)];
    [self my_swizzle:@selector(setRightBarButtonItems:)];
    [self my_swizzle:@selector(rightBarButtonItem)];
    [self my_swizzle:@selector(rightBarButtonItems)];
}

@end
