//
//  No_visit_Detail_ListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/8/12.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "No_visit_Detail_ListViewController.h"
#import "MJRefresh.h"
#import "No_visit_baselistEntity.h"
#import "No_visit_TaskTableViewCell.h"
#import "MBProgressHUD.h"
#import "XYDatePicker.h"
#import "DXAlertView.h"
#import "TaskCreateViewController.h"

@interface No_visit_Detail_ListViewController ()<MBProgressHUDDelegate,XYDatePickerDelegate,UITextViewDelegate>
{
    DXAlertView *alert;
    MBProgressHUD *HUD;
    No_visit_TaskTableViewCell *cell;
    NSMutableArray *listMuArr;
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
    
    NSMutableArray *deleteArr;
    
    UIButton *rightBtn;
    UIButton *rightBtnTwo;
    UIBarButtonItem *rightBtnitem;
}
@end

@implementation No_visit_Detail_ListViewController

- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.name;
    
    deleteArr = [[NSMutableArray alloc]init];
    
    listMuArr = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.editing = NO;
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    if ([userEntity.type_id intValue] == ROLE_CUSTOMER) {
        
        
    }else{
        
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, 44, 44);
        [rightBtn setTitle:@"多选" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        rightBtnitem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        
        self.navigationItem.rightBarButtonItems = @[rightBtnitem];
        
        [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.currentPage = 0;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    [self getDataNum:self.currentPage];
    
    [self addRefreshView];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = _tableView;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weakSelf.currentPage = 0;
       
        [listMuArr removeAllObjects];
        [deleteArr removeAllObjects];
        [weakSelf getDataNum:weakSelf.currentPage];
    };
    
    refreshFooter = [MJRefreshFooterView footer];
    refreshFooter.scrollView = _tableView;
    refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [deleteArr removeAllObjects];
        
        [weakSelf getDataNum:[listMuArr count]];
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listMuArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    CGSize size = [cell.titleLabel sizeThatFits:CGSizeMake(cell.titleLabel.frame.size.width, MAXFLOAT)];
    if (size.height == 0) {
        return 70;
    }
    return size.height + 50;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"No_visit_TaskTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
    }
    if (listMuArr.count > 0) {
        
        No_visit_baselistEntity *entity = [listMuArr objectAtIndex:indexPath.row];
        
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
     
    }
   
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

//取消选中时 将存放在self.deleteArr中的数据移除

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   [deleteArr removeObject:listMuArr[indexPath.row]];
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    if ([userEntity.type_id intValue] == ROLE_CUSTOMER){
        
        TaskCreateViewController *vc = [[TaskCreateViewController alloc]init];

        vc.No_visit_Entity = [listMuArr objectAtIndex:indexPath.row];

        [self.navigationController pushViewController:vc animated:YES];

    }else{

        [deleteArr addObject:listMuArr[indexPath.row]];
        
        if (self.tableView.editing == YES) {
            
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }else{
            [self sumtitData:deleteArr];
        }

    }
    
}

- (void)getDataNum:(int)page{
    
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"method":@"company_list_unvisit",
                           @"user_id":userEntity.user_id,
                           @"location":@(page),
                           @"visit_state":self.visit_state,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {

            NSMutableArray *arr = [entity valueForKey:@"content"];
            for (NSDictionary *Attributes in arr) {

                No_visit_baselistEntity *entity = [[No_visit_baselistEntity alloc]init];
                entity = [entity initWithAttributes:Attributes];
     
                [listMuArr addObject:entity];
            }
            
            if ([rightBtn.titleLabel.text isEqualToString:@"取消"]) {
                
                [rightBtn setTitle:@"全选" forState:UIControlStateNormal];
                
            }
            
        }else{
            
        }
        [self.tableView reloadData];
        [HUD hide:YES];
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
    }];
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

- (void)rightBtnClicked:(UIButton *)sender{
    
     [self selectde:sender.titleLabel.text];
    
    if ([sender.titleLabel.text isEqualToString:@"多选"]) {
        
        rightBtnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtnTwo.frame = CGRectMake(0, 0, 44, 44);
        [rightBtnTwo setTitle:@"派单" forState:UIControlStateNormal];
        rightBtnTwo.titleLabel.font = [UIFont systemFontOfSize:16];
        
        UIBarButtonItem *rightBtnTwoitem = [[UIBarButtonItem alloc] initWithCustomView:rightBtnTwo];
        
        [rightBtnTwo addTarget:self action:@selector(rightBtnTWOClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItems = @[rightBtnitem,rightBtnTwoitem];
        
        
        [rightBtn setTitle:@"全选" forState:UIControlStateNormal];
        
        
    }else  if ([sender.titleLabel.text isEqualToString:@"全选"]) {
        
        rightBtnTwo.alpha = 1;
        [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        
    }else  if ([sender.titleLabel.text isEqualToString:@"取消"]) {
        
        rightBtnTwo.alpha = 0;
        [rightBtn setTitle:@"多选" forState:UIControlStateNormal];
        
    }
    
    
}

- (void)selectde:(NSString *)str{
    
    //    ALERT_ERR_MSG(@"全选");
    if ([str isEqualToString:@"多选"]) {
        
        [deleteArr removeAllObjects];
        
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        
        self.tableView.editing = !self.tableView.editing;
        
        if (self.tableView.editing) {
            
            
        }else{
            
            
        }
        
    }else if ([str isEqualToString:@"全选"]) {
      
        for (int i = 0; i < listMuArr.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            
            [deleteArr addObject:listMuArr[i]];
            
        }
        
    }else if ([str isEqualToString:@"取消"]) {
        
        self.tableView.editing = NO;
        
        [deleteArr removeAllObjects];
        
    }
    
}

- (void)rightBtnTWOClicked:(UIButton *)sender{
    
    [self sumtidata];
    
}

- (void)sumtidata{
    
    if (deleteArr.count == 0) {
        ALERT_ERR_MSG(@"请先选择任务再派单");
    }else{
        
        [self sumtitData:deleteArr];
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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
