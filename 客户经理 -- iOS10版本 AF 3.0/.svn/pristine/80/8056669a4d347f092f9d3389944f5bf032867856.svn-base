//
//  Payment_ListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/6/15.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Payment_ListViewController.h"
#import "Payment_ListTableViewCell.h"
#import "Utilies.h"
#import "MBProgressHUD.h"
#import "XYStartEndDatePicker.h"
#import "PaymentEntity.h"
@interface Payment_ListViewController ()<MBProgressHUDDelegate,XYStartEndDatePickerDelegate>
{
    MBProgressHUD *HUD;
    Payment_ListTableViewCell *cell;
    NSMutableArray *PaymentArray;
}

@property (copy, nonatomic) NSString *start_time;
@property (copy, nonatomic) NSString *end_time;
@property(nonatomic, assign) int currentPage;

@end

@implementation Payment_ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"资金回款";
    
    PaymentArray = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.start_time = [Utilies getLastMonth];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.end_time = [dateFormatter stringFromDate:[NSDate date]];;
    
    [_dateBtn setTitle:[NSString stringWithFormat:@" %@ ~ %@",self.start_time,self.end_time]
              forState:UIControlStateNormal];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    [self getDatePage];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return PaymentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [cell.remarksLabel sizeThatFits:CGSizeMake(cell.remarksLabel.frame
                                                             .size.width, MAXFLOAT)];
    if (size.height == 0) {
        return 115;
    }
    return size.height + 95;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier1 = @"Payment_ListTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
    }
    
    PaymentEntity *entity = [PaymentArray objectAtIndex:indexPath.row];
    
    cell.titileLabel.text = entity.company_name;
    cell.moneyLabel.text = [NSString stringWithFormat:@"金额：%@元",entity.num];
    cell.timeLabel.text = [NSString stringWithFormat:@"入账时间：%@",entity.time];
    cell.nameLabel.text = entity.user_name;
    cell.remarksLabel.text = [NSString stringWithFormat:@"备注：%@",entity.remarks];
    
    
    return cell;
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}
- (IBAction)dateBtnClicked:(UIButton *)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *startDate = [dateFormatter dateFromString:self.start_time];
    NSDate *endDate = [dateFormatter dateFromString:self.end_time];
    
    XYStartEndDatePicker *picker = [XYStartEndDatePicker datePicker];
    picker.startDatePicker.date = startDate;
    picker.endDatePicker.date = endDate;
    picker.delegate = self;
    [picker show];
    
}

#pragma mark - XYStartEndDatePickerDelegate

- (void)startEndDatePickerDonePressed:(XYStartEndDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.start_time = [dateFormatter stringFromDate:datePicker.startDatePicker.date];
    self.end_time = [dateFormatter stringFromDate:datePicker.endDatePicker.date];
    
    
    NSString *dateStr = [NSString stringWithFormat:@" %@ ~ %@",self.start_time,self.end_time];
    [_dateBtn setTitle:dateStr forState:UIControlStateNormal];
    
    [self getDatePage];
}

- (void)getDatePage{
    
    
    CommonService *service = [[CommonService alloc]init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dic = @{
                          @"method":@"receive_list",
                          @"user_id":userEntity.user_id,
                          @"start_time":self.start_time?self.start_time:@"",
                          @"end_time":self.end_time?self.end_time:@"",
                          };
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        
        if ([strState isEqualToString:@"1"]) {
        
            NSMutableArray *array = [entity objectForKey:@"content"];
            
            [PaymentArray removeAllObjects];
            
            for (NSDictionary* attributes in array) {
                PaymentEntity *entity = [[PaymentEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [PaymentArray addObject:entity];
            }
            
        }else if([strState isEqualToString:@"0"]){
            
            [PaymentArray removeAllObjects];
        }
        
        [self.tableView reloadData];
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
