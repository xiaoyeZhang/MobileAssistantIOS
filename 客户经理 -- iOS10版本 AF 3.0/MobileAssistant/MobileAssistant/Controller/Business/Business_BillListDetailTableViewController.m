//
//  Business_BillListDetailTableViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/21.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_BillListDetailTableViewController.h"
#import "TxtFieldTableViewCell.h"
#import "LineTwoLabelTableViewCell.h"

@interface Business_BillListDetailTableViewController ()
{
    LineTwoLabelTableViewCell *cell1;
}
@end

@implementation Business_BillListDetailTableViewController

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
    
    self.title = @"账单信息详情";
    
    LogModule *logmodule = [[LogModule alloc]init];
    [logmodule Select_LogModule:NSStringFromClass([self class])];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {

        CGSize size = [cell1.subTitleLbl sizeThatFits:CGSizeMake(cell1.subTitleLbl.frame
                                                                 .size.width, MAXFLOAT)];
        if (size.height == 0) {
            return 44;
        }
        return size.height + 27;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"TxtFieldTableViewCell";
    static NSString *CellIdentifier2 = @"LineTwoLabelTableViewCell";
    
    TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.txtField.userInteractionEnabled = NO;
    switch (indexPath.row) {
        case 0:
        {
            cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if(!cell1)
            {
                cell1 = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier2 owner:nil options:nil] firstObject];
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell1.titLabel.text = @"账单名称：";
            cell1.subTitleLbl.layer.borderWidth = 0.5;
            cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
            cell1.subTitleLbl.layer.cornerRadius = 6;
            cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
            cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.entity.SubName];
            
            return cell1;
            break;
        }
        case 1:
        {
            cell.titleLbl.text = @"科目金额：";
//            cell.txtField.text = self.entity.SubFee;
            double yuan = [self.entity.SubFee doubleValue]/100.0;
            NSString *str = [NSString stringWithFormat:@"%0.2f",yuan];
            cell.txtField.text = [NSString stringWithFormat:@"%g元", [str doubleValue]];
            break;
        }
        case 2:
        {
            cell.titleLbl.text = @"详单优惠：";
//            cell.txtField.text = self.entity.XianDanYouHui;
            double yuan = [self.entity.XianDanYouHui doubleValue]/100.0;
            NSString *str = [NSString stringWithFormat:@"%0.2f",yuan];
            cell.txtField.text = [NSString stringWithFormat:@"%g元", [str doubleValue]];
            break;
        }
        case 3:
        {
            cell.titleLbl.text = @"账务优惠：";
//            cell.txtField.text = self.entity.ZhangWuYouhui;
            double yuan = [self.entity.ZhangWuYouhui doubleValue]/100.0;
            NSString *str = [NSString stringWithFormat:@"%0.2f",yuan];
            cell.txtField.text = [NSString stringWithFormat:@"%g元", [str doubleValue]];
            break;
        }
        case 4:
        {
            cell.titleLbl.text = @"调账金额：";
//            cell.txtField.text = self.entity.TiaoZhang;
            double yuan = [self.entity.TiaoZhang doubleValue]/100.0;
            NSString *str = [NSString stringWithFormat:@"%0.2f",yuan];
            cell.txtField.text = [NSString stringWithFormat:@"%g元", [str doubleValue]];
            break;
        }
        case 5:
        {
            cell.titleLbl.text = @"应收金额：";
//            cell.txtField.text = self.entity.YingShou;
            double yuan = [self.entity.YingShou doubleValue]/100.0;
            NSString *str = [NSString stringWithFormat:@"%0.2f",yuan];
            cell.txtField.text = [NSString stringWithFormat:@"%g元", [str doubleValue]];
            break;
        }
        default:
            break;
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
