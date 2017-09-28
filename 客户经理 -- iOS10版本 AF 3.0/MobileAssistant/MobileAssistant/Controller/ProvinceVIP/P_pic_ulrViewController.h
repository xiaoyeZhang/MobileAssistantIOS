//
//  P_pic_ulrViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/13.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@interface P_pic_ulrViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *Pic_ulrWebView;

@property (strong,nonatomic) NSString *pic_url;
@end
