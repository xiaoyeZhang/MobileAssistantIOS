//
//  P_AddDevicesViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/3.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_AddDevicesViewController.h"
#import "ThreeLabelsTableViewCell.h"

@interface P_AddDevicesViewController ()<UITextFieldDelegate>
{
    NSMutableArray *devicesMuArr;
    NSInteger Rows;
}
@property(nonatomic, copy) NSString *deviceType;
@property(nonatomic, copy) NSString *deviceCount;
@property(nonatomic, copy) NSString *deviceColor;
@property(nonatomic, copy) NSString *deviceNum;

@property(nonatomic, copy) NSString *selectedDevice;

@end

@implementation P_AddDevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"添加机型";
    if ([self.order_type isEqualToString:@"赠送礼品"]|
        [self.order_type isEqualToString:@"业务"]) {
        self.title = @"添加业务";
    }
    
    self.deviceCount = @"1";
    
    NSArray *arr = [self.device_info componentsSeparatedByString:@";"];
    devicesMuArr = [[NSMutableArray alloc] initWithArray:arr];
}

#pragma mark - UIButtonMethod

- (void)submitBtnClicked:(id)sender
{
    if (devicesMuArr.count == 0) {
        if ([self.order_type isEqualToString:@"赠送礼品"]|
            [self.order_type isEqualToString:@"业务"]) {
            ALERT_ERR_MSG(@"填写的业务数据不能为空");
            return;
        }
        
        ALERT_ERR_MSG(@"填写的机型数据不能为空");
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(addDevicesViewController:addDevicesInfo:)]) {
        NSString *info = [devicesMuArr componentsJoinedByString:@";"];
        
        [self.delegate addDevicesViewController:self addDevicesInfo:info];
        
        [self backBtnClicked:nil];
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
        NSArray *arr = [self.device_info componentsSeparatedByString:@";"];
//        if (arr.count > 0) {
//            Rows = 5;
//        }else{
            Rows = 4;
//        }
        rows = Rows;
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
                    cell.titleLbl.text = @"需求机型";
                    cell.txtField.text = self.deviceType;
                    
                    if ([self.order_type isEqualToString:@"赠送礼品"]|
                        [self.order_type isEqualToString:@"业务"]) {
                        cell.titleLbl.text = @"业务名称";
                    }
                    
                    break;
                }
                case 1:
                {
                    cell.titleLbl.text = @"数       量";
                    cell.txtField.text = self.deviceCount;
                    break;
                }
                case 2:
                {
                    cell.titleLbl.text = @"颜       色";
                    cell.txtField.text = self.deviceColor;
                    break;
                }
                case 3:
                {
                    cell.titleLbl.text = @"串号录入";
                    cell.txtField.text = self.deviceNum;
                    break;
                }
                default:
                    break;
            }

            if (indexPath.row == 1 | indexPath.row == 3) {
                cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
            }else{
                cell.txtField.keyboardType = UIKeyboardTypeDefault;
            }
            
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
            cell.leftLbl.text = @"需求机型";
            cell.middleLbl.text = @"数量";
            cell.rightLbl.text = @"颜色";
            
            if ([self.order_type isEqualToString:@"赠送礼品"]|
                [self.order_type isEqualToString:@"业务"]) {
                cell.leftLbl.text = @"业务名称";
            }
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
        if (infoArr.count == 3) {
            self.deviceType = infoArr[0];
            self.deviceCount = infoArr[1];
            self.deviceColor = infoArr[2];
        }else if (infoArr.count == 4) {
            self.deviceType = infoArr[0];
            self.deviceCount = infoArr[1];
            self.deviceColor = infoArr[2];
            self.deviceNum = infoArr[3];
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
        self.deviceType = textField.text;
    }else if (textField.tag == 1){
        self.deviceCount = textField.text;
    }else if (textField.tag == 2){
        self.deviceColor = textField.text;
    }else if (textField.tag == 3){
        self.deviceNum = textField.text;
    }
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
    if (self.deviceType.length == 0) {
        msg = @"机型种类不能为空";
        
        if ([self.order_type isEqualToString:@"赠送礼品"]|
            [self.order_type isEqualToString:@"业务"]) {
            msg = @"业务名称不能为空";
        }
    }else if ([self.deviceCount isEqualToString:@"0"] || self.deviceCount.length == 0){
        msg = @"机型数量不能为0";
        
        if ([self.order_type isEqualToString:@"赠送礼品"]|
            [self.order_type isEqualToString:@"业务"]) {
            msg = @"业务数量不能为0";
        }
    }else if (self.deviceColor.length == 0){
        msg = @"机型颜色不能为空";
        
        if ([self.order_type isEqualToString:@"赠送礼品"]|
            [self.order_type isEqualToString:@"业务"]) {
            msg = @"业务颜色不能为空";
        }
    }
    
    if (msg) {
        ALERT_ERR_MSG(msg);
        
        return;
    }
    
    //过滤分隔符
    self.deviceType = [self.deviceType stringByReplacingOccurrencesOfString:@"," withString:@" "];
    self.deviceType = [self.deviceType stringByReplacingOccurrencesOfString:@";" withString:@" "];
    
    self.deviceCount = [self.deviceCount stringByReplacingOccurrencesOfString:@"," withString:@" "];
    self.deviceCount = [self.deviceCount stringByReplacingOccurrencesOfString:@";" withString:@" "];
    
    self.deviceColor = [self.deviceColor stringByReplacingOccurrencesOfString:@"," withString:@" "];
    self.deviceColor = [self.deviceColor stringByReplacingOccurrencesOfString:@";" withString:@" "];
    
    self.deviceNum = [self.deviceNum stringByReplacingOccurrencesOfString:@"," withString:@" "];
    self.deviceNum = [self.deviceNum stringByReplacingOccurrencesOfString:@";" withString:@" "];
    
    NSArray *infoarr = [self.device_info componentsSeparatedByString:@";"];
    
    NSArray *arr;
    
    if (infoarr.count > 0) {
        
        arr = [NSArray arrayWithObjects:self.deviceType,self.deviceCount,self.deviceColor,self.deviceNum, nil];
        
    }else{
        
        arr = [NSArray arrayWithObjects:self.deviceType,self.deviceCount,self.deviceColor, nil];
    }
    
    NSString *info = [arr componentsJoinedByString:@","];
    
    if (self.selectedDevice) {
        NSInteger index = [devicesMuArr indexOfObject:self.selectedDevice];
        
        [devicesMuArr replaceObjectAtIndex:index withObject:info];
    }else{
        [devicesMuArr addObject:info];
    }
    
    
    //重置数据
    self.deviceType = nil;
    self.deviceCount = @"1";
    self.deviceColor = nil;
    self.deviceNum = nil;
    
    self.selectedDevice = nil;
    
    [_tableView reloadData];
}

#pragma mark -

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
