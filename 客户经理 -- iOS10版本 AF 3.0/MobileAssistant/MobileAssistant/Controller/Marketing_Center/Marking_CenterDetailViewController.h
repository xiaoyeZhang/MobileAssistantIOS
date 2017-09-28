//
//  Marking_CenterDetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/14.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@interface Marking_CenterDetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *url;
@end
