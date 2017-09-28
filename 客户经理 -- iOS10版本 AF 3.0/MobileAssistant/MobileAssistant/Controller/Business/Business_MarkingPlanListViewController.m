//
//  Business_MarkingPlanListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/17.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_MarkingPlanListViewController.h"
#import "TxtFieldTableViewCell.h"
#import "UIColor+Hex.h"
#import "Business_ProdInstInfoViewController.h"
#import "Business_AttrInstInfoViewController.h"
#import "LineTwoLabelTableViewCell.h"
@interface Business_MarkingPlanListViewController ()
{
    LineTwoLabelTableViewCell *cell1;
}
@end

@implementation Business_MarkingPlanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self select_logmodel:NSStringFromClass([self class])];
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"营销活动信息详情";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        CGFloat cellheight;
        cellheight = cell1.subTitleLbl.layer.frame.size.height;
        CGSize size = [cell1.subTitleLbl sizeThatFits:CGSizeMake(cell1.subTitleLbl.frame
                                                                 .size.width, MAXFLOAT)];
        
        if (size.height == 0) {
            return 44;
        }
        return size.height + 27;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier1 = @"TxtFieldTableViewCell";
    TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.txtField.tag = indexPath.row;
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLbl.text = @"策划编号：";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.entity.OfferId;
            break;
        }
        case 1:
        {
//            cell.titleLbl.text = @"策划名称：";
//            cell.txtField.placeholder = nil;
//            cell.txtField.text = self.entity.OfferName;
            
            cell1 = [tableView dequeueReusableCellWithIdentifier:@"LineTwoLabelTableViewCell"];
            if(!cell1)
            {
                cell1 = [[[NSBundle mainBundle] loadNibNamed:@"LineTwoLabelTableViewCell" owner:nil options:nil] firstObject];
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell1.titLabel.text = @"套餐名称：";
            cell1.subTitleLbl.layer.borderWidth = 0.5;
            cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
            cell1.subTitleLbl.layer.cornerRadius = 6;
            cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
            cell1.subTitleLbl.text = self.entity.OfferName;

            return cell1;
            
            break;
        }
//        case 2:
//        {
//            cell.titleLbl.text = @"资费价格：";
//            cell.txtField.placeholder = nil;
//            cell.txtField.text = self.entity.Price;
//            break;
//        }
        case 2:
        {
            cell.titleLbl.text = @"策划类型：";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.entity.OfferType;
            break;
        }
        case 3:
        {
            cell.titleLbl.text = @"计费类型：";
            cell.txtField.placeholder = nil;
            NSString *billingType;
            if (![self.entity.BillingType isKindOfClass:[NSNull class]]) {
                if ([self.entity.BillingType isEqualToString:@"0"]) {
                    billingType = @"免费";
                }else if ([self.entity.BillingType isEqualToString:@"1"]){
                    billingType = @"按条计费";
                }else if ([self.entity.BillingType isEqualToString:@"2"]){
                    billingType = @"包月计费";
                }else if ([self.entity.BillingType isEqualToString:@"3"]){
                    billingType = @"包时计费";
                }else if ([self.entity.BillingType isEqualToString:@"4"]){
                    billingType = @"包次计费";
                }else if ([self.entity.BillingType isEqualToString:@"5"]){
                    billingType = @"按照栏目包月";
                }else{
                    
                }
            }else{
                billingType = @"";
            }
            cell.txtField.text = billingType;
            break;
        }
//        case 5:
//        {
//            cell.titleLbl.text = @"操作类型：";
//            cell.txtField.placeholder = nil;
//            
//            NSString *OperType;
//            if (![self.entity.OperType isKindOfClass:[NSNull class]]) {
//                
//                if ([self.entity.OperType isEqualToString:@"0"] == YES) {
//                    OperType = @"订购";
//                }else if ([self.entity.OperType isEqualToString:@"1"]){
//                    OperType = @"退订";
//                }else if ([self.entity.OperType isEqualToString:@"2"]){
//                    OperType = @"变更";
//                }else{
//                    
//                }
//            }else{
//                OperType = @"";
//            }
//            cell.txtField.text = OperType;
//            break;
//        }
        case 4:
        {
            cell.titleLbl.text = @"生效类型：";
            NSString *EffectiveType;
            if (![self.entity.EffectiveType isKindOfClass:[NSNull class]]) {
                if ([self.entity.EffectiveType isEqualToString:@"0"]) {
                    EffectiveType = @"立即生效";
                }else if ([self.entity.EffectiveType isEqualToString:@"1"]){
                    EffectiveType = @"下周期生效";
                }else if ([self.entity.EffectiveType isEqualToString:@"2"]){
                    EffectiveType = @"指定生效";
                }else{
                    
                }
                
            }else{
                EffectiveType = @"";
            }
            
            cell.txtField.text = EffectiveType;
            break;
        }
        case 5:
        {
            cell.titleLbl.text = @"生效日期：";
            NSString *EffectiveType;
            if (self.entity.EffectiveDate.length != 0) {
                EffectiveType=[NSString stringWithFormat:@"%@-%@-%@",
                               [self.entity.EffectiveDate substringWithRange:NSMakeRange(0, 4)],
                               [self.entity.EffectiveDate substringWithRange:NSMakeRange(4, 2)],
                               [self.entity.EffectiveDate substringWithRange:NSMakeRange(6, 2)]];
            }
            cell.txtField.text = EffectiveType;
            break;
        }
        case 6:
        {
            cell.titleLbl.text = @"失效日期：";
            NSString *ExpireDate;
            if (self.entity.ExpireDate.length != 0) {
                ExpireDate=[NSString stringWithFormat:@"%@-%@-%@",
                            [self.entity.ExpireDate substringWithRange:NSMakeRange(0, 4)],
                            [self.entity.ExpireDate substringWithRange:NSMakeRange(4, 2)],
                            [self.entity.ExpireDate substringWithRange:NSMakeRange(6, 2)]];
            }
            cell.txtField.text = ExpireDate;
            break;
        }
        case 7:
        {
            cell.titleLbl.text = @"产品属性：";
            cell.txtField.placeholder = nil;
            if ([self.entity.AttrInstInfo count] > 0) {
                 cell.txtField.text = @"查看产品属性";
            }
            else{
                 cell.txtField.text = @"暂无";
                 cell.txtField.userInteractionEnabled = NO;
            }
            cell.txtField.textColor = RGBA(29, 98, 254, 1);
            break;
           
        }
        case 8:
        {
            cell.titleLbl.text = @"实例信息：";
            cell.txtField.placeholder = nil;
            if ([self.entity.ProdInstInfo count] > 0) {
                cell.txtField.text = @"查看产品实例信息";
                
            }
            else{
                cell.txtField.text = @"暂无";
                cell.txtField.userInteractionEnabled = NO;
            }
            
            cell.txtField.textColor = RGBA(29, 98, 254, 1);
            break;
        }
        default:
            break;
    }

    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if (textField.tag == 7){
        
        Business_AttrInstInfoViewController *vc = [[Business_AttrInstInfoViewController alloc]init];
        vc.AttrInstInfo = self.entity.AttrInstInfo;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    
    }else if (textField.tag == 8){
        
        Business_ProdInstInfoViewController *vc = [[Business_ProdInstInfoViewController alloc]init];
        vc.ProdInstInfo = self.entity.ProdInstInfo;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;

    }
    else{
        return NO;
    }
    return YES;
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
