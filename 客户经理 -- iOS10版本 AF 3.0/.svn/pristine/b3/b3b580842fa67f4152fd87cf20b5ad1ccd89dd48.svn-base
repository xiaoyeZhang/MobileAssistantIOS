//
//  Business_Group_V_Net_Contact_DetailTableViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/24.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_Group_V_Net_Contact_DetailTableViewController.h"
#import "LineTwoLabelTableViewCell.h"
#import "CommonService.h"
#import "MBProgressHUD.h"
#import "UIAlertView+Blocks.h"

@interface Business_Group_V_Net_Contact_DetailTableViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    LineTwoLabelTableViewCell *cell;
    NSMutableArray *detailMuArr;
}

@end

@implementation Business_Group_V_Net_Contact_DetailTableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;

//    UIButton *backBtn = [self setNaviCommonBackBtn];
//    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *deleteButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];

    self.navigationItem.rightBarButtonItem = deleteButtonItem;

    [self initData];
    self.title = @"成员信息";
    LogModule *module = [[LogModule alloc]init];
    [module Select_LogModule:NSStringFromClass([self class])];
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"集团名称：",     @"list":@"name"},
                   @{@"title":@"集团地址：",     @"list":@"address"},
                   @{@"title":@"V网名称：",     @"list":@"VpmnName"},
                   @{@"title":@"V网编号：",     @"list":@"VpmnId"},
                   @{@"title":@"用户编号：",     @"list":@"UserId"},
                   @{@"title":@"姓      名：",    @"list":@"MemberName"},
                   @{@"title":@"服务号码：",     @"list":@"ServiceNum"},
                   @{@"title":@"成员短号：",     @"list":@"ShortNum"},
                   @{@"title":@"部      门：",    @"list":@"Department"},
                   nil];
    
    [self.tableView reloadData];
}

- (void)deleteAction:(UIButton *)sender{
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.delegate = self;
            HUD.labelText = @"努力加载中...";
            
            CommonService *service = [[CommonService alloc] init];
            UserEntity *userEntity = [UserEntity sharedInstance];
            
            NSDictionary *dict1 = @{@"method":@"whole_province",
                                    @"oicode":@"OI_UpdateVpmnMember",
                                    @"user_id":userEntity.user_id,
                                    @"OperType":@"1",
                                    @"ServiceNum":self.entity.ServiceNum,
                                    @"VpmnId":self.Group_V_NetEntity.VpmnId,
                                    };

            [service getNetWorkData:dict1  Successed:^(id entity) {
                
                int state = [entity[@"state"] intValue];
                
                if (state == 1) {
                    NSDictionary *dic = entity[@"content"];
                   NSString *msg = [NSString stringWithFormat:@"受理成功,当前流水号:\n%@",[dic objectForKey:@"DoneCode"]];
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                    }];
                    
                }else if(state == -1){
                    ALERT_ERR_MSG(entity[@"msg"]);
                }
                [HUD hide:YES];
            } Failed:^(int errorCode, NSString *message) {
                [HUD hide:YES];
            }];
        }
        else{
            
        }
    }];
}

- (void)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [detailMuArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    CGFloat cellheight;
    cellheight = cell.subTitleLbl.layer.frame.size.height;
    CGSize size = [cell.subTitleLbl sizeThatFits:CGSizeMake(cell.subTitleLbl.frame
                                                             .size.width, MAXFLOAT)];
    if (size.height == 0) {
        return 44;
    }
    
    return size.height + 27;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LineTwoLabelTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dict = detailMuArr[indexPath.row];
    
    NSString *title = dict[@"title"];
    
    cell.titLabel.text = title;
    cell.subTitleLbl.layer.borderWidth = 0.5;
    cell.subTitleLbl.font = [UIFont systemFontOfSize:14];
    cell.subTitleLbl.layer.cornerRadius = 6;
    cell.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
    
    switch (indexPath.row) {
        case 0:
            cell.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.compEntity.name];
            break;
        case 1:
            cell.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.compEntity.address];
            break;
        case 2:
            
            cell.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.Group_V_NetEntity.VpmnName];
            break;
        case 3:
            
            cell.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.Group_V_NetEntity.VpmnId];
            break;
        case 4:
            cell.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.entity.UserId];
            break;
        case 5:
            cell.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.entity.MemberName];
            break;
        case 6:
            cell.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.entity.ServiceNum];
            break;
        case 7:
            cell.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.entity.ShortNum];
            break;
        case 8:
            cell.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.entity.Department];
            break;
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
