//
//  FunctionListModel.h
//  MobileAssistant
//
//  Created by xy on 15/9/29.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunctionListModel : NSObject

@property(nonatomic, copy) NSString *normalImageName;
@property(nonatomic, copy) NSString *disabledImageName;
@property(nonatomic, assign) BOOL isDisabled;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *bgColor;
@property(nonatomic, assign) BOOL isLeft;

@end
