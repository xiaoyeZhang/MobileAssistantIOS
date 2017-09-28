//
//  News_MyGroup_MessageViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/10/9.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "News_MyGroup_MessageViewController.h"
#import "New_group_base_messageTableViewCell.h"
#import "New_groupTableViewCell.h"
#import "New_ContactsTableViewCell.h"
#import "New_Contacts_MessageViewController.h"
#import "New_MyGroup_baseMessageViewController.h"
#import "MBProgressHUD.h"
#import "ContactEntity.h"
#import "Coustomer_EditViewController.h"

@interface News_MyGroup_MessageViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSString *type;
    NSMutableArray *ContactsArr;
}
//目前合作情况
@property (strong, nonatomic) NSString *Cooperation_situation;
//目前合作困难
@property (strong, nonatomic) NSString *Cooperation_difficulties;

@end

@implementation News_MyGroup_MessageViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.name;
    
    self.Cooperation_situation = @"待填写";
    self.Cooperation_difficulties = @"待填写";
    
    ContactsArr = [[NSMutableArray alloc]init];
    
    type = @"1";
    
    self.Btn_one.backgroundColor = RGBA(55, 174, 226, 1);
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.Btn_one.layer.borderColor = RGBA(55, 174, 226, 1).CGColor;
    self.Btn_one.layer.borderWidth = 1;
    [self.Btn_one setTitle:@"集团信息" forState:UIControlStateNormal];
    
    self.Btn_two.layer.borderColor = RGBA(55, 174, 226, 1).CGColor;
    [self.Btn_two setTitleColor:RGBA(55, 174, 226, 1) forState:UIControlStateNormal];
    self.Btn_two.layer.borderWidth = 1;
    [self.Btn_two setTitle:@"集团联系人" forState:UIControlStateNormal];
    
//    UIBezierPath *Btn_onePath = [UIBezierPath bezierPathWithRoundedRect:self.Btn_one.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
//    CAShapeLayer *Btn_oneLayer = [[CAShapeLayer alloc] init];
//    Btn_oneLayer.frame = self.Btn_one.bounds;
//    Btn_oneLayer.path = Btn_onePath.CGPath;
//    self.Btn_one.layer.mask = Btn_oneLayer;
//    
//    UIBezierPath *Btn_twoPath = [UIBezierPath bezierPathWithRoundedRect:self.Btn_two.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
//    CAShapeLayer *Btn_twoLayer = [[CAShapeLayer alloc] init];
//    Btn_twoLayer.frame = self.Btn_two.bounds;
//    Btn_twoLayer.path = Btn_twoPath.CGPath;
//    self.Btn_two.layer.mask = Btn_twoLayer;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
    [self getData];
}

#pragma mark - ButtonMethod
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([type isEqualToString:@"1"]) {
        
        return 1;
    }else{
        
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([type isEqualToString:@"1"]) {
        if (section == 0) {
            
            return 1;
            
        }else{
            
            return 3;
        }
    }else{
        
        return ContactsArr.count;
    
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([type isEqualToString:@"1"]) {
        if (indexPath.section == 0) {
            
            return 160;
            
        }else{
            
            return 127;
        }
    }else{
        return 110;
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if ([type isEqualToString:@"1"]) {
         
        if (section == 0) {
            return @"基本信息";
        }else if (section == 1){
            return @"已签约项目";
        }else{
            return nil;
        }
    }else{
        return [NSString stringWithFormat:@"%lu位联系人",(unsigned long)ContactsArr.count];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    view.tintColor = [UIColor whiteColor];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
     if ([type isEqualToString:@"1"]) {

         [header.textLabel setTextColor:RGBA(32, 32, 32, 1)];
         [header.textLabel setFont:[UIFont systemFontOfSize:15]];
         header.textLabel.textAlignment = NSTextAlignmentLeft;
     }else{
         
         [header.textLabel setTextColor:RGBA(145, 145, 145, 1)];
         header.textLabel.textAlignment = NSTextAlignmentCenter;
         
     }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([type isEqualToString:@"1"]) {
        if (indexPath.section == 0) {
            
            static NSString *couponTableViewCellIdentifier=@"New_group_base_messageTableViewCell";
            New_group_base_messageTableViewCell *cell = (New_group_base_messageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
            
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"New_group_base_messageTableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
                
                cell.bgView.layer.cornerRadius = 5;
                cell.bgView.layer.borderWidth = 1;
                cell.bgView.layer.borderColor = RGBA(219, 219, 219, 1).CGColor;
            }
            
            cell.GroupNum.text = [NSString stringWithFormat:@"集团编号：%@",self.compEntity.num];
            cell.GroupAddress.text = [NSString stringWithFormat:@"集团地址：%@",self.compEntity.address];
            cell.GroupType.text = [NSString stringWithFormat:@"集团类型：%@",[self setLevel:self.compEntity.company_level]];
            
            cell.Cooperation_situation.text = [NSString stringWithFormat:@"目前合作情况：%@",_Cooperation_situation];
            cell.Cooperation_difficulties.text = [NSString stringWithFormat:@"目前合作困难：%@",_Cooperation_difficulties];
            
            NSString *company_staty;
            if ([self.compEntity.company_status isEqualToString:@"0"]) {
                company_staty = @"正使用集团客户";
            }else{
                company_staty = @"未开户集团客户";
            }
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"集团状态：%@",company_staty]];
            
            [str addAttribute:NSForegroundColorAttributeName value:RGBA(52, 160, 213, 1) range:NSMakeRange(5, str.length - 5)];
            
            cell.GroupState.attributedText = str;
            
            return cell;
        }else{
            static NSString *couponTableViewCellIdentifier=@"New_groupTableViewCell";
            New_groupTableViewCell *cell = (New_groupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
            
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"New_groupTableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
                
                cell.bgView.layer.cornerRadius = 5;
                cell.bgView.layer.borderWidth = 1;
                cell.bgView.layer.borderColor = RGBA(219, 219, 219, 1).CGColor;
                
                cell.GroupName.font = [UIFont systemFontOfSize:15];
                cell.GroupNum.font = [UIFont systemFontOfSize:15];
                cell.GroupState.font = [UIFont systemFontOfSize:15];
                cell.GroupAddress.font = [UIFont systemFontOfSize:15];
                cell.GroupType.font = [UIFont systemFontOfSize:15];
                
                cell.GroupName.textColor = RGBA(120, 120, 120, 1);
            }
            
            cell.GroupName.text = [NSString stringWithFormat:@" 产品名称：贵州省国土资源厅"];
            cell.GroupNum.text = [NSString stringWithFormat:@" 合同系列号：JT5415415-151545"];
            cell.GroupState.text = [NSString stringWithFormat:@" 金   额：12000"];
            cell.GroupAddress.text = [NSString stringWithFormat:@" 生效时间：2015-9-25"];
            cell.GroupType.text = [NSString stringWithFormat:@" 失效时间：2020-9-25"];
            
            
            return cell;
        }

    }else{
        
        static NSString *couponTableViewCellIdentifier=@"New_ContactsTableViewCell";
        New_ContactsTableViewCell *cell = (New_ContactsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
        
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"New_ContactsTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];

            cell.Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            cell.Btn.imageEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
            cell.Btn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        }
        
        ContactEntity *entity = [ContactsArr objectAtIndex:indexPath.row];
        
        cell.level.text =    [NSString stringWithFormat:@"级       别： %@",[entity.MemberLevel intValue] == 9?@"集团联系人":@"集团关键人"];
        cell.name.text =     [NSString stringWithFormat:@"姓       名： %@",entity.name];
        cell.position.text = [NSString stringWithFormat:@"职       位： %@",entity.job];
        cell.tel.text =      [NSString stringWithFormat:@"联系电话： %@",entity.tel];
        
        return cell;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![type isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) { //删除
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定要删除吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"删除", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex != alert.cancelButtonIndex) {
                
                HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                HUD.delegate = self;
                HUD.labelText = @"努力加载中...";
                CommonService *service = [[CommonService alloc] init];
                
                NSDictionary *dict;
                ContactEntity *entity = [ContactsArr objectAtIndex:indexPath.row];
                UserEntity *userEntity = [UserEntity sharedInstance];
                
                dict = @{
                         @"method":@"whole_province",
                         @"oicode":@"OI_UpdateGroupKeyManAndLinkManInfo",
                         @"user_id":userEntity.user_id,
                         @"OperType":@"2",
                         @"GroupId":self.compEntity.num,
                         @"MemUserId":entity.MemUserId,
                         };
                
                [service getNetWorkData:dict  Successed:^(id entity) {
                    NSNumber *state = [entity valueForKeyPath:@"state"];
                    NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
                    
                    if ([strState isEqualToString:@"1"] == YES) {
                        iToast *toast = [iToast makeText:@"删除成功！"];
                        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                        [toast setDuration:500];
                        [toast show:iToastTypeNotice];
                        [HUD hide:YES];
                        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        HUD.delegate = self;
                        HUD.labelText = @"努力加载中...";
                        [self getContactsData];
                        
                    }
                    else
                    {
                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    [HUD hide:YES];
                } Failed:^(int errorCode, NSString *message) {
                    
                    [HUD hide:YES];
                    iToast *toast = [iToast makeText:@"网络连接失败"];
                    [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                    [toast setDuration:500];
                    [toast show:iToastTypeNotice];
                }];
            }
        }];
        
        
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     if ([type isEqualToString:@"1"]) {
         
         if (indexPath.section == 0) {
             
             New_MyGroup_baseMessageViewController *vc = [[New_MyGroup_baseMessageViewController alloc]init];
             
             vc.name = self.name;
             
             vc.compEntity = self.compEntity;
             
             [self.navigationController pushViewController:vc animated:YES];
         }
         
     }else{
         
         ContactEntity *entity = [ContactsArr objectAtIndex:indexPath.row];
         
//         New_Contacts_MessageViewController *vc = [[New_Contacts_MessageViewController alloc]init];
//         
//         vc.name = self.name;
//         
//         vc.company_num = self.dic[@"num"];
//         
//         vc.entity = entity;
//         
//         [self.navigationController pushViewController:vc animated:YES];
         
        Coustomer_EditViewController *vc = [[Coustomer_EditViewController alloc]init];
         
        vc.entity = entity;
        vc.compEntity = _compEntity;
        
        [self.navigationController pushViewController:vc animated:YES];

     }

}

- (IBAction)change_State_Btn:(UIButton *)sender {
    
    [HUD hide:YES];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    if (sender.tag == 1) {
     
        type = @"1";
        
        [self getData];
        
        self.Btn_one.backgroundColor = RGBA(55, 174, 226, 1);
        [self.Btn_one setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.Btn_two.backgroundColor = [UIColor whiteColor];
        [self.Btn_two setTitleColor:RGBA(55, 174, 226, 1) forState:UIControlStateNormal];
        
        [self.tableView reloadData];
        
    }else if (sender.tag == 2){
        
        type = @"2";
        
        [self getContactsData];
        
        self.Btn_one.backgroundColor = [UIColor whiteColor];
        [self.Btn_one setTitleColor:RGBA(55, 174, 226, 1) forState:UIControlStateNormal];
        
        self.Btn_two.backgroundColor = RGBA(55, 174, 226, 1);
        [self.Btn_two setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.tableView reloadData];
    }
    
}

//获取集团的附加信息
- (void)getData{
    
    UserEntity *entity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = @{@"method":@"get_company_addition_info",
                            @"user_id":entity.user_id,
                            @"is_first":entity.is_first,
                            @"company_num":self.compEntity.num
                            };;
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            
        }else if([strState isEqualToString:@"2"] == YES){
            
            NSDictionary *dic = [entity objectForKey:@"content"];

            self.Cooperation_situation = [dic objectForKey:@"cp_cooperation_situation"];
            self.Cooperation_difficulties = [dic objectForKey:@"cp_cooperation_difficulties"];

            
        }else{
            
        }
        
        [self.tableView reloadData];
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
    
    
}

- (void)getContactsData{
    
    UserEntity *entity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = @{@"method":@"client_list",
                            @"company_num":self.compEntity.num,
                            @"user_num":[entity.is_first isEqual:@"1"]?self.compEntity.is_fist_UserNum:entity.num,
                            };
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            [ContactsArr removeAllObjects];
            for (NSDictionary* attributes in array) {
                ContactEntity *entity = [[ContactEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [ContactsArr addObject:entity];
            }
            [self.tableView reloadData];
            
        }
        else
        {
            
        }
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
    
    
}

- (void)subVCBackNeedRefresh:(id)sender
{

    [self getContactsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
