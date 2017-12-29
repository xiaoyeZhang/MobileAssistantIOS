//
//  ZXYBaseViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/1/22.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "ZXYBaseViewController.h"

@interface ZXYBaseViewController ()

@end

@implementation ZXYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

-(void)frequency_statistics:(NSString *)info{
    
    LogModule *logmodule = [[LogModule alloc]init];
    [logmodule Select_statistics:info];
    
}

- (void)set_logmodel{
    
    if (self.model.length > 0) {
        
    }else{
        self.model = @"";
    }
    LogModule *logmodule = [[LogModule alloc]init];
    [logmodule Select_LogModule:self.model];
    
}

- (void)select_logmodel:(NSString *)model{
    
    LogModule *logmodule = [[LogModule alloc]init];
    [logmodule Select_LogModule:model];
    
}

- (void) setSpecialConfigStr:(NSString *)specialconfigStr{
    
    
    self.specialConfig = [specialconfigStr stringByReplacingOccurrencesOfString:@";"withString:@""];
    
//    self.specialConfig1 = [_specialConfig substringWithRange:NSMakeRange(0, 1)];
//    self.specialConfig2 = [_specialConfig substringWithRange:NSMakeRange(1, 1)];
//    self.specialConfig3 = [_specialConfig substringWithRange:NSMakeRange(2, 1)];
//    self.specialConfig4 = [_specialConfig substringWithRange:NSMakeRange(3, 1)];
//    self.specialConfig5 = [_specialConfig substringWithRange:NSMakeRange(4, 1)];
//    self.specialConfig6 = [_specialConfig substringWithRange:NSMakeRange(5, 1)];
//    self.specialConfig7 = [_specialConfig substringWithRange:NSMakeRange(6, 1)];
//    self.specialConfig8 = [_specialConfig substringWithRange:NSMakeRange(7, 1)];
//    self.specialConfig9 = [_specialConfig substringWithRange:NSMakeRange(8, 1)];
//    self.specialConfig10 = [_specialConfig substringWithRange:NSMakeRange(9, 1)];
//    self.specialConfig11 = [_specialConfig substringWithRange:NSMakeRange(10, 1)];
//    self.specialConfig12 = [_specialConfig substringWithRange:NSMakeRange(11, 1)];
//    self.specialConfig13 = [_specialConfig substringWithRange:NSMakeRange(12, 1)];
//    self.specialConfig14 = [_specialConfig substringWithRange:NSMakeRange(13, 1)];
//    self.specialConfig15 = [_specialConfig substringWithRange:NSMakeRange(14, 1)];
//    self.specialConfig16 = [_specialConfig substringWithRange:NSMakeRange(15, 1)];
//    self.specialConfig17 = [_specialConfig substringWithRange:NSMakeRange(16, 1)];
//    self.specialConfig18 = [_specialConfig substringWithRange:NSMakeRange(17, 1)];
//    self.specialConfig19 = [_specialConfig substringWithRange:NSMakeRange(18, 1)];
    
    
}

- (NSString *)setLevel:(NSString *)company_level{
    
    NSString *level;
    
    switch ([company_level intValue]) {
        case 0:
            level = @"A+类客户";
            break;
        case 1:
            level = @"A1类客户";
            break;
        case 2:
            level = @"B1类客户";
            break;
        case 3:
            level = @"A2类客户";
            break;
        case 4:
            level = @"B2类客户";
            break;
        case 5:
            level = @"C1类客户";
            break;
        case 6:
            level = @"C2类客户";
            break;
        case 7:
            level = @"D类客户";
            break;
        case 99:
            level = @"未定级别";
            break;
        default:
            break;
    }
    return level;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
