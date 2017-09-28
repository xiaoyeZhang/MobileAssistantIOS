//
//  Reommended_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/29.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Reommended_DetailViewController.h"
#import "MBProgressHUD.h"
#import "Reommened_Detail_HeadViewTableViewCell.h"
#import "Reommened_Detail_FoodViewTableViewCell.h"
#import "Recommended_DetailEntity.h"
#import <MessageUI/MessageUI.h>

@interface Reommended_DetailViewController ()<MBProgressHUDDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>{
    
    MBProgressHUD *HUD;
    Reommened_Detail_HeadViewTableViewCell *cell1;
    Reommened_Detail_FoodViewTableViewCell *cell2;
}

@property (strong, nonatomic) NSMutableArray *arrayCutomer;
@end

@implementation Reommended_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayCutomer = [[NSMutableArray alloc]init];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@详情",self.APP_Name];
    UIButton *backBtn = [self setNaviCommonBackBtn];
    
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getData];
    
}

#pragma mark - ButtonMethod
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)ClickBtn:(UIButton *)sender {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"share_app",@"method",
                           self.APP_ID,@"app_id",
                           nil];
    [service getNetWorkData:param Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        if ([strState isEqualToString:@"1"]) {
        
            NSDictionary *attributes = [entity objectForKey:@"content"];
            
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.messageComposeDelegate = self;
            
            NSString *message = [NSString stringWithFormat:@"%@",[attributes valueForKey:@"sms_content"]];
            
            messageController.body = message;
            
            if (self.tel.length != 0) {
             
                messageController.recipients = @[self.tel];
                
            }
        
            [self presentViewController:messageController animated:YES completion:nil];
            
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        
    }];
    
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    // 应该用这个！！！
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    if (self.arrayCutomer.count > 0) {
        num = 2;
    }else{
        num = 0;
    }
    return num;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return 115;
    }else{
        CGSize size = [cell2.messageLabel sizeThatFits:CGSizeMake(cell2.messageLabel.frame
                                                                  .size.width, MAXFLOAT)];
        if (size.height == 0) {
            return 100;
        }
        return size.height + 50;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *Identifier1 = @"Reommened_Detail_HeadViewTableViewCell";
    static NSString *Identifier2 = @"Reommened_Detail_FoodViewTableViewCell";
    
    cell1 = [tableView dequeueReusableCellWithIdentifier:Identifier1];
    cell2 = [tableView dequeueReusableCellWithIdentifier:Identifier2];
    
    if (!cell1) {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:Identifier1 owner:nil options:nil] firstObject];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (!cell2) {
        cell2 = [[[NSBundle mainBundle] loadNibNamed:Identifier2 owner:nil options:nil] firstObject];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Recommended_DetailEntity *entity = [self.arrayCutomer objectAtIndex:0];

    if (indexPath.row == 0) {
        
        cell1.nameLabel.text = entity.name;
        
        cell1.countLabel.text = [NSString stringWithFormat:@"(%@)",entity.count];
        
        NSURL *url = [NSURL URLWithString:entity.icon];
        
        [cell1.icon setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        
        [self setStarNum:entity.level];
        
        return cell1;

    }else{
        
        cell2.messageLabel.text = entity.content;
        return cell2;

    }
   
}

- (void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"get_app_detail",@"method",
                           self.APP_ID,@"app_id",
                           nil];
    [service getNetWorkData:param Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        if ([strState isEqualToString:@"1"]) {
            
            NSDictionary *attributes = [entity objectForKey:@"content"];
       
            Recommended_DetailEntity *entity = [[Recommended_DetailEntity alloc] init];
            entity = [entity initWithAttributes:attributes];
            [self.arrayCutomer addObject:entity];

            [self.tableView reloadData];
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        
    }];
    
}

- (void)setStarNum:(NSString *)num{
    
    cell1.star_1.image = [UIImage imageNamed:@"star_2"];
    cell1.star_2.image = [UIImage imageNamed:@"star_2"];
    cell1.star_3.image = [UIImage imageNamed:@"star_2"];
    cell1.star_4.image = [UIImage imageNamed:@"star_2"];
    cell1.star_5.image = [UIImage imageNamed:@"star_2"];
    
    if ([num isEqualToString:@"1"]){
        cell1.star_1.image = [UIImage imageNamed:@"star_1"];
    }else if ([num isEqualToString:@"2"]){
        cell1.star_1.image = [UIImage imageNamed:@"star_1"];
        cell1.star_2.image = [UIImage imageNamed:@"star_1"];
    }else if ([num isEqualToString:@"3"]){
        cell1.star_1.image = [UIImage imageNamed:@"star_1"];
        cell1.star_2.image = [UIImage imageNamed:@"star_1"];
        cell1.star_3.image = [UIImage imageNamed:@"star_1"];
    }else if ([num isEqualToString:@"4"]){
        cell1.star_1.image = [UIImage imageNamed:@"star_1"];
        cell1.star_2.image = [UIImage imageNamed:@"star_1"];
        cell1.star_3.image = [UIImage imageNamed:@"star_1"];
        cell1.star_4.image = [UIImage imageNamed:@"star_1"];
    }else if ([num isEqualToString:@"5"]){
        cell1.star_1.image = [UIImage imageNamed:@"star_1"];
        cell1.star_2.image = [UIImage imageNamed:@"star_1"];
        cell1.star_3.image = [UIImage imageNamed:@"star_1"];
        cell1.star_4.image = [UIImage imageNamed:@"star_1"];
        cell1.star_5.image = [UIImage imageNamed:@"star_1"];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
