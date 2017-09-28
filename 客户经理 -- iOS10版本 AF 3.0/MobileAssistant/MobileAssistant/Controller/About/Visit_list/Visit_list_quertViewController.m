//
//  Visit_list_quertViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2016/11/8.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Visit_list_quertViewController.h"
#import "Utilies.h"
#import "MBProgressHUD.h"
#import "visit_task_summaryModel.h"
#import "visit_task_summaryTableViewCell.h"
#import "Visit_list_detailViewController.h"

@interface Visit_list_quertViewController ()<MBProgressHUDDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *HUD;
    NSMutableArray *visit_task_summaryArr;
    visit_task_summaryTableViewCell *cell;
    UITableView *searchTableView;
    NSMutableArray *company_list_thinkArr;
}
@end

@implementation Visit_list_quertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"拜访任务工单查看";
    
    [_searchText addTarget:self action:@selector(textFileDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    visit_task_summaryArr = [NSMutableArray array];
    company_list_thinkArr = [NSMutableArray array];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setFISTdata];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.endTime = [dateFormatter stringFromDate:[NSDate date]];;
    
    [_dataBtn setTitle:[NSString stringWithFormat:@" %@ ~ %@",self.startTime,self.endTime]
             forState:UIControlStateNormal];
    
    [self getData:@""];
}

#pragma mark - ButtonMethod
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchBtn:(UIButton *)sender {
    
    if (self.searchText.text.length < 4) {
        
       [self getData:self.searchText.text];
    }

}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    
//    
//    return YES;
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
   
    return YES;
    
}
- (void)textFileDidChange:(UITextField *)sender {
    
    NSString *numregex = @"[0-9]";
    
    NSRegularExpression *regular1 = [[NSRegularExpression alloc] initWithPattern:numregex options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray *results1 = [regular1 matchesInString:sender.text options:0 range:NSMakeRange(0, sender.text.length)];
    
    if (results1.count > 0) {
        
        return;
    }else{
        
        
        
    }
    
    if (sender.text.length >= 4) {
        
        NSString *match = @"(^[\u4e00-\u9fa5]+$)";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    
        if ([predicate evaluateWithObject:sender.text]) {
           
            searchTableView.alpha = 1;
            
            if (searchTableView == nil) {
                searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchText.frame.size.height+self.searchText.frame.origin.y + 5, self.view.frame.size.width, self.view.frame.size.height - self.searchText.frame.size.height+self.searchText.frame.origin.y)];
                
                searchTableView.delegate = self;
                searchTableView.dataSource = self;
                
                [self.view addSubview:searchTableView];
            }

            [self seachData:sender.text];
        }else{
            
            NSString *numregex = @"[0-9]";
            
            NSRegularExpression *regular1 = [[NSRegularExpression alloc] initWithPattern:numregex options:NSRegularExpressionDotMatchesLineSeparators error:nil];
            NSArray *results1 = [regular1 matchesInString:sender.text options:0 range:NSMakeRange(0, sender.text.length)];
            
            if (results1.count > 0) {
                
            }
            
//            [self getData:sender.text];
            
        }
        
    }else{
        
        searchTableView.alpha = 0;
        
        if (sender.text.length == 0) {
            
            [self getData:@""];
            
        }
       
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        return visit_task_summaryArr.count;
    }else{
        return company_list_thinkArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        visit_task_summaryModel *entity = [visit_task_summaryArr objectAtIndex:indexPath.row];
        
        CGSize size = [cell.company_nameLabel sizeThatFits:CGSizeMake(cell.company_nameLabel.frame
                                                                      .size.width, MAXFLOAT)];
        
        return size.height + 35 + 18*entity.times.count;
    }else{
        
        return 44;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        static NSString *couponTableViewCellIdentifier=@"visit_task_summaryTableViewCell";
        cell = (visit_task_summaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"visit_task_summaryTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            
        }
        visit_task_summaryModel *entity = [visit_task_summaryArr objectAtIndex:indexPath.row];
        
        cell.company_nameLabel.text = [NSString stringWithFormat:@"客户：%@",entity.company_name];
        cell.actor_num.text = [NSString stringWithFormat:@"客户经理：%@",entity.actor_num];
        
        switch (entity.times.count) {
            case 1:
                cell.visitNum_one.hidden = NO;
                cell.visitNum_one.text = [NSString stringWithFormat:@"走访时间：%@",[entity.times objectAtIndex:0]];
                
                break;
            case 2:
                cell.visitNum_one.hidden = NO;
                cell.visitNum_one.text = [NSString stringWithFormat:@"走访时间：%@",[entity.times objectAtIndex:0]];
                cell.visitNum_two.hidden = NO;
                cell.visitNum_two.text = [NSString stringWithFormat:@"走访时间：%@",[entity.times objectAtIndex:1]];
                
                break;
            case 3:
                cell.visitNum_one.hidden = NO;
                cell.visitNum_one.text = [NSString stringWithFormat:@"走访时间：%@",[entity.times objectAtIndex:0]];
                cell.visitNum_two.hidden = NO;
                cell.visitNum_two.text = [NSString stringWithFormat:@"走访时间：%@",[entity.times objectAtIndex:1]];
                cell.visitNum_three.hidden = NO;
                cell.visitNum_three.text = [NSString stringWithFormat:@"走访时间：%@",[entity.times objectAtIndex:2]];
                
                break;
            default:
                break;
        }
        return cell;
        
    }else{
        
        static NSString *identifier = @"identifier";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell1) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:identifier];
            
            cell1.textLabel.font = [UIFont systemFontOfSize:15];
        }
        
        cell1.textLabel.text = [[company_list_thinkArr objectAtIndex:indexPath.row] objectForKey:@"company_name"];
        
        return cell1;

    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.tableView) {
        
        visit_task_summaryModel *entity = [visit_task_summaryArr objectAtIndex:indexPath.row];
        
        Visit_list_detailViewController *vc = [[Visit_list_detailViewController alloc]init];
        
        vc.actor_id = entity.actor_id;
        vc.company_name = entity.company_name;
        vc.startTime = self.startTime;
        vc.endTime = self.endTime;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        [self getData:[[company_list_thinkArr objectAtIndex:indexPath.row] objectForKey:@"company_name"]];
        
        searchTableView.alpha = 0;
        
    }
}

- (IBAction)dateBtnClicked:(UIButton *)sender {
    
    [self.searchText resignFirstResponder];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *startDate = [dateFormatter dateFromString:self.startTime];
    NSDate *endDate = [dateFormatter dateFromString:self.endTime];
    
    XYStartEndDatePicker *picker = [XYStartEndDatePicker datePicker];
    picker.startDatePicker.maximumDate = [NSDate date];
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
    
    self.startTime = [dateFormatter stringFromDate:datePicker.startDatePicker.date];
    self.endTime = [dateFormatter stringFromDate:datePicker.endDatePicker.date];
    
    
    NSString *dateStr = [NSString stringWithFormat:@" %@ ~ %@",self.startTime,self.endTime];
    [self.dataBtn setTitle:dateStr forState:UIControlStateNormal];
 
    [self getData:@""];
}

- (void)setFISTdata{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDay;
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&firstDay interval:nil forDate:[NSDate date]];
    NSDateComponents *lastDateComponents = [calendar components:NSMonthCalendarUnit | NSYearCalendarUnit |NSDayCalendarUnit fromDate:firstDay];
    NSUInteger dayNumberOfMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]].length;
    NSInteger day = [lastDateComponents day];
    [lastDateComponents setDay:day+dayNumberOfMonth-1];
//    NSDate *lastDay = [calendar dateFromComponents:lastDateComponents];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:firstDay];
    
    self.startTime = destDateString;
    
}

- (void)getData:(NSString *)company_name{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    UserEntity *entity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = @{@"method":@"visit_task_summary",
                            @"user_id":entity.user_id,
                            @"start_time":self.startTime,
                            @"end_time":self.endTime,
                            @"company_name":company_name,
                            };;
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
         
        if ([strState isEqualToString:@"1"] == YES) {
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            [visit_task_summaryArr removeAllObjects];
            for (NSDictionary *dic in array) {
                visit_task_summaryModel *entity = [[visit_task_summaryModel alloc]init];
                entity = [entity initWithAttributes:dic];
                [visit_task_summaryArr addObject:entity];
            }

        }else
        {
            [visit_task_summaryArr removeAllObjects];
        }
        
        [self.tableView reloadData];
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

- (void)seachData:(NSString *)seachText{
    
    UserEntity *entity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = @{@"method":@"company_list_think",
                            @"user_id":entity.user_id,
                            @"start_time":self.startTime,
                            @"end_time":self.endTime,
                            @"company_name":seachText,
                            };
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            company_list_thinkArr = [entity objectForKey:@"content"];
            
        }
        else
        {
            
        }
        
        [searchTableView reloadData];
        
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
