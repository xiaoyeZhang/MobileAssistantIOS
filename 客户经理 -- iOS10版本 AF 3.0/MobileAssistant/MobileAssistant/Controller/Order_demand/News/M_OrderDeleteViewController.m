//
//  M_OrderDeleteViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/5/24.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "M_OrderDeleteViewController.h"
#import "TxtFieldTableViewCell.h"
#import "AFNetworking.h"

@interface M_OrderDeleteViewController ()
{
    NSString *del_info;
    NSString *image_Name;
    UserEntity *userEntity;
}
@property (strong, nonatomic) NSMutableArray *listArr;

@end

@implementation M_OrderDeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"中止";
    
    userEntity = [UserEntity sharedInstance];
    
    self.listArr = [NSMutableArray array];
    self.uploadImagesNameArr = [NSMutableArray array];
    
    image_Name = @"";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.listArr addObject:@{@"title":@"备注",@"type":@"0",@"message":@""}];
    [self.listArr addObject:@{@"title":@"附件",@"type":@"1",@"message":@""}];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提交
- (void)submitBtnClicked:(id)sender
{

    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    if (del_info.length == 0) {
        ALERT_ERR_MSG(@"请填写中止备注");
        isDone = YES;
        return;
    }
    
    if (_uploadImagesArr.count == 0) {
        ALERT_ERR_MSG(@"请上传附件");
        isDone = YES;
        return;
    }
//    del_attch：附件文件名;号隔开
//    
//    del_info：删除备注
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"m_order_delete",
                           @"user_id":userEntity.user_id,
                           @"order_id":_order_id,
                           @"del_attch":image_Name,
                           @"del_info":del_info
                           };

    [service getNetWorkData:dict Successed:^(id entity) {

        NSNumber *state = [entity valueForKeyPath:@"state"];

        if ([state intValue] != 0) {

            if (self.uploadImagesArr.count != 0) {
                for (int i = 0; i < [self.uploadImagesArr count]; i++) {
                    
                     [self uploadImagesWithIndex:i];
                    
                }
            }
            
        }else{

             ALERT_ERR_MSG(@"删除失败");
        }

    } Failed:^(int errorCode, NSString *message) {
        
    }];
}

- (void)uploadImagesWithIndex:(int)index
{
    if (![self.uploadImagesArr[index] isKindOfClass:[UIImage class]]) {
        return;
    }
    
    NSString *imageName = _uploadImagesNameArr[index];
    //    NSData *imageData = UIImageJPEGRepresentation(self.uploadImagesArr[index], 0.5f);
    
    NSDictionary *dict = @{@"method":@"common_upload",
                           @"picname":imageName,
                           @"upload_type":@"m_order",
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];//初始化请求对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置服务器允许的请求格式内容
    
    //上传图片/文字，只能同POST
    
    [manager POST:BASEURL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //对于图片进行压缩
        NSData *data = UIImageJPEGRepresentation(self.uploadImagesArr[index],0.5);
        //NSData *data = UIImagePNGRepresentation(image);
        //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
        [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%@",imageName] mimeType:@"image/jpg"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"responseObject = %@, task = %@",responseObject,task);
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[obj objectForKey:@"state"] intValue]== 1) {
            if (index < self.uploadImagesArr.count-1) {
                
                [self uploadImagesWithIndex:index+1];
            }else{
                
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                
            }
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    return _listArr.count;

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
    
    cell.txtField.tag = indexPath.row;
    cell.txtField.returnKeyType = UIReturnKeyDone;
    [cell.txtField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    cell.titleLbl.text = [[_listArr objectAtIndex:indexPath.row] objectForKey:@"title"];

    if([[[_listArr objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"1"]){
        
        cell.txtField.placeholder = @"请上传合同相关资料";
        cell.txtField.text = self.uploadImagesArr.count>0?@"查看上传资料":nil;
    }else{
        
        cell.txtField.placeholder = @"";
        cell.txtField.text = del_info;
    }
    
    return cell;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSString *type_id = [[_listArr objectAtIndex:textField.tag] objectForKey:@"type"];
    
    if ([type_id isEqualToString:@"0"]) {
        
        return YES;
        
    }else if ([type_id isEqualToString:@"1"]){
        
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
    NSString *type_id = [[_listArr objectAtIndex:textField.tag] objectForKey:@"type"];

    if ([type_id isEqualToString:@"0"]) {
        
        del_info = textField.text;
    }

}

- (void)addPhotoViewController:(P_AddPhotoViewController *)vc didSelectImages:(NSArray *)imagesArr{
    
    
    self.uploadImagesArr = imagesArr;
    
    for (int i = 0 ; i < imagesArr.count; i++) {
        
        NSString *str = [NSString stringWithFormat:@"%@.jpg",[[NSUUID UUID] UUIDString]];
        
        image_Name = [image_Name stringByAppendingFormat:@"%@;",str];
        
        [self.uploadImagesNameArr addObject:str];
        
    }
    if (image_Name.length > 0) {
        
        image_Name = [image_Name substringToIndex:image_Name.length-1];
        
    }
    
    [_tableView reloadData];
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
