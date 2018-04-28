//
//  Management_business_ListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/1/23.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "Management_business_ListViewController.h"
#import "ThreeLabelsTableViewCell.h"
#import "TxtFieldTableViewCell.h"
#import "UIActionSheet+Block.h"

@interface Management_business_ListViewController ()<UITextFieldDelegate>
{
    NSMutableArray *devicesMuArr;
    NSInteger Rows;
}
@property(nonatomic, copy) NSString *opportunity_type;
@property(nonatomic, copy) NSString *opportunity_content;
@property(nonatomic, copy) NSString *opportunity_strength;

@property(nonatomic, copy) NSString *selectedDevice;
@end

@implementation Management_business_ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加商机";
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *arr = [self.device_info componentsSeparatedByString:@";"];
    devicesMuArr = [[NSMutableArray alloc] initWithArray:arr];
}

//返回
- (void)backBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(Management_business_ListViewController:addInfo:)]) {
        [self.delegate Management_business_ListViewController:self addInfo:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - UIButtonMethod

- (void)submitBtnClicked:(id)sender
{
    if (devicesMuArr.count == 0) {

        ALERT_ERR_MSG(@"填写的商机数据不能为空");
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(Management_business_ListViewController:addInfo:)]) {
        NSString *info = [devicesMuArr componentsJoinedByString:@";"];
        
        [self.delegate Management_business_ListViewController:self addInfo:info];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (section == 0) {
        Rows = 4;
        rows = 4;
    }else{
        rows = devicesMuArr.count+1;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier1 = @"TxtFieldTableViewCell";
    static NSString *identifier2 = @"AddCell";
    static NSString *identifier3 = @"ThreeLabelsTableViewCell";
    
    if (indexPath.section == 0) {
        if (indexPath.row != Rows- 1) {
            
            TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
                cell.txtField.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.indexPath = indexPath;
            cell.txtField.tag = indexPath.row;
            
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.titleLbl.text = @"商机类型";
                    cell.txtField.text = self.opportunity_type;
                    cell.txtField.placeholder = @"请选择商机类型";
                    break;
                }
                case 1:
                {
                    cell.titleLbl.text = @"商机主要内容";
                    cell.txtField.text = self.opportunity_content;
                    break;
                }
                case 2:
                {
                    cell.titleLbl.text = @"用户意向强度";
                    cell.txtField.text = self.opportunity_strength;
                    cell.txtField.placeholder = @"用户意向强度";
                    break;
                }

                default:
                    break;
            }
            
//            if (indexPath.row == 1 | indexPath.row == 3) {
//                cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
//            }else{
//                cell.txtField.keyboardType = UIKeyboardTypeDefault;
//            }
            
            return cell;
            
        }else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:identifier2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                [btn setTitle:@"添加" forState:UIControlStateNormal];
                btn.frame = CGRectMake(0, 0, 100, 30);
                btn.center = cell.contentView.center;
                btn.tag = -1;
                [btn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
            }
            
            UIButton *btn = (UIButton *)[cell.contentView viewWithTag:-1];
            
            if (self.selectedDevice.length > 0) {
                [btn setTitle:@"保存" forState:UIControlStateNormal];
            }else{
                [btn setTitle:@"添加" forState:UIControlStateNormal];
            }
            
            return cell;
        }
    }else{
        ThreeLabelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 0) {
            cell.leftLbl.text = @"商机类型";
            cell.middleLbl.text = @"商机主要内容";
            cell.rightLbl.text = @"用户意向强度";

        }else{
            NSString *deviceStr = devicesMuArr[indexPath.row-1];
            
            NSArray *infoArr = [deviceStr componentsSeparatedByString:@","];
            if (infoArr.count == 3 | infoArr.count == 4) {
                cell.leftLbl.text = infoArr[0];
                cell.middleLbl.text = infoArr[1];
                cell.rightLbl.text = infoArr[2];
            }
        }
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row > 0) {
        
        NSString *deviceStr = devicesMuArr[indexPath.row-1];
        
        self.selectedDevice = deviceStr;
        
        NSArray *infoArr = [deviceStr componentsSeparatedByString:@","];
        
        if (infoArr.count >= 3) {
            self.opportunity_type = infoArr[0];
            self.opportunity_content = infoArr[1];
            self.opportunity_strength = infoArr[2];
        }
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                 withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row > 0) {
        return YES;
    }else{
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) { //删除
        
        [devicesMuArr removeObjectAtIndex:indexPath.row-1];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
        self.opportunity_type = textField.text;
    }else if (textField.tag == 1){
        
        self.opportunity_content = textField.text;
        self.opportunity_content = [self.opportunity_content stringByReplacingOccurrencesOfString:@";" withString:@"；"];
        
    }else if (textField.tag == 2){
        self.opportunity_strength = textField.text;
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if (textField.tag == 0) {
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"商机类型"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"产品类",@"ICT项目",@"话费活动类",@"终端活动类",@"竞争对手信息"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                                 
                                 if (buttonIndex == 0) {
                                     textField.text = @"产品类";
                                 }else if(buttonIndex == 1){
                                     textField.text = @"ICT项目";
                                 }else if(buttonIndex == 2){
                                     textField.text = @"话费活动类";
                                 }else if(buttonIndex == 3){
                                     textField.text = @"终端活动类";
                                 }else if(buttonIndex == 4){
                                     textField.text = @"竞争对手信息";
                                 }
                                 self.opportunity_type = textField.text;
                             }
                             
                         }];
        
        return NO;
    }else if (textField.tag == 2){
        [self.view endEditing:YES];
        [UIActionSheet showInView:self.view
                        withTitle:@"用户意向强度"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"高",@"中",@"低",@"招标"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                                 
                                 if (buttonIndex == 0) {
                                     textField.text = @"高";
                                 }else if(buttonIndex == 1){
                                     textField.text = @"中";
                                 }else if(buttonIndex == 2){
                                     textField.text = @"低";
                                 }else if(buttonIndex == 3){
                                     textField.text = @"招标";
                                 }
                                 self.opportunity_strength = textField.text;
                             }
                             
                         }];
        
        return NO;
        
    }else{
        
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark -

- (void)addBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *msg = nil;
    if (self.opportunity_type.length == 0) {
        msg = @"商机类型不能为空";
        

    }else if (self.opportunity_content.length == 0){
        msg = @"商机主要内容不能为空";
        

    }else if (self.opportunity_strength.length == 0){
        msg = @"用户意向强度不能为空";

    }
    
    if (msg) {
        ALERT_ERR_MSG(msg);
        
        return;
    }
    
    //过滤分隔符
    self.opportunity_type = [self.opportunity_type stringByReplacingOccurrencesOfString:@"," withString:@" "];
    self.opportunity_type = [self.opportunity_type stringByReplacingOccurrencesOfString:@";" withString:@" "];
    
    self.opportunity_content = [self.opportunity_content stringByReplacingOccurrencesOfString:@"," withString:@" "];
    self.opportunity_content = [self.opportunity_content stringByReplacingOccurrencesOfString:@";" withString:@" "];
    
    self.opportunity_strength = [self.opportunity_strength stringByReplacingOccurrencesOfString:@"," withString:@" "];
    self.opportunity_strength = [self.opportunity_strength stringByReplacingOccurrencesOfString:@";" withString:@" "];

//    NSArray *infoarr = [self.device_info componentsSeparatedByString:@";"];
//
    NSArray *arr;
//
//    if (infoarr.count > 0) {
//
//        arr = [NSArray arrayWithObjects:self.deviceType,self.deviceCount,self.deviceColor,self.deviceNum, nil];
//
//    }else{
//
        arr = [NSArray arrayWithObjects:self.opportunity_type,self.opportunity_content,self.opportunity_strength, nil];
//    }
//
    NSString *info = [arr componentsJoinedByString:@","];

    if (self.selectedDevice) {
        NSInteger index = [devicesMuArr indexOfObject:self.selectedDevice];

        [devicesMuArr replaceObjectAtIndex:index withObject:info];
    }else{
        [devicesMuArr addObject:info];
    }
    
    
    //重置数据
    self.opportunity_type = nil;
    self.opportunity_content = nil;
    self.opportunity_strength = nil;
    
    self.selectedDevice = nil;
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
