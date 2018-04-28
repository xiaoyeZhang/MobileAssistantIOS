//
//  Arrears_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Arrears_DetailViewController.h"
#import "MBProgressHUD.h"
#import "LineTwoLabelTableViewCell.h"
#import "News_PtovinceVip_Next_CustomerEntity.h"
#import "DXAlertView.h"
#import "UIActionSheet+Block.h"

@interface Arrears_DetailViewController ()<MBProgressHUDDelegate>{
    
    LineTwoLabelTableViewCell *cell;
    UserEntity *userEntity;
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) NSDictionary *dicCutomer;
@property (strong, nonatomic) NSMutableArray *detailMuArr;
@property (strong, nonatomic) NSMutableArray *arrayCutomer;
@end

@implementation Arrears_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"欠费任务详情";
    
    userEntity = [UserEntity sharedInstance];
    self.arrayCutomer = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UITableView alloc]init];
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([userEntity.type_id intValue] == ROLE_CUSTOMER && [_entity.state intValue] == 0 && [_entity.do_flag intValue] == 1) {

        UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"延期"];
        [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }

    
    [self initData];
    
//    [self getData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitBtnClicked:(id)sender
{
    
    [self getData];
    
}

- (void)initData
{

    self.detailMuArr = [[NSMutableArray alloc] initWithObjects:
                        @{@"title":@"数据日期：",@"detail":_entity.time},
                        @{@"title":@"集团归属县市名称：",@"detail":_entity.area_name},
                        @{@"title":@"集团名称：",@"detail":_entity.company_name},
                        @{@"title":@"集团编号：",@"detail":_entity.company_num},
                        @{@"title":@"行业类别：",@"detail":_entity.type},
                        @{@"title":@"集团客户经理：",@"detail":_entity.user_name},
                        @{@"title":@"集团客户经理编号：",@"detail":_entity.user_num},
                        @{@"title":@"集团归属地市名称：",@"detail":_entity.city_name},
                        @{@"title":@"账号付费周期：",@"detail":_entity.cycle},
                        @{@"title":@"账号编号：",@"detail":_entity.acc_num},
                        @{@"title":@"当月欠费额：",@"detail":_entity.amount},
                        @{@"title":@"欠费月份：",@"detail":_entity.month},
                        @{@"title":@"欠费催缴标识：",@"detail":_entity.flag},
                        @{@"title":@"账号名称：",@"detail":_entity.acc_name},
                        @{@"title":@"账号编码：",@"detail":_entity.guest_num},
                        @{@"title":@"电话号码：",@"detail":_entity.tel},nil];
    
    if (_entity.state.length > 0) {
        
        NSString *stateStr = @"";
        //     0 未提交  1已提交  2审核通过  3审核不通过
        if ([_entity.state intValue] == 0) {
            stateStr = @"未提交";
        }else if ([_entity.state intValue] == 1){
            stateStr = @"已提交";
        }else if ([_entity.state intValue] == 2){
            stateStr = @"审核通过";
        }else if ([_entity.state intValue] == 3){
            stateStr = @"审核不通过";
        }
        
        [self.detailMuArr addObject:@{@"title":@"审核状态：",@"detail":stateStr}];
        
    }
    
    if (_entity.reason.length > 0) {
        [self.detailMuArr addObject:@{@"title":@"延期理由：",@"detail":_entity.reason}];
        
    }
    
    if (_entity.suggestion.length > 0) {
        [self.detailMuArr addObject:@{@"title":@"处理意见：",@"detail":_entity.suggestion}];

    }

    if (_entity.infos.length > 0) {
        [self.detailMuArr addObject:@{@"title":@"审核流程：",@"detail":_entity.infos}];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailMuArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [cell.subTitleLbl sizeThatFits:CGSizeMake(cell.subTitleLbl.frame
                                                             .size.width, MAXFLOAT)];
    if (size.height == 0) {
        return 40;
    }
    return size.height + 28;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"LineTwoLabelTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.titLabel.text = self.detailMuArr[indexPath.row][@"title"];
    cell.subTitleLbl.layer.borderWidth = 0.5;
    cell.subTitleLbl.font = [UIFont systemFontOfSize:14];
    cell.subTitleLbl.layer.cornerRadius = 6;
    cell.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
    
    cell.subTitleLbl.textColor = [UIColor darkGrayColor];
    cell.subTitleLbl.text = self.detailMuArr[indexPath.row][@"detail"];
    
    return cell;
}

- (void)getData{

    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"m_arrearage_user_list" forKey:@"method"];
    [dict setObject:userEntity.user_id forKey:@"user_id"];
    [dict setObject:userEntity.dep_id forKey:@"dep_id"];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
   
            NSMutableArray *array = [entity objectForKey:@"content"];
            NSMutableArray *userArr = [NSMutableArray array];
            
            for (NSDictionary* attributes in array) {
                News_PtovinceVip_Next_CustomerEntity *entity = [[News_PtovinceVip_Next_CustomerEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
                [userArr addObject:entity.name];
            }
            
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"延期审批" user_list:@"下级处理人" summaryText:@"延期理由" rightTitle:@"确定"];
            __block typeof(NSInteger) Index;
            [alert show];
            __weak typeof(DXAlertView) *alertB = alert;
            alert.userBlock = ^{
              
                [UIActionSheet showInView:self.view
                                withTitle:@"下级处理人"
                        cancelButtonTitle:@"取消"
                   destructiveButtonTitle:nil
                        otherButtonTitles:userArr
                                 tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                     
                                     if (buttonIndex < userArr.count) {
                                         alertB.user_listTextfield.text = userArr[buttonIndex];
                                         Index = buttonIndex;
                                     }
                                     
                                 }];
                
            };

            alert.leftBlock = ^() {

                News_PtovinceVip_Next_CustomerEntity *entity = self.arrayCutomer[Index];
                
                [self submit:alertB.alertContentTextView.text next_processor:entity.user_id];
                
            };
            
        }else{
        
            
        }
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];

    }];
    
    
}

- (void)submit:(NSString *)reason next_processor:(NSString *)ID{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"m_arrearage_submit" forKey:@"method"];
    [dict setObject:_entity.arrearage_id forKey:@"arrearage_id"];
    [dict setObject:reason forKey:@"reason"];
    [dict setObject:ID forKey:@"next_processor"];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
//        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if (state > 0) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
            
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
