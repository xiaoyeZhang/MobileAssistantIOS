//
//  Birthday_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/5.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Birthday_DetailViewController.h"
#import "Bless_informationViewController.h"
#import "MBProgressHUD.h"
#import "Birthday_DetailEntiy.h"
#import <MessageUI/MessageUI.h>

@interface Birthday_DetailViewController ()<MBProgressHUDDelegate,Bless_informationDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    MBProgressHUD *HUD;
    XYStartEndDatePicker *picker;
    NSString *suggestMessage;
    NSString *sms_ID;
    BOOL isclick;
    UIPickerView *DatePickerView;
    NSArray *MonthArray;
    NSString *hourStr;
}

@property (copy, nonatomic) NSString *company_name;
@property (copy, nonatomic) NSString *client_name;
@property (copy, nonatomic) NSString *client_job;
@property (copy, nonatomic) NSString *client_tel;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *ch_zodiac;
@property (copy, nonatomic) NSString *zodiac;
@property (copy, nonatomic) NSString *lunar;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *sms_id;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *birthday_date;
@property (copy, nonatomic) NSString *age;
@property (copy, nonatomic) NSString *birthday_date_all;
@property (copy, nonatomic) NSString *SMS_message;
@property (copy, nonatomic) NSString *send_time;

@end

@implementation Birthday_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"生日详情";
    
    isclick = NO;
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 44);
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(sumBitCickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setNaviBarRightView:rightBtn];
    
    self.textView.returnKeyType = UIReturnKeyDone;
    
    self.timerTextFile.userInteractionEnabled = NO;
    //    /注册键盘出现的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
 
    
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [yearFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    self.startTime = [yearFormatter stringFromDate:[NSDate date]];
    
    self.endTime = [dateFormatter stringFromDate:[NSDate date]];
 
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.ch_zodiacLabel.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.ch_zodiacLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    self.ch_zodiacLabel.layer.mask = maskLayer;
    
    UIBezierPath *ch_maskPath = [UIBezierPath bezierPathWithRoundedRect:self.ch_Label.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *ch_maskLayer = [[CAShapeLayer alloc] init];
    ch_maskLayer.frame = self.ch_Label.bounds;
    ch_maskLayer.path = ch_maskPath.CGPath;
    self.ch_Label.layer.mask = ch_maskLayer;
    
    [self.textView setEditable:NO];
}

#pragma mark - ButtonMethod

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] == 0) {
        [self.textViewLabel setHidden:NO];
    }else{
        [self.textViewLabel setHidden:YES];
        
    }
}

#pragma mark - 发送
- (void)sumBitCickBtn:(id)sender{
    if (self.textView.text.length == 0) {
        ALERT_ERR_MSG(@"请从短信库添加祝福内容！");
        return;
    }else{
        
        UIAlertController *contoller = [UIAlertController alertControllerWithTitle:@"是否立即发送短信" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            isclick = YES;
            
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.messageComposeDelegate = self;
            
            NSString *message = [NSString stringWithFormat:@"%@",self.textView.text];
            
            messageController.body = message;
            
            messageController.recipients = @[self.client_tel];
            
            [self presentViewController:messageController animated:YES completion:nil];
            
            [self send_sms:0];
            
        }];
        [contoller addAction:cancelAction];
        [contoller addAction:otherAction];
        [self presentViewController:contoller animated:YES completion:nil];//弹出提醒框
        
    }
    
}
- (IBAction)addTimeClick:(UIButton *)sender {
    
    NSLog(@"选择时间");
    
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSDate *startDate = [yearFormatter dateFromString:self.startTime];
    NSDate *endDate = [dateFormatter dateFromString:self.endTime];
    
    picker = [XYStartEndDatePicker datePicker];
    picker.startDatePicker.minimumDate = [NSDate date];
    picker.lableItem.tintColor = [UIColor colorWithRed:110.0/255 green:110.0/255 blue:110.0/255 alpha:1];
    picker.lableItem.title = @"请选择时间";
    picker.lableItem.enabled = NO;
    picker.startDatePicker.date = startDate;
    picker.startDatePicker.datePickerMode = UIDatePickerModeDate;
//    picker.endDatePicker.datePickerMode = UIDatePickerModeTime;
//    picker.endDatePicker.date = endDate;
    picker.endDatePicker.alpha = 0;
//    picker.endDatePicker.minuteInterval = 30;
    picker.delegate = self;
    
    MonthArray = [NSArray arrayWithObjects:@"00",@"02",@"04",@"06",@"08",@"10",@"12",@"14",@"16",@"18",@"20",@"22", nil];

    DatePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 162, SCREEN_WIDTH, 162)];
    DatePickerView.backgroundColor = [UIColor whiteColor];
    DatePickerView.delegate = self;
    DatePickerView.dataSource = self;
    DatePickerView.alpha = 0;
    [picker addSubview:DatePickerView];
    
    NSLog(@"%@",[self.send_time substringWithRange:NSMakeRange(11, 2)]);
    
    NSString *hour;
    
    if ([[[dateFormatter stringFromDate:endDate] substringToIndex:2] intValue] % 2 == 0) {
        NSLog(@"偶数");
        hour = [NSString stringWithFormat:@"%d",[[[dateFormatter stringFromDate:endDate] substringToIndex:2] intValue] +2];
    }else{
         NSLog(@"奇数");
        hour = [NSString stringWithFormat:@"%d",[[[dateFormatter stringFromDate:endDate] substringToIndex:2] intValue] +1];
    }
    [DatePickerView selectRow:[MonthArray indexOfObject:hour] inComponent:0 animated:NO];
    
    hourStr = [NSString stringWithFormat:@"%@:00",hour];
    
//    [picker.endDatePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    
    [picker.startDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [picker.endDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [picker show];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         DatePickerView.alpha = 1;
                         DatePickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 162, SCREEN_WIDTH, 162);
                     } completion:^(BOOL finished) {
                         
                     }];
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [MonthArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [MonthArray objectAtIndex:row];
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSDate *startDate = [yearFormatter dateFromString:self.startTime];
    
    ;
    NSDate *endDate = [dateFormatter dateFromString:self.endTime];
    
    NSString *hour;
    
    if ([[[dateFormatter stringFromDate:endDate] substringToIndex:2] intValue] % 2 == 0) {
        NSLog(@"偶数");
        hour = [NSString stringWithFormat:@"%d",[[[dateFormatter stringFromDate:endDate] substringToIndex:2] intValue] +2];
    }else{
        NSLog(@"奇数");
        hour = [NSString stringWithFormat:@"%d",[[[dateFormatter stringFromDate:endDate] substringToIndex:2] intValue] +1];
    }
    
    NSComparisonResult result = [picker.startDatePicker.date compare:startDate];
    
    if (result == NSOrderedDescending) {
        
        NSLog(@"Date1  is in the future");
        
        hourStr = [NSString stringWithFormat:@"%@:00",[MonthArray objectAtIndex:row]];
        
    }else if (result == NSOrderedAscending){
        
        NSLog(@"Date1 is in the past");
        
    }else{
        NSLog(@"Both dates are the same");
        
        if ([[MonthArray objectAtIndex:row] intValue] < [[[dateFormatter stringFromDate:endDate] substringToIndex:2] intValue]) {
            [DatePickerView selectRow:[MonthArray indexOfObject:hour] inComponent:0 animated:YES];

            hourStr = [NSString stringWithFormat:@"%@:00",hour];
        }else{
            
            hourStr = [NSString stringWithFormat:@"%@:00",[MonthArray objectAtIndex:row]];
            
        }
        
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

}

//- (void)changeDate:(id)sender
//{
//    
//    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];//NSDate转换成NSString
//    [dateFormatter2 setDateFormat:@"mm"];
//    NSString *strDate2 = [dateFormatter2 stringFromDate:[sender date]];
//    
//    if (![strDate2 isEqualToString:@"00"]) {
//        NSLog(@"strdate2:   %@",strDate2);
//        [picker.endDatePicker setMinimumDate:0];
//    }
//    
//    
//}

- (IBAction)saveClick:(UIButton *)sender {
    
    NSLog(@"保存");
    
    if (self.timerTextFile.text.length == 0) {
        ALERT_ERR_MSG(@"请选择时间！");
        return;
    }
    
    if (self.textView.text.length == 0) {
        ALERT_ERR_MSG(@"请从短信库添加祝福内容！");
        return;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";

    [self send_sms:1];

}
- (IBAction)cancelClick:(UIButton *)sender {
    
    NSLog(@"取消");
//    if (self.send_time.length > 0) {
    
    if ([self.state isEqualToString:@"1"]) {
        
        UIAlertController *contoller = [UIAlertController alertControllerWithTitle:@"是否取消定时？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            CommonService *service = [[CommonService alloc] init];
            
            NSDictionary *dict;
            
            dict = @{@"method":@"sms_timer",
                     @"birthday_id":self.birthday_id,
                     @"op_type":@"1",
                     };
            
            [service getNetWorkData:dict  Successed:^(id entity) {
                NSNumber *state = [entity valueForKeyPath:@"state"];
                NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
                
                if ([strState isEqualToString:@"1"]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }else{
                    
                    
                }
                
                [HUD hide:YES];
            } Failed:^(int errorCode, NSString *message) {
                
                [HUD hide:YES];
                
            }];
            
        }];
        [contoller addAction:cancelAction];
        [contoller addAction:otherAction];
        [self presentViewController:contoller animated:YES completion:nil];//弹出提醒框
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (IBAction)queryClick:(UIButton *)sender {
    NSLog(@"短信查询");
    
    [self.textView resignFirstResponder];
    
    Bless_informationViewController *vc = [[Bless_informationViewController alloc]init];
    
    vc.delegate = self;
    vc.type_id = @"5";
    vc.Title = @"生日祝福";
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    suggestMessage = textView.text;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    isclick = NO;
    return YES;
}

- (void)keyboardWasShown:(NSNotification*)aNotification

{
     if (isclick == NO) {
         //键盘高度
         CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
         [UIView animateWithDuration:0.5 animations:^(void){
             self.view.frame =CGRectMake(0, 0-keyBoardFrame.size.height + 67,self.view.frame.size.width,self.view.frame.size.height);
         }];
 
     }
   
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    if (isclick == NO) {
        [UIView animateWithDuration:0.5 animations:^(void){
            self.view.frame =CGRectMake(0,64,self.view.frame.size.width,self.view.frame.size.height);
        }];
    }
   
    
}


#pragma mark - XYStartEndDatePickerDelegate

- (void)startEndDatePickerDonePressed:(XYStartEndDatePicker *)datePicker
{
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [yearFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    self.startTime = [yearFormatter stringFromDate:datePicker.startDatePicker.date];
    
    self.endTime = [dateFormatter stringFromDate:datePicker.endDatePicker.date];
    
    
//    NSString *dateStr = [NSString stringWithFormat:@"%@ %@",self.startTime,self.endTime];
    NSString *dateStr = [NSString stringWithFormat:@"%@ %@",self.startTime,hourStr];
    
    self.timerTextFile.text = dateStr;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         DatePickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 162);
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)datePickerValueChanged:(id)sender
{
    
    picker.lableItem.title = @"请选择时间";

}


- (void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"get_birthday_detail",
                           @"birthday_id":self.birthday_id,

                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            NSMutableDictionary *attributes = [entity objectForKey:@"content"];
            
            Birthday_DetailEntiy *entity = [[Birthday_DetailEntiy alloc] init];
            entity = [entity initWithAttributes:attributes];
            
            self.birthday_id = entity.birthday_id;
            self.company_name = entity.company_name;
            self.client_name = entity.client_name;
            self.client_job = entity.client_job;
            self.client_tel = entity.client_tel;
            self.date = entity.date;
            self.ch_zodiac = entity.ch_zodiac;
            self.zodiac = entity.zodiac;
            self.lunar = entity.lunar;
            self.state = entity.state;
            self.sms_id = entity.sms_id;
           
            if (![entity.content isKindOfClass:[NSNull class]]){
                self.content = entity.content;
            }
            
            if (![entity.send_time isKindOfClass:[NSNull class]]){
                
                self.send_time = entity.send_time;
            }
            
            self.birthday_date = entity.birthday_date;
            self.age = entity.age;
            self.birthday_date_all = entity.birthday_date_all;
            sms_ID = entity.sms_id;
           
            
            [self reloadView];
        }else{
            
            
        }
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
        
    }];
    
    
}

#pragma mark - 发送祝福短信
- (void)send_sms:(NSInteger)num{
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict;
    
    if (num == 1) {
        
        dict = @{@"method":@"send_sms",
                 @"sms_id":sms_ID,
                 @"user_id":userEntity.user_id,
                 @"birthday_id":self.birthday_id,
                 @"sms_type":@"1",
                 @"send_time":self.timerTextFile.text,
                 };
    }else{
        dict = @{@"method":@"send_sms",
                 @"sms_id":sms_ID,
                 @"user_id":userEntity.user_id,
                 @"birthday_id":self.birthday_id,
                 @"sms_type":@"1",
                 };
    }
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            
            if (self.timerTextFile.text.length > 0) {
                if (num == 1) {
                   [self.navigationController popViewControllerAnimated:YES];
                }
                
            }else{
                
            }
            

        }else{
            
            
        }
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
        
    }];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    // 应该用这个！！！
    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadView{
    
    self.nameLabel.text = self.client_name;
    self.positionLable.text = [NSString stringWithFormat:@" (%@ - %@)",self.company_name,self.client_job];
    self.DayLable.text = [NSString stringWithFormat:@"%@天",self.date];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",self.age,self.birthday_date]];
    
    [str addAttribute:NSForegroundColorAttributeName value:RGBA(239, 120, 122, 1) range:NSMakeRange(0, str.length - self.birthday_date.length)];
    
    
    self.birthdayLabel.attributedText = str;
    self.calendarLable.text = self.birthday_date_all;
    self.lunarLable.text = self.lunar;
    self.zodiacLabel.text = self.ch_zodiac;
    self.constellationLabel.text = self.zodiac;
//    self.timerTextFile.text = self.send_time;
    self.timerTextFile.text = [self.send_time substringWithRange:NSMakeRange(0, 16)];
    if(self.send_time.length > 0){
       hourStr = [NSString stringWithFormat:@"%@:00",[self.send_time substringWithRange:NSMakeRange(11, 2)]];
    }else{
        hourStr = @"10:00";
    }
    
    
    if (self.content.length > 0) {
        
        [self.textViewLabel setHidden:YES];
        self.textView.text = self.content;
    }
    
    
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         DatePickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 162);
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)successBless_informationdelegate:(NSDictionary *)successdelegate{
    
    [self.textViewLabel setHidden:YES];
    sms_ID = [successdelegate objectForKey:@"sms_id"];
    self.SMS_message = [successdelegate objectForKey:@"content"];
    
    self.textView.text = self.SMS_message;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
