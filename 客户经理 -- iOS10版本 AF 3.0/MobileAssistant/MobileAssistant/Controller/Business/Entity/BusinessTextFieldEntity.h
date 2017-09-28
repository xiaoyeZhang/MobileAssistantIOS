//
//  BusinessTextFieldEntity.h
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-25.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessTextFieldEntity : NSObject

@property (nonatomic, strong) NSString *detail_id;
@property (nonatomic, strong) NSString *strContent;
@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UILabel  *labelTitle;
@property (nonatomic, strong) NSMutableArray *arrayItem;

@end
