//
//  Business_ProductDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/17.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_ProductDetailViewController.h"
#import "TxtFieldTableViewCell.h"
#import "UIColor+Hex.h"
#import "LineTwoLabelTableViewCell.h"

@interface Business_ProductDetailViewController ()
{
    LineTwoLabelTableViewCell *cell1;
}
@end

@implementation Business_ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.title = @"产品属性详情";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
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
    
    cell1 = [tableView dequeueReusableCellWithIdentifier:@"LineTwoLabelTableViewCell"];
    if(!cell1)
    {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:@"LineTwoLabelTableViewCell" owner:nil options:nil] firstObject];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.txtField.userInteractionEnabled = NO;
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLbl.text = @"属性编号：";
            cell.txtField.placeholder = nil;
            if (![[self.AttrInstInfoDic objectForKey:@"AttrId"] isKindOfClass:[NSNull class]]) {
                cell.txtField.text = [self.AttrInstInfoDic objectForKey:@"AttrId"];
            }
            else{
                cell.txtField.text = @"";
            }
            
            break;
        }
        case 1:
        {
            
            cell1.titLabel.text = @"属性名称：";
            cell1.subTitleLbl.layer.borderWidth = 0.5;
            cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
            cell1.subTitleLbl.layer.cornerRadius = 6;
            cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
            if (![[self.AttrInstInfoDic objectForKey:@"AttrName"] isKindOfClass:[NSNull class]]) {
                cell1.subTitleLbl.text = [NSString stringWithFormat:@"%@",[self.AttrInstInfoDic objectForKey:@"AttrName"]];
            }
            else{
                cell1.subTitleLbl.text = @"";
            }
            return cell1;
            break;
        }
//        case 2:
//        {
//            
//            cell1 = [tableView dequeueReusableCellWithIdentifier:@"LineTwoLabelTableViewCell"];
//            if(!cell1)
//            {
//                cell1 = [[[NSBundle mainBundle] loadNibNamed:@"LineTwoLabelTableViewCell" owner:nil options:nil] firstObject];
//                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            cell1.titLabel.text = @"属性描述：";
//            cell1.subTitleLbl.layer.borderWidth = 0.5;
//            cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
//            cell1.subTitleLbl.layer.cornerRadius = 6;
//            cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
//            
//            if (![[self.AttrInstInfoDic objectForKey:@"AttrDesc"] isKindOfClass:[NSNull class]]) {
//                cell1.subTitleLbl.text = [self.AttrInstInfoDic objectForKey:@"AttrDesc"];
//            }
//            else{
//                cell1.subTitleLbl.text = @"";
//            }
//            return cell1;
//            break;
//        }
        case 2:
        {
//            cell.titleLbl.text = @"属 性 值：";
//            cell.txtField.placeholder = nil;
//            if (![[self.AttrInstInfoDic objectForKey:@"AttrValue"] isKindOfClass:[NSNull class]]) {
//                cell.txtField.text = [self.AttrInstInfoDic objectForKey:@"AttrValue"];
//            }
//            else{
//                cell.txtField.text = @"";
//            }
//   
            cell1.titLabel.text = @"属 性 值：";
            cell1.subTitleLbl.layer.borderWidth = 0.5;
            cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
            cell1.subTitleLbl.layer.cornerRadius = 6;
            cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
            
            if (![[self.AttrInstInfoDic objectForKey:@"AttrValue"] isKindOfClass:[NSNull class]]) {
                cell1.subTitleLbl.text = [NSString stringWithFormat:@"%@",[self.AttrInstInfoDic objectForKey:@"AttrValue"]];
            }
            else{
                cell1.subTitleLbl.text = @"";
            }
            return cell1;
            
            break;
        }
        case 3:
        {
//            cell.titleLbl.text = @"属性值描述：";
//            cell.txtField.placeholder = nil;
//            if (![[self.AttrInstInfoDic objectForKey:@"AttrTxt"] isKindOfClass:[NSNull class]]) {
//                cell.txtField.text = [self.AttrInstInfoDic objectForKey:@"AttrTxt"];
//            }
//            else{
//                cell.txtField.text = @"";
//            }
            
            cell1.titLabel.text = @"属性值描述：";
            cell1.subTitleLbl.layer.borderWidth = 0.5;
            cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
            cell1.subTitleLbl.layer.cornerRadius = 6;
            cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
            
            if (![[self.AttrInstInfoDic objectForKey:@"AttrTxt"] isKindOfClass:[NSNull class]]) {
                cell1.subTitleLbl.text = [NSString stringWithFormat:@"%@",[self.AttrInstInfoDic objectForKey:@"AttrTxt"]];
            }
            else{
                cell1.subTitleLbl.text = @"";
            }
            
            return cell1;
            
            break;
        }
        case 4:
        {
            cell.titleLbl.text = @"受理编号：";
            cell.txtField.placeholder = nil;
            if (![[self.AttrInstInfoDic objectForKey:@"DoneCode"] isKindOfClass:[NSNull class]]) {
                cell.txtField.text = [self.AttrInstInfoDic objectForKey:@"DoneCode"];
            }
            else{
                cell.txtField.text = @"";
            }
            

            break;
        }
        case 5:
        {
            cell.titleLbl.text = @"受理日期：";
            cell.txtField.placeholder = nil;
            if (![[self.AttrInstInfoDic objectForKey:@"DoneDate"] isKindOfClass:[NSNull class]]) {
                cell.txtField.text = [self.AttrInstInfoDic objectForKey:@"DoneDate"];
            }
            else{
                cell.txtField.text = @"";
            }
  
            break;
        }
        case 6:
        {
            cell.titleLbl.text = @"生效日期：";
            NSString *EffectiveDate;
            if (![[self.AttrInstInfoDic objectForKey:@"EffectiveDate"] isKindOfClass:[NSNull class]]) {
                EffectiveDate= [self.AttrInstInfoDic objectForKey:@"EffectiveDate"];

                if (EffectiveDate.length != 0) {
                    if ([EffectiveDate rangeOfString:@"-"].location == NSNotFound) {
                        EffectiveDate=[NSString stringWithFormat:@"%@-%@-%@",
                                       [EffectiveDate substringWithRange:NSMakeRange(0, 4)],
                                       [EffectiveDate substringWithRange:NSMakeRange(4, 2)],
                                       [EffectiveDate substringWithRange:NSMakeRange(6, 2)]];
                    }
                }
                cell.txtField.text = EffectiveDate;

            }
            else{
                cell.txtField.text = @"";
            }
   
            break;
        }
        case 7:
        {
            cell.titleLbl.text = @"失效日期：";
            NSString *ExpireDate;
            if (![[self.AttrInstInfoDic objectForKey:@"ExpireDate"] isKindOfClass:[NSNull class]]) {
                
                ExpireDate= [self.AttrInstInfoDic objectForKey:@"ExpireDate"];
                
                if (ExpireDate.length != 0) {
                    if ([ExpireDate rangeOfString:@"-"].location == NSNotFound) {
                        ExpireDate=[NSString stringWithFormat:@"%@-%@-%@",
                                       [ExpireDate substringWithRange:NSMakeRange(0, 4)],
                                       [ExpireDate substringWithRange:NSMakeRange(4, 2)],
                                       [ExpireDate substringWithRange:NSMakeRange(6, 2)]];
                    }
                }
                cell.txtField.text = ExpireDate;
            }
            else{
                cell.txtField.text = @"";
            }
       
            break;
        }
        default:
            break;
    }
    
    return cell;
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
