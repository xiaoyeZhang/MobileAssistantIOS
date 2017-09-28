//
//  No_visit_sumListView.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/5/3.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "No_visit_sumListView.h"
#import "No_visit_TaskTableViewCell.h"
#import "TaskCreateViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "No_visit_baselistEntity.h"
#import "Handling_tasksEntity.h"
#import "Matching_SectgionView.h"
#import "Handling_tasksTableViewCell.h"
#import "UserEntity.h"
#import "DXAlertView.h"
#import "XYDatePicker.h"
#import "No_visit_Detail_ListViewController.h"

@interface No_visit_sumListView ()<MBProgressHUDDelegate,XYDatePickerDelegate,UITextViewDelegate>
{
    DXAlertView *alert;
    UserEntity *userEntity;
    MBProgressHUD *HUD;
    No_visit_TaskTableViewCell *cell;
    Handling_tasksTableViewCell *cell1;
    
    NSMutableDictionary *selectedDic;//二级列表是否展开状态
    NSMutableArray *One_SectonArr;
    NSMutableArray *Two_SectonArr;
    NSMutableArray *Three_SectonArr;
    NSMutableArray *Four_SectonArr;
    NSMutableArray *Five_SectonArr;
    NSMutableArray *Sex_SectonArr;
    
    NSMutableArray *deleteArr;
    
    NSMutableArray *unfinishArr;
    NSMutableArray *finishArr;
    NSMutableArray *finishdetailsArr;
    
    NSString *unfinishStr;
    NSString *finishStr;
    
    NSString *Btn_TitleStr;
}

@property (strong, nonatomic) NSString *Type;

@end

@implementation No_visit_sumListView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userEntity = [UserEntity sharedInstance];
    
    One_SectonArr = [[NSMutableArray alloc]init];
    Two_SectonArr = [[NSMutableArray alloc]init];
    Three_SectonArr = [[NSMutableArray alloc]init];
    Four_SectonArr = [[NSMutableArray alloc]init];
    Five_SectonArr = [[NSMutableArray alloc]init];
    Sex_SectonArr = [[NSMutableArray alloc]init];
 
    deleteArr = [[NSMutableArray alloc]init];
    
    unfinishArr = [[NSMutableArray alloc]init];
    finishArr = [[NSMutableArray alloc]init];
    finishdetailsArr = [[NSMutableArray alloc]init];
    
    unfinishStr = @"0";
    finishStr = @"0";
    
    if (!selectedDic) {
        selectedDic = [[NSMutableDictionary alloc]init];
    }
    
//    [selectedDic setObject:@"1" forKey:@"0"];
//    [selectedDic setObject:@"1" forKey:@"1"];
//    [selectedDic setObject:@"1" forKey:@"2"];
//    [selectedDic setObject:@"1" forKey:@"3"];
    [selectedDic setObject:@"1" forKey:@"4"];
    [selectedDic setObject:@"1" forKey:@"5"];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super init];
    
    self.tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.editing = NO;
    
    [self.view addSubview:self.tableView];
    return self;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     if ([self.Type isEqualToString:@"1"]) {
         
         return 4;
     }else{
         if ([userEntity.type_id intValue] == ROLE_CUSTOMER){
             return 2;
         }else{
             return 1;
         }
         
     }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.Type isEqualToString:@"1"]) {
        
//        if (section == 0) {
//            return One_SectonArr.count;
//        }else if (section == 1){
//            return Two_SectonArr.count;
//        }else if (section == 2){
//            return Three_SectonArr.count;
//        }else if (section == 3){
//            return Four_SectonArr.count;
//        }
        
    }else if([self.Type isEqualToString:@"2"]){
        
        
        if (section == 0) {
            return unfinishArr.count;
        }else if (section == 1){
            return finishArr.count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

//Section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([selectedDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]) {
        
       if ([self.Type isEqualToString:@"1"]) {
           CGSize size = [cell.titleLabel sizeThatFits:CGSizeMake(cell.titleLabel.frame.size.width, MAXFLOAT)];
           if (size.height == 0) {
               return 70;
           }
           return size.height + 50;
       }else{
           
           CGSize size = [cell1.messageLabel sizeThatFits:CGSizeMake(cell1.messageLabel.frame.size.width, MAXFLOAT)];
           if (size.height == 0) {
               return 90;
           }
           return size.height + 70;

       }
        
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"No_visit_TaskTableViewCell";
    static NSString *identifier1 = @"Handling_tasksTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
    }
    
    cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (!cell1) {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
        cell1.TimeLabel.textColor = [UIColor redColor];
        cell1.messageLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    }
    
    
    if ([self.Type isEqualToString:@"1"]) {
        No_visit_baselistEntity *entity;
        
        if (indexPath.section == 0) {
            
            entity = [One_SectonArr objectAtIndex:indexPath.row];
            
        }else if (indexPath.section == 1) {
            
            entity = [Two_SectonArr objectAtIndex:indexPath.row];
            
        }else if (indexPath.section == 2) {
            
            entity = [Three_SectonArr objectAtIndex:indexPath.row];
            
        }else if (indexPath.section == 3) {
            
            entity = [Four_SectonArr objectAtIndex:indexPath.row];
            
        }

        cell.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",entity.name,entity.num];
        
        NSString *Timestr = [NSString stringWithFormat:@"%ld",(long)entity.visit_time];
        
        NSMutableAttributedString *str;
        
        NSString *level = [self setLevel:entity.company_level];
        
        if ([Timestr isEqualToString:@"-1"]) {
            str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"从未拜访过   %@    %@",level,entity.user_name]];
            
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,5)];
            
        }else{
            
            Timestr = [NSString stringWithFormat:@"%ld",(long)entity.visit_time];
            
            str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已超期%@天未拜访过   %@    %@",Timestr,level,entity.user_name]];
            
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,8+Timestr.length)];
        }

        cell.NumLabel.attributedText = str;

        return cell;
    }else if([self.Type isEqualToString:@"2"]){
    
        Handling_tasksEntity *entity;
        
        if (indexPath.section == 0) {
            
            entity = [unfinishArr objectAtIndex:indexPath.row];
            
        }else if (indexPath.section == 1) {
            
            entity = [finishArr objectAtIndex:indexPath.row];
            
        }
        
        NSString *level = [self setLevel:entity.company_level];
        
        cell1.titleLabel.text = [NSString stringWithFormat:@"%@(%@)  %@",entity.company_name,entity.company_num,entity.user_name];
        
        cell1.TimeLabel.text = [NSString stringWithFormat:@"督办拜访截止时间  %@  %@",entity.to_day,level];
        cell1.messageLabel.text = [NSString stringWithFormat:@"工作要求：%@",entity.content];
        
        return cell1;
        
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Matching_SectgionView *view = [[[NSBundle mainBundle] loadNibNamed:@"Matching_SectgionView" owner:nil options:nil] firstObject];
    
    view.sectionName.textColor = RGBA(65, 65, 65, 1);
    
    view.backgroundColor = [UIColor whiteColor];
    
    NSArray *countArr = [NSArray arrayWithObjects:@"6",@"3",@"2",@"1", nil];
    
    NSString *countNum = countArr[section];
    
    NSString *countStr = @"0";
    
    if (section == 0) {
        countStr = [NSString stringWithFormat:@"%lu",(unsigned long)One_SectonArr.count];
    }else if (section == 1) {
        countStr = [NSString stringWithFormat:@"%lu",(unsigned long)Two_SectonArr.count];
    }else if (section == 2) {
        countStr = [NSString stringWithFormat:@"%lu",(unsigned long)Three_SectonArr.count];
    }else if (section == 3) {
        countStr = [NSString stringWithFormat:@"%lu",(unsigned long)Four_SectonArr.count];
        
    }
    
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"超期%@个月以上    （%@）",countNum,countStr]];
     NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"超期%@个月以上   ",countNum]];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(11+countNum.length,countStr.length)];
    
    if ([self.Type isEqualToString:@"1"]) {
        view.icon.alpha = 0;
        view.sectionName.attributedText = str;
    }else{
     
        if (section == 0) {
            view.sectionName.text = [NSString stringWithFormat:@"未完成督办任务总数(%@)",unfinishStr];
        }else if (section == 1){
            view.sectionName.text = [NSString stringWithFormat:@"已完成督办任务总数(%@)",finishStr];
        }
        
    }
    

    view.tag = section;
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTop:)];
    singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
    [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
    [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
    
    return view;
}

- (void)SingleTop:(UITapGestureRecognizer *)recognizer{
    
    NSInteger didsection = recognizer.view.tag;
    
    NSString *key = [NSString stringWithFormat:@"%ld",(long)didsection];
    
    if ([self.Type isEqualToString:@"1"]) {
        
        AppDelegate *app= (AppDelegate *)[[UIApplication sharedApplication] delegate];//navigation需要自己定义
        
        No_visit_Detail_ListViewController *vc = [[No_visit_Detail_ListViewController alloc]init];
        
        if ([key isEqualToString:@"0"]) {
            
            vc.name = @"超期6个月以上";
            vc.visit_state = @"3";
            
        }else if ([key isEqualToString:@"1"]) {
            
            vc.name = @"超期3个月以上";
            vc.visit_state = @"2";
            
        }else if ([key isEqualToString:@"2"]) {
            
            vc.name = @"超期2个月以上";
            vc.visit_state = @"1";
            
        }else if ([key isEqualToString:@"3"]) {
            
            vc.name = @"超期1个月以上";
            vc.visit_state = @"0";
            
        }
//        [self.navigationController pushViewController:vc animated:YES];
        [app.nav pushViewController:vc animated:YES];
        
    }else{
        
        if (![selectedDic objectForKey:key]) {
            [selectedDic setObject:@"1" forKey:key];
        }else{
            [selectedDic removeObjectForKey:key];
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:didsection] withRowAnimation:UITableViewRowAnimationFade];
    }


}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}


//取消选中时 将存放在self.deleteArr中的数据移除

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        [deleteArr removeObject:One_SectonArr[indexPath.row]];
        
    }else if (indexPath.section == 1) {
        
        [deleteArr removeObject:Two_SectonArr[indexPath.row]];
        
    }else if (indexPath.section == 2) {
        
        [deleteArr removeObject:Three_SectonArr[indexPath.row]];
        
    }else if (indexPath.section == 3) {
        
        [deleteArr removeObject:Four_SectonArr[indexPath.row]];
        
    }
    
}


//选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([userEntity.type_id intValue] == ROLE_CUSTOMER){
        
        AppDelegate *app= (AppDelegate *)[[UIApplication sharedApplication] delegate];//navigation需要自己定义
        
        TaskCreateViewController *vc = [[TaskCreateViewController alloc]init];
        if ([self.Type isEqualToString:@"1"]){
            
            if (indexPath.section == 0) {
                
                vc.No_visit_Entity = [One_SectonArr objectAtIndex:indexPath.row];
                
            }else if (indexPath.section == 1) {
                
                vc.No_visit_Entity = [Two_SectonArr objectAtIndex:indexPath.row];
                
            }else if (indexPath.section == 2) {
                
                vc.No_visit_Entity = [Three_SectonArr objectAtIndex:indexPath.row];
                
            }else if (indexPath.section == 3) {
                
                vc.No_visit_Entity = [Four_SectonArr objectAtIndex:indexPath.row];
                
            }


            [app.nav pushViewController:vc animated:YES];
            
        }else if([self.Type isEqualToString:@"2"]){
            if (indexPath.section == 0) {
                
                vc.handlingEntity = [unfinishArr objectAtIndex:indexPath.row];
                
                [app.nav pushViewController:vc animated:YES];
                
            }else if (indexPath.section == 1){
                
                VisiteTask *entity = [finishdetailsArr objectAtIndex:indexPath.row];

                VisitTaskDetailViewController *vc = [[VisitTaskDetailViewController alloc]init];
                vc.visiteTask = entity;
                
                [app.nav pushViewController:vc animated:YES];
                
                
            }else{
                
            }
        }
    

    }else{
        
        if([self.Type isEqualToString:@"1"]){
            
            if (indexPath.section == 0) {
                
                [deleteArr addObject:One_SectonArr[indexPath.row]];
                
            }else if (indexPath.section == 1) {
                
                [deleteArr addObject:Two_SectonArr[indexPath.row]];
                
            }else if (indexPath.section == 2) {
                
                [deleteArr addObject:Three_SectonArr[indexPath.row]];
                
            }else if (indexPath.section == 3) {
                
                [deleteArr addObject:Four_SectonArr[indexPath.row]];
                
            }
            
            if (self.tableView.editing == YES) {
                
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                
            }else{
                [self sumtitData:deleteArr];
            }
   
        }
    }
    
}

- (void)sumtitData:(NSMutableArray *)arr{
    alert = [[DXAlertView alloc]initWithTitle:nil contentButton:nil leftButtonTitle:@"确定" rightButtonTitle:nil];
    
    [alert.alertButton addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    
    alert.alertContentTextView.delegate = self;
    
    alert.no_visitVC = self;
    [alert show];
    
    __block NSString *infos = [[NSString alloc] init];;
    
    for (No_visit_baselistEntity *entity in arr) {
        
        NSString *string = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",entity.num,entity.name,entity.company_level,entity.user_num,entity.user_name];
        
        infos = [infos stringByAppendingFormat:@"%@;",string];
        
    }
    
    alert.leftBlock = ^() {
        NSLog(@"left button clicked");
        
        if (alert.alertButton.titleLabel.text.length == 0) {
            ALERT_ERR_MSG(@"督办截止时间不能为空");
            return;
        }
        if (alert.alertContentTextView.text.length == 0) {
            ALERT_ERR_MSG(@"工作内容不能为空");
            return;
        }
        
        CommonService *service = [[CommonService alloc] init];
        
        UserEntity *entity = [UserEntity sharedInstance];
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               entity.user_id, @"create_id",
                               alert.alertButton.titleLabel.text, @"to_day",
                               alert.alertContentTextView.text , @"content",
                               infos,@"infos",
                               @"create_unvisit_task", @"method", nil];
        
        [service getNetWorkData:param  Successed:^(id entity) {
            NSNumber *state = [entity valueForKeyPath:@"state"];
            NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
            if ([strState isEqualToString:@"0"] == YES) {
                UIAlertView* alertt=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertt show];
            }
            else
            {
                UIAlertView* alertt=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertt show];
            }
            
        } Failed:^(int errorCode, NSString *message) {
            
        }];
    };
    alert.rightBlock = ^() {
        NSLog(@"right button clicked");
    };
    alert.dismissBlock = ^() {
        
        
    };
    
}

- (void)changeDate:(UIButton *)sender{

    [alert.alertContentTextView resignFirstResponder];
    //预约时间
    XYDatePicker *datePicker = [XYDatePicker datePicker];
    datePicker.delegate = self;
    datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker show];
    
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
    
    [alert.alertButton setTitle:dateStr forState:UIControlStateNormal];

}

- (void)getData:(NSString *)type andNum:(NSString *)num{

    self.Type = type;

//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.delegate = self;
//    HUD.labelText = @"努力加载中...";
//    
//    CommonService *service = [[CommonService alloc] init];
//    
//    NSDictionary *dict = @{@"method":@"company_list_unvisit",
//                           @"user_id":userEntity.user_id,
//                           };
//    
//    [service getNetWorkData:dict  Successed:^(id entity) {
//        NSNumber *state = [entity valueForKeyPath:@"state"];
//        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
//        
//        if ([strState isEqualToString:@"1"] == YES) {
//            [One_SectonArr removeAllObjects];
//            [Two_SectonArr removeAllObjects];
//            [Three_SectonArr removeAllObjects];
//            [Four_SectonArr removeAllObjects];
//            
//            NSMutableArray *arr = [[entity valueForKey:@"content"] valueForKey:@"all_company"];
//            for (NSDictionary *Attributes in arr) {
//                
//                No_visit_baselistEntity *entity = [[No_visit_baselistEntity alloc]init];
//                entity = [entity initWithAttributes:Attributes];
//                if (entity.visit_state == 1) {
//                     [Four_SectonArr addObject:entity];
//                }else if (entity.visit_state == 2){
//                    [Three_SectonArr addObject:entity];
//                }else if (entity.visit_state == 3){
//                    [Two_SectonArr addObject:entity];
//                }else if (entity.visit_state == 4){
//                    [One_SectonArr addObject:entity];
//                }
//               
//            }
//        }else{
//            
//            
//            
//        }
//
//        [self.tableView reloadData];
//        [HUD hide:YES];
//
//    } Failed:^(int errorCode, NSString *message) {
//        iToast *toast = [iToast makeText:@"无法连接到服务器"];
//        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
//        [toast setDuration:1000];
//        [toast show:iToastTypeNotice];
//        
//        [HUD hide:YES];
//        
//    }];
    
}

- (void)getDataNum:(NSString *)user_id{
    
    self.Type = @"2";
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntiy = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"method":@"get_unvisit_task_list",
                           @"user_id":userEntiy.user_id,
                           
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
           
            [unfinishArr removeAllObjects];
            [finishArr removeAllObjects];
            [finishdetailsArr removeAllObjects];
            
            NSDictionary *dic = [entity valueForKey:@"content"];
            
            unfinishStr = [dic objectForKey:@"unfinish_num"];
            finishStr = [dic objectForKey:@"finish_num"];
            
            if ([[dic objectForKey:@"unfinish_num"] intValue] > 0) {
                
                NSMutableArray *unfinish = [dic objectForKey:@"unfinish"];
                for (NSDictionary *Attributes in unfinish) {
                    
                    Handling_tasksEntity *entity = [[Handling_tasksEntity alloc]init];
                    entity = [entity initWithAttributes:Attributes];
                    
                    [unfinishArr addObject:entity];
                    
                }
            }
            
            if ([[dic objectForKey:@"finish_num"] intValue] > 0) {
                
                NSMutableArray *finish = [dic objectForKey:@"finishdetails"];
                for (NSDictionary *Attributes in finish) {

                    Handling_tasksEntity *entity = [[Handling_tasksEntity alloc]init];
                    entity = [entity initWithAttributes:[Attributes objectForKey:@"finish"]];
                    
                    [finishArr addObject:entity];
                    
                    VisiteTask *DetailEntity = [[VisiteTask alloc]init];
                    DetailEntity = [DetailEntity initWithAttributes:[Attributes objectForKey:@"detail"]];
                    
                    [finishdetailsArr addObject:DetailEntity];
                    
                }
            }
            
            
            
        }else{
  
        }
        
        [self.tableView reloadData];
        
        [HUD hide:YES];
        
    } Failed:^(int errorCode, NSString *message) {
        iToast *toast = [iToast makeText:@"无法连接到服务器"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:1000];
        [toast show:iToastTypeNotice];
        
        [HUD hide:YES];
    }];
}

- (void)sumtidata{
    
    if (deleteArr.count == 0) {
        ALERT_ERR_MSG(@"请先选择任务再派单");
    }else{
        
        [self sumtitData:deleteArr];
    }
    
    
}

- (void)selectde:(NSString *)str{
    
    Btn_TitleStr = str;
    
//    ALERT_ERR_MSG(@"全选");
    if ([str isEqualToString:@"多选"]) {
        
        [deleteArr removeAllObjects];
        
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        
        self.tableView.editing = !self.tableView.editing;
        
        if (self.tableView.editing) {
            
            
        }else{
            
            
        }

    }else if ([str isEqualToString:@"全选"]) {
        
        for (NSString *key in [selectedDic allKeys]) {
            switch ([key intValue]) {
                case 0:
                    for (int i = 0; i < One_SectonArr.count; i ++) {
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:[key intValue]];
                        
                        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                        
                        
                        [deleteArr addObject:One_SectonArr[i]];
                        
                    }
                    
                    break;
                case 1:
                    for (int i = 0; i < Two_SectonArr.count; i ++) {
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:[key intValue]];
                        
                        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                        
                        
                        [deleteArr addObject:Two_SectonArr[i]];
                        
                    }
                    
                    break;
                case 2:
                    for (int i = 0; i < Three_SectonArr.count; i ++) {
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:[key intValue]];
                        
                        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                        
                        
                        [deleteArr addObject:Three_SectonArr[i]];
                        
                    }
                    
                    break;
                case 3:
                    for (int i = 0; i < Four_SectonArr.count; i ++) {
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:[key intValue]];
                        
                        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                        
                        
                        [deleteArr addObject:Four_SectonArr[i]];
                        
                    }
                    
                    break;
                    
                default:
                    break;
            }
        }
        
    }else if ([str isEqualToString:@"取消"]) {
      
        self.tableView.editing = NO;
        
        [deleteArr removeAllObjects];
   
    }
    
}

- (NSString *)setLevel:(NSString *)company_level{
    
    NSString *level;
    
    switch ([company_level intValue]) {
        case 0:
            level = @"A+类客户";
            break;
        case 1:
            level = @"A1类客户";
            break;
        case 2:
            level = @"B1类客户";
            break;
        case 3:
            level = @"A2类客户";
            break;
        case 4:
            level = @"B2类客户";
            break;
        case 5:
            level = @"C1类客户";
            break;
        case 6:
            level = @"C2类客户";
            break;
        case 7:
            level = @"D类客户";
            break;
        case 99:
            level = @"未定级别";
            break;
        default:
            break;
    }
    return level;
}

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据

    if ([self.Type isEqualToString:@"1"]) {
         [self getData:@"1" andNum:@"1"];
    }
    if ([self.Type isEqualToString:@"2"]) {
        [self getDataNum:@"2"];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
