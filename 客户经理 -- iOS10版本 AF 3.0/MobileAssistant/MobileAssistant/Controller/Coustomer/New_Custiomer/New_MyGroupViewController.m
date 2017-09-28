//
//  New_MyGroupViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/10/8.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "New_MyGroupViewController.h"
#import "New_groupTableViewCell.h"
#import "News_MyGroup_MessageViewController.h"
#import "MBProgressHUD.h"
#import "CompEntity.h"

@interface New_MyGroupViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    New_groupTableViewCell *cell;
    CGSize size;
    NSMutableArray *mutableArry;
}
@end

@implementation New_MyGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"集团";

    mutableArry = [[NSMutableArray alloc]init];

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    [self getData];
}

#pragma mark - ButtonMethod
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return mutableArry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    
//    size = [cell.GroupName sizeThatFits:CGSizeMake(cell.GroupName.frame
//                                                           .size.width, MAXFLOAT)];
//    if (size.height == 0) {
//        return 127;
//    }
//    
    return 127;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *couponTableViewCellIdentifier=@"New_groupTableViewCell";
    cell = (New_groupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"New_groupTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];

        cell.bgView.layer.cornerRadius = 5;
        cell.bgView.layer.borderWidth = 1;
        cell.bgView.layer.borderColor = RGBA(225, 225, 225, 1).CGColor;
    }

    CompEntity *entity = [mutableArry objectAtIndex:indexPath.row];
    
    cell.GroupName.text = entity.name;
    cell.GroupNum.text = [NSString stringWithFormat:@"集团编号：%@",entity.num];
    cell.GroupAddress.text = [NSString stringWithFormat:@"集团地址：%@",entity.address];
    cell.GroupType.text = [NSString stringWithFormat:@"集团类型：%@",[self setLevel:entity.company_level]];
    NSString *company_staty;
    if ([entity.company_status isEqualToString:@"0"]) {
        company_staty = @"正使用集团客户";
    }else{
        company_staty = @"未开户集团客户";
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"集团状态：%@",company_staty]];
    
    [str addAttribute:NSForegroundColorAttributeName value:RGBA(52, 160, 213, 1) range:NSMakeRange(5, str.length - 5)];
    
    cell.GroupState.attributedText = str;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CompEntity *entity = [mutableArry objectAtIndex:indexPath.row];
    
    News_MyGroup_MessageViewController *vc = [[News_MyGroup_MessageViewController alloc]init];
    
    vc.name = entity.name;
    
    vc.compEntity = entity;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) getData
{
    UserEntity *entity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = @{@"method":@"company_list",
                            @"user_num":entity.num,
                            @"user_id":entity.user_id,
                            @"is_first":entity.is_first,
                            };;
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
//            mutableArry = [entity objectForKey:@"content"];
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                CompEntity *entity = [[CompEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [mutableArry addObject:entity];
            }
            [self.TableView reloadData];
        }
        else
        {

        }
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
