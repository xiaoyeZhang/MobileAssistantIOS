//
//  Business_BillDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/14.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_BillDetailViewController.h"
#import "TwoLablesTableViewCell.h"
#import "TwolabelTableViewCell.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "UIAlertView+Blocks.h"
#import "CalendarHomeViewController.h"
#import "XYDatePicker.h"
#import "TxtFieldTableViewCell.h"
#import "Business_BillListDetailTableViewController.h"
#import "M_Order_Demand_DetailViewController.h"

#define HEIGHT self.view.frame.size.height
#define WIDTH self.view.frame.size.width

@interface Business_BillDetailViewController ()<MBProgressHUDDelegate,XYDatePickerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    MBProgressHUD *HUD;
    CalendarHomeViewController *chvc;
    NSString *BillingCycle;
    NSString *  locationString;
    UIPickerView *DatePickerView;
    NSArray *YearArray;
    NSArray *MonthArray;
    UIView *buttonView;
    NSTimer *timer1;
    int count;
}

@end

@implementation Business_BillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self select_logmodel:NSStringFromClass([self class])];
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_groupId.length > 0) {
        UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"确定"];
        [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.arrayCutomer = [[NSMutableArray alloc]init];
    self.arrayCustomerTemp = [[NSMutableArray alloc]init];
    
    [self loadData];
    [self setDateView];
    self.output.alpha = 0;
    self.title = @"账单信息";
}

- (void)setDateView{
    
    YearArray = [NSArray arrayWithObjects:@"1990",@"1991",@"1992",@"1993",@"1994",@"1995",@"1996",@"1997",@"1998",@"1999",@"2000",@"2001",@"2002",@"2003",@"2004",@"2005",@"2006",@"2007",@"2008",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036",@"2037",@"2038",@"2039",@"2040",@"2041",@"2042",@"2033",@"2044",@"2035",@"2046",@"2047",@"2048",@"2049",@"2050",@"2051",@"2052",@"2053",@"2054",@"2055",@"2056",@"2057",@"2058",@"2059",@"2060",@"2061",@"2062",@"2063",@"2064",@"2065",@"2066",@"2067",@"2068",@"2069",@"2070",@"2071",@"2072",@"2073",@"2074",@"2075",@"2076",@"2077",@"2078",@"2079",@"2080",@"2081",@"2082",@"2083",@"2084",@"2085",@"2086",@"2087",@"2088",@"2089",@"2090",@"2091",@"2092",@"2093",@"2094",@"2095",@"2096",@"2097",@"2098",@"2099",nil];
    
    MonthArray = [NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
    
    buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT, SCREEN_WIDTH, 40)];
    buttonView.backgroundColor = RGBA(246, 246, 246, 1);
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 5, 50, 30)];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:RGBA(25, 82, 217, 1) forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 50, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBA(25, 82, 217, 1) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    
    DatePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, HEIGHT + 40, SCREEN_WIDTH, 162)];
    DatePickerView.backgroundColor = RGBA(247,247,247,1);
    DatePickerView.delegate = self;
    DatePickerView.dataSource = self;
    [self.view addSubview:DatePickerView];
    [self.view addSubview:buttonView];
    [buttonView addSubview:doneBtn];
    [buttonView addSubview:cancelBtn];
    [DatePickerView reloadAllComponents];//刷新UIPickerView
    NSString *year;
    NSString *month;
    
    if (BillingCycle.length > 0) {
        year = [BillingCycle substringWithRange:NSMakeRange(0, 4)];
        month = [BillingCycle substringWithRange:NSMakeRange(5, 2)];
    }else{
        year = [locationString substringWithRange:NSMakeRange(0, 4)];
        month = [locationString substringWithRange:NSMakeRange(5, 2)];
    }
    
    [DatePickerView selectRow:[YearArray indexOfObject:year] inComponent:0 animated:NO];
    [DatePickerView selectRow:[MonthArray indexOfObject:month] inComponent:1 animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    if (section == 0) {
        num = 2;
    }else if (section == 1){
        num = [self.arrayCustomerTemp count] + 1;
    }
    return num;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier1 = @"TwoLablesTableViewCell";
    static NSString *identifier2 = @"TwolabelTableViewCell";
    static NSString *identifier3 = @"TxtFieldTableViewCell";
    TwoLablesTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
    
    if(!cell1)
    {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell1.titleLbl.text = @"账户名称：";
    cell1.subTitleLbl.text  = self.GroupIDentity.AccountName;
    
   
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
           
        }else if(indexPath.row == 1){
            
            TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
            
            if(!cell)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil] firstObject];
                cell.txtField.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            cell.titleLbl.text = @"计费周期：";
            cell.downArrowImageView.image = [UIImage imageNamed:@"pencil"];
            cell.downArrowImageView.hidden = NO;

            if (BillingCycle.length == 0) {
                cell.txtField.text  = locationString;
            }else{
    
                cell.txtField.text  = BillingCycle;
            }

            return cell;
        }
        
        return cell1;
    }else{
        TwolabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 0) {
            cell.titleNameLable.text = @"账单科目名称";
            cell.titleNumLable.text = @"费用科目金额";
        }else{
            BillSubInfoModel *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row-1];
            cell.titleNameLable.text = entity.SubName;
            if (entity.SubFee.length > 0) {
                double yuan = [entity.SubFee doubleValue]/100.0;
                NSString *str = [NSString stringWithFormat:@"%0.2f",yuan];
                cell.titleNumLable.text = [NSString stringWithFormat:@"%g元", [str doubleValue]];
            }
            
        }
        
        return cell;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == [tableView numberOfSections]-1) {
        title = @"> 费用明细";
    }
    
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        if (indexPath.row != 0) {
            Business_BillListDetailTableViewController *vc = [[Business_BillListDetailTableViewController alloc]init];
            
            vc.entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row-1];
            [self move];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
       
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    buttonView.frame = CGRectMake(0, HEIGHT - 202, SCREEN_WIDTH, 40);
    DatePickerView.frame = CGRectMake(0, HEIGHT - 162, SCREEN_WIDTH, 162);
    [UIView commitAnimations];
    
    return NO;
}

//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return  [YearArray count];
    } else if(component==1){
        
        return  [MonthArray count];
    }
    return [YearArray count];
}
//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30.0f;
}
//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component==0) {//iOS6边框占10+10
        return  self.view.frame.size.width/2;
    } else if(component==1){
        return  self.view.frame.size.width/2;
    }
    return  self.view.frame.size.width/2;
}

// 自定义指定列的每行的视图，即指定列的每行的视图行为一致
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 30)];
    text.textAlignment = NSTextAlignmentCenter;
    text.font = [UIFont systemFontOfSize:18];
    if (component == 0) {
        text.text = [YearArray objectAtIndex:row];
    }else if(component == 1){
        text.text = [MonthArray objectAtIndex:row];
    }
    [view addSubview:text];
    
    return view;
}
//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    NSString *str = [MonthArray objectAtIndex:row];
    return str;
}
//显示的标题字体、颜色等属性
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = [YearArray objectAtIndex:row];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    
    return AttributedString;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSString *year;
    NSString *month;
    if (component == 0) {
        year = [YearArray objectAtIndex:row];
    }else if (component == 1) {
        month = [MonthArray objectAtIndex:row];
    }
    if (year.length > 0 ) {
        
        if (BillingCycle.length>0) {
            
            BillingCycle =[NSString stringWithFormat:@"%@-%@",year,[BillingCycle substringWithRange:NSMakeRange(5,2)]];
        }else{
            BillingCycle = [NSString stringWithFormat:@"%@-%@",year,[locationString substringWithRange:NSMakeRange(5,2)]];
        }
        
    }else if(month.length > 0){
        if (BillingCycle.length>0) {
            
            BillingCycle =[NSString stringWithFormat:@"%@-%@",[BillingCycle substringWithRange:NSMakeRange(0,4)],month];
        }else{
            BillingCycle = [NSString stringWithFormat:@"%@-%@",[locationString substringWithRange:NSMakeRange(0,4)],month];
        }
    }
    
    [self.tableView reloadData];
}

- (void)loadData{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];
    
}

- (void) doTask
{
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM"];
    locationString=[dateformatter stringFromDate:senddate];
    NSString *Data;
    if (BillingCycle.length > 6) {
        Data=[NSString stringWithFormat:@"%@%@",
                      [BillingCycle substringWithRange:NSMakeRange(0, 4)],
                      [BillingCycle substringWithRange:NSMakeRange(5, 2)]];
    }
    NSString *data =[NSString stringWithFormat:@"%@%@",
                     [locationString substringWithRange:NSMakeRange(0, 4)],
                     [locationString substringWithRange:NSMakeRange(5, 2)]];
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    NSDictionary *dict = @{@"method":@"whole_province",
                           @"oicode":@"OI_QueryGroupBill",
                           @"user_id":userEntity.user_id,
                           @"AccountId":self.GroupIDentity.AccountId,
                           @"BillingCycle":!Data?data:Data,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            NSDictionary *dic = [entity objectForKey:@"content"];
            
            if (dic) {
                NSMutableArray *array = [dic objectForKey:@"BillSubInfo"];
                if (array.count > 0) {
                    [self.arrayCustomerTemp removeAllObjects];
                    [self.arrayCutomer removeAllObjects];
                    for (NSDictionary* attributes in array) {
                        
                        BillSubInfoModel *entity = [[BillSubInfoModel alloc] init];
                        entity = [entity initWithAttributes:attributes];
                        [self.arrayCutomer addObject:entity];
                        [self.arrayCustomerTemp addObject:entity];
                        
                    }
                }
                else{

                    iToast *toast = [iToast makeText:@"暂无数据"];
                    [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                    [toast setDuration:500];
                    [toast show:iToastTypeNotice];
                }
              
            }
            
            [self.tableView reloadData];
            
        }
        else
        {
          ALERT_ERR_MSG([entity valueForKeyPath:@"msg"]);
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        iToast *toast = [iToast makeText:@"网络连接失败"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:500];
        [toast show:iToastTypeNotice];
    }];
}

//- (void)aleartShow:(NSString *)message{
//    
//    if ([message isEqualToString:@"似乎已断开与互联网的连接。"]) {
//        ALERT_ERR_MSG(@"无法连接到后台服务器，请检查网络!");
//    }else{
//        [UIView animateWithDuration:1 animations:^{
//            
//            self.output.alpha = 1;
//        }];
//        
//        timer1 = [NSTimer scheduledTimerWithTimeInterval:1
//                                                  target:self
//                                                selector:@selector(show)
//                                                userInfo:nil
//                                                 repeats:YES];
//        [timer1 fire];
//    }
//}
//
//- (void)show{
//    
//    if (count++ >= 2) {
//        [timer1 invalidate];
//        count = 0;
//        
//        [UIView animateWithDuration:1 animations:^{
//            
//            self.output.alpha = 0;
//        }];
//        
//        return;
//    }
//    self.output.hidden = NO;
//}

- (void)done:(UIButton *)sender{
    
    [self move];
//    BillingCycle =@"";
    [self loadData];
    
}

- (void)cancel:(UIButton *)sender{
    
    BillingCycle =@"";
    [self move];
}

- (void)move{
    
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    buttonView.frame = CGRectMake(0, HEIGHT, SCREEN_WIDTH, 40);
    DatePickerView.frame = CGRectMake(0, HEIGHT + 40, SCREEN_WIDTH, 162);
    [UIView commitAnimations];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitBtnClicked:(id)sender
{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[M_Order_Demand_DetailViewController class]]) {
            
            NSUserDefaults *AccountId = [NSUserDefaults standardUserDefaults];
            [AccountId setObject:_GroupIDentity.AccountId forKey:@"AccountId"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SET_ACCOUTID_NOTIFY object:nil];
            
            [self.navigationController popToViewController:temp animated:YES];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
