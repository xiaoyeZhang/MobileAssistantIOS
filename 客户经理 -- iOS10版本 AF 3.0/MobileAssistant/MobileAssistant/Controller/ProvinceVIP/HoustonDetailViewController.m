//
//  HoustonDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "HoustonDetailViewController.h"
#import "P_AddPhotoViewController.h"
#import "AFNetworking.h"
#import "Houston_querySubmitViewController.h"
#import "ImagesBrowserViewController.h"

@interface HoustonDetailViewController ()<AddPhotoViewControllerDelegate>

@property (strong, nonatomic) NSString *money;
@end

@implementation HoustonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"进账查询";
    
    self.submitState = PROCESS_STATE_responded_VISIT;
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"客户经理",         @"list":@"user_name",             @"type":@"Label"},
                   @{@"title":@"集团单位",         @"detail":@"customer_name",       @"type":@"Label"},
                   @{@"title":@"进账时间",         @"detail":@"Houston_time",       @"type":@"Label"},
                   @{@"title":@"金       额",     @"detail":@"Houston_money",       @"type":@"Label"},
                   @{@"title":@"备       注",     @"detail":@"remarks",      @"type":@"Label"},
                   @{@"title":@"入账金额",       @"process":@"remark",      @"type":@"Label"},
                   @{@"title":@"附      件",@"type":@"Btn"},
                   @{@"title":@"状       态",     @"process":@"state",             @"type":@"Label"},
                   nil];
    
//    @{@"title":@"审       核",    @"type":@"Check"},
//    @{@"title":@"附件上传",        @"list":@"picname",               @"type":@"Btn"},
    
    [_tableView reloadData];
}

- (void)reloadSubmitData
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    int state = [self.bListModel.state intValue];
    
    if (state == PROCESS_STATE_reject ) { //被驳回
        
        [detailMuArr removeObject:@{@"title":@"附      件",@"type":@"Btn"}];
        [detailMuArr removeObject:@{@"title":@"入账金额",       @"process":@"remark",      @"type":@"Label"}];
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            [self addEditBtn]; //添加编辑按钮
        }
        
        [_tableView reloadData];
        
        return;
    }
    
    if (state == PROCESS_STATE_manager_submit) { 
        
        [detailMuArr removeObject:@{@"title":@"附      件",@"type":@"Btn"}];
        [detailMuArr removeObject:@{@"title":@"入账金额",       @"process":@"remark",      @"type":@"Label"}];

    }
//    NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
//                       @{@"title":@"入账金额",@"type":@"Input",@"placeholder":@"请输入入账金额"},
//                       @{@"title":@"附件上传", @"type":@"Input", @"placeholder":@"请上传附件"},];
//    
//    [detailMuArr addObjectsFromArray:array];
    
    if (state == PROCESS_STATE_manager_submit &&
        ([userInfo.type_id intValue] == ROLE_COMMON)) { //客户经理已提交 -> 三级经理审核
        
        [detailMuArr removeObject:@{@"title":@"附      件",@"type":@"Btn"}];
        [detailMuArr removeObject:@{@"title":@"入账金额",       @"process":@"remark",      @"type":@"Label"}];
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"入账金额",@"type":@"Input",@"placeholder":@"请输入入账金额"},
                           @{@"title":@"附件上传", @"type":@"Input", @"placeholder":@"请上传附件"},
                           @{@"title":@"处理意见", @"type":@"Input", @"placeholder":@"请填写处理意见"},];
//        NSArray *array = @[@{@"title":@"附      件",@"type":@"Btn"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //客响中心已审核
            self.submitState = PROCESS_STATE_three_manager_through;
        }
        
        [self addSubmitBtn];
    }

    [_tableView reloadData];
}

- (void)submitBtnClicked:(id)sender
{
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    int state = [self.bListModel.state intValue];
    
    if (state == PROCESS_STATE_manager_submit && self.money.length == 0 && self.submitState == PROCESS_STATE_responded_VISIT) {
        ALERT_ERR_MSG(@"请填写入账金额");
        isDone = YES;
        return;
    }
    
    if (state == PROCESS_STATE_manager_submit && self.submitDesc.length == 0 && self.submitState == PROCESS_STATE_reject) {
        ALERT_ERR_MSG(@"请填写处理意见");
        isDone = YES;
        return;
    }
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"state":@(self.submitState),
                           @"business_id":self.bListModel.business_id,
                           @"user_id":userInfo.user_id,
                           @"method":@"change_state",
                           @"next_processor":@"-1",
                           @"info":self.submitDesc?self.submitDesc:@"",
                           @"remark":self.money?self.money:@"",
                           };
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict Successed:^(id entity) {
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            
            if (self.uploadImagesArr.count != 0 && self.submitState == PROCESS_STATE_responded_VISIT) {
                
                [self uploadImagesWithIndex:0 withBusinessId:self.bListModel.business_id];
                
            }else{
                
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                }];
            }
        }else{
            ALERT_ERR_MSG(@"提交失败");
        }
        isDone = YES;
    } Failed:^(int errorCode, NSString *message) {
        isDone = YES;
    }];
    
}

- (void)uploadImagesWithIndex:(int)index withBusinessId:(NSString *)tape_id
{
    if (![self.uploadImagesArr[index] isKindOfClass:[UIImage class]]) {
        return;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@",[[NSUUID UUID] UUIDString]];
    NSData *imageData = UIImageJPEGRepresentation(self.uploadImagesArr[index], 0.5f);

    NSDictionary *dict = @{@"method":@"common_upload",
                           @"business_id":self.bListModel.business_id,
                           @"picname":imageName,
                           @"upload_type":@"recorded",
                           @"file":imageData
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];//初始化请求对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置服务器允许的请求格式内容
    
    //上传图片/文字，只能同POST
    
    [manager POST:BASEURL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //对于图片进行压缩
        NSData *data = UIImageJPEGRepresentation(self.uploadImagesArr[index],0.5);
        //NSData *data = UIImagePNGRepresentation(image);
        //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
        [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",imageName] mimeType:@"image/jpg"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"responseObject = %@, task = %@",responseObject,task);
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[obj objectForKey:@"state"] intValue]== 1) {
            if (index < self.uploadImagesArr.count-1) {

                [self uploadImagesWithIndex:index+1 withBusinessId:tape_id];
            }else{
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {

                    [self.navigationController popViewControllerAnimated:YES];

                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                }];
            }
        }else{
//            ALERT_ERR_MSG(@"上传图片失败");
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"图片上传未成功，请返回列表删除工单后，重新提交" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
            
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    
    [super checkBoxTableViewCell:cell checkDidChanged:selectedIndex];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    int type = [userInfo.type_id intValue];
    
    if (selectedIndex == 1) {
        
        [detailMuArr removeObject:@{@"title":@"处理意见", @"type":@"Input", @"placeholder":@"请填写处理意见"}];
        
        NSArray *array = @[@{@"title":@"入账金额",@"type":@"Input",@"placeholder":@"请输入入账金额"},
                           @{@"title":@"附件上传", @"type":@"Input", @"placeholder":@"请上传附件"},
                           @{@"title":@"处理意见", @"type":@"Input", @"placeholder":@"请填写处理意见"},];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (state == PROCESS_STATE_manager_submit &&
            type == ROLE_COMMON) {
            
            self.submitState = PROCESS_STATE_responded_VISIT;
            
        }
    }else{
        self.submitState = PROCESS_STATE_reject;
        
        
        [detailMuArr removeObject:@{@"title":@"入账金额",@"type":@"Input",@"placeholder":@"请输入入账金额"}];
        [detailMuArr removeObject:@{@"title":@"附件上传", @"type":@"Input", @"placeholder":@"请上传附件"}];
    }
    
    [_tableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 8) {
        [self.view endEditing:YES];
        
        P_AddPhotoViewController *vc = [[P_AddPhotoViewController alloc] init];
        vc.imagesArr = self.uploadImagesArr;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%ld==-=---jdfhdjkshfksd",(long)textField.tag);
    
    if (textField.tag == 7) {
        
        self.money = textField.text;
        
    }else if (textField.tag == 9) {
        
       self.submitDesc = textField.text;
        
    }else{
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isMemberOfClass:[TxtFieldTableViewCell class]] && indexPath.row == 8) {
        TxtFieldTableViewCell *txtCell = (TxtFieldTableViewCell *)cell;
        
        txtCell.txtField.text = self.uploadImagesArr.count>0?@"查看上传资料":nil;
        
    }else if ([cell isMemberOfClass:[TxtFieldTableViewCell class]] && indexPath.row == 7) {
        TxtFieldTableViewCell *txtCell = (TxtFieldTableViewCell *)cell;
        
        txtCell.txtField.text = self.money;
        
    }
    
    return cell;
    
}

#pragma mark - AddPhotoViewControllerDelegate

- (void)addPhotoViewController:(P_AddPhotoViewController *)vc didSelectImages:(NSArray *)imagesArr{
    
    
    self.uploadImagesArr = imagesArr;
    [_tableView reloadData];
}

- (void)editBtnClicked:(id)sender
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    if ([self.bListModel.state intValue] == PROCESS_STATE_reject) { //被驳回
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            
            Houston_querySubmitViewController *vc = [[Houston_querySubmitViewController alloc] init];
            vc.detailDict = self.detailDict;
            vc.bListModel = self.bListModel;
//            if (self.bListModel.picname.length > 0) {
//                NSString *names = [self.bListModel.picname substringFromIndex:1];
//                if (names.length > 0) {
//                    vc.uploadImagesArr = [names componentsSeparatedByString:@","];
//                }
//                
//            }
            vc.typeNum = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return;
    }
}

- (void)btnTableViewCellBtnClicked:(id)sender
{
    
    if (![[self.detailDict objectForKey:@"recorded_image"] isEqualToString:@""]) {
        NSString *names = [[self.detailDict objectForKey:@"recorded_image"] substringFromIndex:1];
        if (names.length > 0) {
            NSArray *imagesNameArr = [names componentsSeparatedByString:@","];
            
            ImagesBrowserViewController *vc = [[ImagesBrowserViewController alloc] init];
            vc.imagesNameArray = imagesNameArr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
