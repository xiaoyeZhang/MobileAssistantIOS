//
//  shareViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/28.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "shareViewController.h"
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>

@interface shareViewController ()<MBProgressHUDDelegate,UIWebViewDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
{
    MBProgressHUD *HUD;
    NSString *shareMessage;
}


@end

@implementation shareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"App分享";
   
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 100, 44);
    [rightBtn setTitle:@"短信分享" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self setNaviBarRightView:rightBtn];

    [rightBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    NSString *url = [NSString stringWithFormat:@"http://pub.dayo.net.cn/gzcmm/download/index.php?tt=1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    _webView.backgroundColor = [UIColor whiteColor];
    
    _webView.delegate = self;
    
    [_webView loadRequest:request];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [HUD hide:YES];
}
#pragma mark - ButtonMethod
- (void)backBtnClicked:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitBtnClicked:(UIButton *)sender{
 
    
    [self setnewsRead];
    
}


- (void)setnewsRead{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"sms_share",@"method",
                           nil];
    
    [service getNetWorkData:param Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        if ([strState isEqualToString:@"1"]) {
            shareMessage = [entity valueForKey:@"content"];
            
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.messageComposeDelegate = self;
            
            NSString *message = [NSString stringWithFormat:@"%@",shareMessage];
            
            messageController.body = message;
            
            [self presentViewController:messageController animated:YES completion:nil];
            
        }
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
//    NSString *tipContent;
//        switch (result) {
//        case MessageComposeResultCancelled:
//            tipContent = @"短信发送取消";
//                break;
//    
//             case MessageComposeResultFailed:
//                 tipContent = @"发送短信失败";
//                 break;
//    
//             case MessageComposeResultSent:
//                 tipContent = @"发送成功";
//                 break;
//        
//             default:
//                break;
//           }
//    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:tipContent delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//  [alterView show];
    
    
    // 应该用这个！！！
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

@end
