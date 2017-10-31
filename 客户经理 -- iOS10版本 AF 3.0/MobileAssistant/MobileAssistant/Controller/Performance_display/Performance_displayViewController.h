//
//  Performance_displayViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/10/30.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@interface Performance_displayViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong,nonatomic) NSString *user_num;
@end
