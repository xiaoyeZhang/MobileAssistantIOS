//
//  Product_Visit_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/20.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Product_Visit_DetailViewController.h"
#import "LineTwoLabelTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "Product_Visit_ActionViewController.h"
#import "DXAlertView.h"

@interface Product_Visit_DetailViewController ()
{
    NSMutableArray *dicArr;
    UserEntity *userEntiy;
}
@end

@implementation Product_Visit_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"产品经理走访";
    
    userEntiy = [UserEntity sharedInstance];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([userEntiy.type_id intValue]== ROLE_PRODUCT) {
    
        if ([self.entity.state isEqualToString:@"0"] == YES ) {
            UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"执行"];
            [submitBtn addTarget:self action:@selector(doActionTask:) forControlEvents:UIControlEventTouchUpInside];

        }else if ([self.entity.state isEqualToString:@"1"] == YES ) {
            UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"填写纪要"];
            submitBtn.frame = CGRectMake(0, 0, 100, 35);
            [submitBtn addTarget:self action:@selector(writeSummery:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }

    self.tableView.tableFooterView = [UIView new];
    
    dicArr = [NSMutableArray arrayWithObjects:
              @{@"title":@"产品及项目\n经理姓名：",    @"message":_entity.user_name},
              @{@"title":@"走访单位\n名称：",    @"message":_entity.company_name},
              @{@"title":@"陪同客户\n经理：", @"message":_entity.assis_user_name},
              @{@"title":@"走访对接人\n职务：", @"message":_entity.job},
              @{@"title":@"走访人姓名：", @"message":_entity.client_name},
              @{@"title":@"走访事宜：", @"message":_entity.content},
              @{@"title":@"走访日期：",@"message":_entity.time},
              
              nil];
    
    if ([self.entity.state isEqualToString:@"1"] == YES) {
        [dicArr addObject:@{@"title":@"经度：", @"message":_entity.lont}];
        [dicArr addObject:@{@"title":@"纬度：", @"message":_entity.lat}];
        [dicArr addObject:@{@"title":@"现场地址：", @"message":_entity.address}];
    }else if ([self.entity.state isEqualToString:@"2"] == YES){
        [dicArr addObject:@{@"title":@"经度：", @"message":_entity.lat}];
        [dicArr addObject:@{@"title":@"纬度：", @"message":_entity.lont}];
        [dicArr addObject:@{@"title":@"现场地址：", @"message":_entity.address}];
        [dicArr addObject:@{@"title":@"拜访纪要：", @"message":_entity.summary}];
        
        NSString *expectStr;
        if ([_entity.expect isEqualToString:@"0"]) {
            expectStr = @"否";
        }else if ([_entity.expect isEqualToString:@"1"]) {
            expectStr = @"是";
        }else{
            
        }
        
        [dicArr addObject:@{@"title":@"是否达到走访预期：", @"message":expectStr}];
    }
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dicArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"LineTwoLabelTableViewCell";
    LineTwoLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.titLabel.text = [[dicArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    cell.subTitleLbl.text = [[dicArr objectAtIndex:indexPath.row] objectForKey:@"message"];
    
    return cell;
}

- (void)doActionTask:(id)sender
{
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString* str=[NSString stringWithFormat:@"请退出客户经理，在【设置>隐私>相机>客户经理】授权相机访问"];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
//            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//    
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy"]];
//    
//            }];
//        
        [alert show];
        
        return;
    }else{
        Product_Visit_ActionViewController *vc = [[Product_Visit_ActionViewController alloc] init];
        vc.entity = self.entity;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}


- (void)writeSummery:(id)sender
{
    //[[LocationManagement sharedInstance] startUpdatingLocation];
    
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"填写纪要" summaryText:@"拜访纪要" qradioButton:@"是否达到\n走访预期" leftButtonTitle:@"提交" rightButtonTitle:@"取消"];

    alert.Pro_visitVC = self;
    [alert show];
    alert.leftBlock = ^() {
        
        
        if ([self.strSummery isEqualToString:@""]){
            ALERT_ERR_MSG(@"拜访纪要不能为空");
            return;
        }else if ([self.expect isEqualToString:@""]){
            ALERT_ERR_MSG(@"请选择是否达到走访预期");
            return;
        }
        
        CommonService *service = [[CommonService alloc] init];
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.entity.visit_id, @"visit_id",
                               self.strSummery, @"summary",
                               self.expect, @"expect",
                               @"product_summary_write", @"method", nil];
        
        [service getNetWorkData:param  Successed:^(id entity) {
            NSNumber *state = [entity valueForKeyPath:@"state"];

            [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            
            if ([state intValue] > 0) {
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"填写纪要成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"填写纪要失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } Failed:^(int errorCode, NSString *message) {
            
        }];
    };
    alert.rightBlock = ^() {
        NSLog(@"right button clicked");
    };
    alert.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (0 == buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"点击了确认按钮");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
