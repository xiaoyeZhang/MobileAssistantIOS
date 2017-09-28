//
//  ProductLineSubmitViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/1/27.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "ProductLineSubmitViewController.h"
#import "UIActionSheet+Block.h"
#import "CustomerViewController.h"

@interface ProductLineSubmitViewController ()<UITextFieldDelegate,CustomerViewControllerDelegate>

///选择的公司对象
@property(nonatomic, strong) CompEntity *selectedComEntitiy;

///客户经理
@property(nonatomic, copy) NSString *account_manager;

///申请部门
@property(nonatomic, copy) NSString *application_department;

///故障描述
@property(nonatomic, copy) NSString *fault_description;

///集团单位
@property(nonatomic, copy) NSString *group_unit;

///集团编号
@property(nonatomic, copy) NSString *group_number;

///地址
@property(nonatomic, copy) NSString *address;

///客户姓名
@property(nonatomic, copy) NSString *customer_name;

///客户电话
@property(nonatomic, copy) NSString *customer_calls;

@property(nonatomic, copy) NSString *type_id;
@end

@implementation ProductLineSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专线/ims故障处理";
    self.type_id = @"19";
}

//提交
- (void)submitBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *msg = nil;
    if(self.fault_description.length == 0){
        msg = @"请填写故障描述";
    }else if (self.group_unit.length == 0){
        msg = @"请选择集团名称";
    }else if (self.address.length == 0){
        msg = @"请填写地址";
    }else if (self.customer_name.length == 0){
        msg = @"请填写客户姓名";
    }else if (self.customer_calls.length == 0){
        msg = @"请填写手机号";
    }
    
    if (msg) {
        ALERT_ERR_MSG(msg);
        
        return;
    }
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    NSDictionary *dict = @{@"method":@"submit_business",
                           @"create_id":userInfo.user_id,
                           @"title":self.group_unit,
                           @"type_id":self.type_id,
                           @"fault_description":self.fault_description,
                           @"company_name":self.group_unit,
                           @"company_num":self.group_number,
                           @"client_name":self.customer_name,
                           @"client_tel":self.customer_calls,
                           @"company_address":self.address,};
    
    CommonService *service = [[CommonService alloc] init];
    
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
        }else{
            ALERT_ERR_MSG(@"提交失败");
        }
        
    } Failed:^(int errorCode, NSString *message) {
        ALERT_ERR_MSG(message);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TxtFieldTableViewCell";
    
    TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.indexPath = indexPath;
    cell.txtField.tag = indexPath.row;
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLbl.text = @"客户经理:";
            cell.txtField.text = userInfo.name;
            
            break;
        }
        case 1:
        {
            cell.titleLbl.text = @"申请部门:";
            cell.txtField.text = userInfo.dep_name;
            break;
        }
        case 2:
        {
            cell.titleLbl.text = @"故障描述:";
            cell.txtField.text = self.fault_description;
            break;
        }
        case 3:
        {
            cell.titleLbl.text = @"集团单位:";
            cell.txtField.placeholder = @"请选择单位名称";
            cell.txtField.text = self.group_unit;
            break;
        }
        case 4:
        {
            cell.titleLbl.text = @"集团编号:";
            cell.txtField.text = self.group_number;
            break;
        }
        case 5:
        {
            cell.titleLbl.text = @"地       址:";
            cell.txtField.text = self.address;
            break;
        }
        case 6:
        {
            cell.titleLbl.text = @"客户姓名:";
            cell.txtField.text = self.customer_name;
            break;
        }
        case 7:
        {
            cell.titleLbl.text = @"客户电话:";
            cell.txtField.text = self.customer_calls;
            break;
        }
        default:
            break;
    }
    
    
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if (textField.tag == 0 |
        textField.tag == 1 |
        textField.tag == 4 ){
        return NO;
    }else if(textField.tag == 3){
        [self.view endEditing:YES];
        CustomerViewController *vc = [[CustomerViewController alloc] init];
        vc.enter_type = 1;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 2: //机主姓名
        {
            self.fault_description = textField.text;
            break;
        }
        case 5:
        {
            self.address = textField.text;
            break;
        }
        case 6:
        {
            self.customer_name = textField.text;
            break;
        }
        case 7:
        {
            self.customer_calls = textField.text;
            break;
        }

        default:
            break;
    }
}

- (void)customerViewController:(CustomerViewController *)vc didSelectCompany:(CompEntity *)entity
{
    self.group_unit = entity.name;
    self.group_number = entity.num;
    
    self.selectedComEntitiy = entity;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0],\
                                         [NSIndexPath indexPathForRow:4 inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
