//
//  Marketing_CenterAllViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/14.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Marketing_CenterAllViewController.h"
#import "MBProgressHUD.h"
#import "MarketingCaselistEntity.h"
#import "Marketing_CenterListTableViewCell.h"

@interface Marketing_CenterAllViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    UserEntity *userEntity;
    NSMutableArray *arrayCustomerTemp;
    UILabel *LineLabel;
    NSString *type_id;
    float cellHeight;
}
@end

@implementation Marketing_CenterAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"营销中心";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableViewNews.tableFooterView = [[UIView alloc]init];
    
    type_id = @"0";
    userEntity = [UserEntity sharedInstance];
    arrayCustomerTemp = [NSMutableArray array];
    
    self.view.backgroundColor = RGBA(230, 230, 230, 1);
    LineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.system_news_Btn.frame.size.height, SCREEN_WIDTH/2, 1)];
    
    LineLabel.backgroundColor = RGBA(66, 187, 222, 1);
    
    [self.view addSubview:LineLabel];
    
    [self getDate];
}
//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)change_State_Btn:(UIButton *)sender {
    
    if (sender.tag == 0) {
        type_id = @"0";
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.system_news_Btn setTitleColor:RGBA(66, 187, 233, 1) forState:UIControlStateNormal];
            [self.company_news_Btn setTitleColor:RGBA(128, 128,128, 1) forState:UIControlStateNormal];
            LineLabel.frame = CGRectMake(0, self.system_news_Btn.frame.size.height, SCREEN_WIDTH/2, 1);
            
        }];
        
    }else if (sender.tag == 1){
        type_id = @"1";
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.company_news_Btn setTitleColor:RGBA(66, 187, 233, 1) forState:UIControlStateNormal];
            [self.system_news_Btn setTitleColor:RGBA(128, 128,128, 1) forState:UIControlStateNormal];
            LineLabel.frame = CGRectMake(SCREEN_WIDTH/2, self.system_news_Btn.frame.size.height, SCREEN_WIDTH/2, 1);
            
        }];
    }else{
        
    }
    
    [self getDate];
    
}

- (void)getDate{
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"m_case_list",
                           @"type":type_id,
                           @"user_id":userEntity.user_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        [arrayCustomerTemp removeAllObjects];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                MarketingCaselistEntity *entity = [[MarketingCaselistEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [arrayCustomerTemp addObject:entity];
            }
            
            
        }
        else
        {
            
        }
        
        [self.tableViewNews reloadData];
        
        [HUD hide:YES];
        
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrayCustomerTemp.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 64 + cellHeight + 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Marketing_CenterListTableViewCell";
    Marketing_CenterListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.supportBtn.alpha = 0;
        cell.reBtn.alpha = 0;
        cell.shareBtn.alpha = 0;
        cell.supportImage.alpha = 0;
        cell.reImage.alpha = 0;
        cell.shareImage.alpha = 0;
        
    }
    
    MarketingCaselistEntity *entity = [arrayCustomerTemp objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:entity.icon];
    
    [cell.iconImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    cell.titleLabel.text = entity.title;
    cell.timeLabel.text = entity.time;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 4; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f};
    
    CGSize size = [entity.summary boundingRectWithSize:CGSizeMake(cell.summaryLabel.frame.size.width, cell.summaryLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    cellHeight = size.height;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:entity.summary attributes:dic];
    cell.summaryLabel.attributedText = attributeStr;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
