//
//  small_piece_paperDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/13.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "small_piece_paperDetailViewController.h"
#import "MBProgressHUD.h"
#import "ImagesBrowserViewController.h"

@interface small_piece_paperDetailViewController ()<UITextViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    UserEntity *userEntity;
}
@end

@implementation small_piece_paperDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"小纸条";
    
    userEntity = [UserEntity sharedInstance];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.text = self.entity.title;
    
    self.contentLabel.text = self.entity.content;
    
    self.user_name_timeLabel.text = [NSString stringWithFormat:@"%@     %@",self.entity.create_name,[self.entity.create_time substringToIndex:10]];
    
    if (self.entity.img_name.length > 0 ) {
        
    }else{
        self.ImageBtn.alpha = 0;
    }
    
    if ([self.entity.reply_content isEqualToString:@"-1"]) {
        
        self.reply_contentView.text = @"";
        
    }else{
        self.reply_contentView.text = self.entity.reply_content;
    }
    
    if ([userEntity.type_id intValue] == ROLE_CUSTOMER) {
        
        if ([self.entity.reply_content isEqualToString:@"-1"]) {
            
            self.reply_contentView.text = @"";
            
        }else{
            
            self.reply_contentView.userInteractionEnabled = NO;
            self.reply_contentView.text = self.entity.reply_content;
            self.reply_Btn.alpha = 0;
        }
        
        
    }else{
        
        if ([self.entity.reply_content isEqualToString:@"-1"]) {
            
            self.reply_contentView.alpha = 0;
            
        }
        
        self.reply_contentView.userInteractionEnabled = NO;
        
        self.reply_Btn.alpha = 0;
    }
    
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnTableViewCellBtnClicked:(id)sender {
    
    if (self.entity.img_name.length > 0) {
        NSString *names = [self.entity.img_name substringFromIndex:1];
        if (names.length > 0) {
            NSArray *imagesNameArr = [names componentsSeparatedByString:@","];
            
            ImagesBrowserViewController *vc = [[ImagesBrowserViewController alloc] init];
            vc.imagesNameArray = imagesNameArr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

    
}

- (IBAction)submitBtn:(id)sender {

    [self.view endEditing:YES];
    
    static BOOL isDone = YES;
    NSLog(@"%hhd",isDone);
    if (!isDone) {
        return;
    }
    
    if (self.reply_contentView.text.length == 0) {
        ALERT_ERR_MSG(@"回复信息不能为空");
        isDone = YES;
        return;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.entity.tape_id, @"tape_id",
                          
                           self.reply_contentView.text, @"content",
                           
                           @"tape_reply", @"method", nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"] == YES) {
            
            
        
        } else {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
            
        }
        isDone = YES;
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        isDone = YES;
    }];
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
