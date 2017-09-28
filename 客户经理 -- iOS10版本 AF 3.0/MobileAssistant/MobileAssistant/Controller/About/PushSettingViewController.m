//
//  PushSettingViewController.m
//  MobileAssistant
//
//  Created by xy on 15/10/20.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "PushSettingViewController.h"
#import "PushSettingTableViewCell.h"
#import "XYStartEndDatePicker.h"
#import "UserEntity.h"
#import "CommonService.h"
#import "PushStateModel.h"
#import "MJExtension.h"
#import "UIAlertView+Blocks.h"
#import "SwitchTableViewCell.h"
#import "MBProgressHUD.h"

@interface PushSettingViewController ()<XYStartEndDatePickerDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSArray *dataArr;
    NSMutableArray *swith_selectArr;
}
@property(nonatomic, copy) PushStateModel *pushStateModel;
@property(nonatomic, assign) BOOL isDisableSMS;
@end

@implementation PushSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    push_state 的结构
//    {"state":"1","content":{"push_disable":"0","push_date":"1,2,3,4,5","push_starttime":"09:00:00","push_endtime":"17:00:00"}}
    self.title = @"推送时间设置";
    swith_selectArr = [[NSMutableArray alloc]init];
    
    super.model = NSStringFromClass([self class]);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    dataArr = @[[NSMutableDictionary dictionaryWithObjectsAndKeys:@"周日",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"周一",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"周二",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"周三",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"周四",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"周五",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"周六",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"短信推送",@"title",@(NO),@"Switch_select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"欠费催缴",@"title",@(NO),@"Switch_select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"客户生日提醒",@"title",@(NO),@"Switch_select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"长期未拜访",@"title",@(NO),@"Switch_select",nil],
//                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"客户画像推送",@"title",@(NO),@"Switch_select",nil]
                ];
    
    _pushStateModel = [[PushStateModel alloc] init];
    
    [self getSettingFromServer];
    

}

#pragma mark - ButtonMethod

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
    
    
    NSMutableArray *selectedMuArr = [NSMutableArray array];
    
    int index = 0;
    for (NSDictionary *dict in dataArr) {
        
        BOOL isSelect = [dict[@"select"] boolValue];
        if (isSelect) {
            [selectedMuArr addObject:[NSString stringWithFormat:@"%d",index]];
        }
        
        index++;
    }
    
    if (selectedMuArr.count == 0) {
        self.pushStateModel.push_disable = @"1";
    }else{
        self.pushStateModel.push_disable = @"0";
    }
    
    self.pushStateModel.push_date = [selectedMuArr componentsJoinedByString:@","];
    
    NSInteger num = 0;
    if (swith_selectArr.count != 0) {
        
       num = [swith_selectArr[0] intValue];
        
        for (int i = 1; i<swith_selectArr.count; i++) {
            
            num = num | [swith_selectArr[i] intValue];
            
        }
    }
    
//    self.pushStateModel.push_flag = [swith_selectArr componentsJoinedByString:@","];

    self.pushStateModel.push_flag = [NSString stringWithFormat:@"%d",num];
    
    self.pushStateModel.push_sms = self.isDisableSMS;
    
    NSDictionary *dict = [self.pushStateModel keyValues];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [muDict setValue:@"config_push" forKey:@"method"];
    [muDict setValue:userInfo.user_id forKey:@"user_id"];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:muDict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      if (state == 1) {
                          UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                          [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                             
                              if ([_delegate respondsToSelector:@selector(successDelegate:andWithEndtime:)]) {
                                  [_delegate successDelegate:self.pushStateModel.push_starttime andWithEndtime:self.pushStateModel.push_endtime];
                              }
                              
                              [self.navigationController popViewControllerAnimated:YES];
                          }];
                      }else{
                          ALERT_ERR_MSG(@"提交失败");
                      }
                      isDone = YES;
                      [HUD hide:YES];
                  } Failed:^(int errorCode, NSString *message) {
                      ALERT_ERR_MSG(@"网络连接失败");
                      isDone = YES;
                      [HUD hide:YES];
                  }];
}

#pragma mark - 

- (void)getSettingFromServer
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"user_id":userInfo.user_id,
                           @"method":@"push_state"};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      if (state == 1) {
                          PushStateModel *model = [PushStateModel objectWithKeyValues:entity[@"content"]];

                          self.pushStateModel.push_date = model.push_date;
                          self.pushStateModel.push_disable = model.push_disable;
                          self.pushStateModel.push_starttime = model.push_starttime;
                          self.pushStateModel.push_endtime = model.push_endtime;
                          self.pushStateModel.push_sms = model.push_sms;
                          self.pushStateModel.push_flag = model.push_flag;
                          
                          self.isDisableSMS = model.push_sms;
                          smsSwitch.on = !model.push_sms;
                          
                          NSArray *enableDate = [self.pushStateModel.push_date componentsSeparatedByString:@","];
                          for (NSString *str in enableDate) {
                              int index = [str intValue];
                              
                              NSDictionary *dict = dataArr[index];
                              [dict setValue:@(YES) forKey:@"select"];
                          }
                          
                          [self OrChangeAnd:self.pushStateModel.push_flag];
                          
                          NSString *dateStr = [NSString stringWithFormat:@"  %@ ~ %@",self.pushStateModel.push_starttime,self.pushStateModel.push_endtime];
                          [dateBtn setTitle:dateStr forState:UIControlStateNormal];
                          
                          [_tableView reloadData];
                      }
                      
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PushSettingTableViewCell";
    static NSString *identifier1 = @"SwitchTableViewCell";
    
    PushSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
    }
    
    SwitchTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (!cell1) {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
    }
    
    NSDictionary *dict = dataArr[indexPath.row];
    
    if (indexPath.row >= 7) {
        
        cell1.switchBtn.tag = indexPath.row;
        cell1.titleLabel.text = dict[@"title"];
        cell1.switchBtn.on = [dict[@"Switch_select"] boolValue];
        [cell1.switchBtn addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell1;
    }else{
        
        cell.titleLbl.text = dict[@"title"];
        cell.checkBoxBtn.selected = [dict[@"select"] boolValue];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = dataArr[indexPath.row];
    
    if (indexPath.row >= 7) {
        BOOL isSelected = [dict[@"Switch_select"] boolValue];
        isSelected = !isSelected;
        [dict setValue:@(isSelected) forKey:@"Switch_select"];
    }else{
        BOOL isSelected = [dict[@"select"] boolValue];
        isSelected = !isSelected;
        [dict setValue:@(isSelected) forKey:@"select"];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -

- (IBAction)dateBtnClicked:(id)sender
{
    XYStartEndDatePicker *picker = [XYStartEndDatePicker datePicker];
    picker.startDatePicker.datePickerMode = UIDatePickerModeTime;
    picker.endDatePicker.datePickerMode = UIDatePickerModeTime;
    picker.delegate = self;
    picker.showDateFormatter = @"HH:mm:ss";
    
    if (self.pushStateModel.push_starttime.length > 0 && self.pushStateModel.push_endtime.length > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        
        NSDate *startDate = [dateFormatter dateFromString:self.pushStateModel.push_starttime];
        NSDate *endDate = [dateFormatter dateFromString:self.pushStateModel.push_endtime];
        
        picker.startDatePicker.date = startDate;
        picker.endDatePicker.date = endDate;
    }
    
    
    [picker show];
}

#pragma mark - SwitchValueChanged

- (IBAction)switchValueChanged:(id)sender
{
    self.isDisableSMS = !smsSwitch.on;
}

- (void)switchChanged:(UISwitch *)sender{
    
    switch (sender.tag) {
        case 7:
            if (sender.on) {
                [swith_selectArr addObject:@"1"];
            }else{
                [swith_selectArr removeObject:@"1"];
            }

            break;
        case 8:
            
            if (sender.on) {
                [swith_selectArr addObject:@"2"];
            }else{
                [swith_selectArr removeObject:@"2"];
            }
            
            break;
        case 9:
            if (sender.on) {
                [swith_selectArr addObject:@"4"];
            }else{
                [swith_selectArr removeObject:@"4"];
            }
            break;
        case 10:
            if (sender.on) {
                [swith_selectArr addObject:@"8"];
            }else{
                [swith_selectArr removeObject:@"8"];
            }
            
            break;
        case 11:
            if (sender.on) {
                [swith_selectArr addObject:@"16"];
            }else{
                [swith_selectArr removeObject:@"16"];
            }
            break;
            
        default:
            break;
    }
}


#pragma mark - XYStartEndDatePickerDelegate

- (void)startEndDatePickerDonePressed:(XYStartEndDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    self.pushStateModel.push_starttime = [dateFormatter stringFromDate:datePicker.startDatePicker.date];
    self.pushStateModel.push_endtime = [dateFormatter stringFromDate:datePicker.endDatePicker.date];
    
    
    NSString *dateStr = [NSString stringWithFormat:@"  %@ ~ %@",self.pushStateModel.push_starttime,self.pushStateModel.push_endtime];
    [dateBtn setTitle:dateStr forState:UIControlStateNormal];
}

- (void)OrChangeAnd:(NSString *)push_flag{
    
    
    NSInteger num = push_flag.intValue;
    
    if ((num&1) == 1) {
        
        NSDictionary *dict = dataArr[7];
        [dict setValue:@(YES) forKey:@"Switch_select"];
        
        [swith_selectArr addObject:@"1"];
    }
    if ((num&2) == 2) {
        
        NSDictionary *dict = dataArr[8];
        [dict setValue:@(YES) forKey:@"Switch_select"];
        [swith_selectArr addObject:@"2"];
    }
    if ((num&4) == 4) {
        
        NSDictionary *dict = dataArr[9];
        [dict setValue:@(YES) forKey:@"Switch_select"];
        [swith_selectArr addObject:@"4"];
    }
    if ((num&8) == 8) {
        
        NSDictionary *dict = dataArr[10];
        [dict setValue:@(YES) forKey:@"Switch_select"];
        [swith_selectArr addObject:@"8"];
    }
//    if ((num&16) == 16) {
//        
//        NSDictionary *dict = dataArr[11];
//        [dict setValue:@(YES) forKey:@"Switch_select"];
//        [swith_selectArr addObject:@"16"];
//    }
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
