//
//  Visit_list_detailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2016/11/10.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Visit_list_detailViewController.h"
#import "VisiteTask.h"
#import "TaskTableViewCell.h"
#import "VisitTaskDetailViewController.h"
#import "MBProgressHUD.h"

@interface Visit_list_detailViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *mutableArrayData;
    NSString *State;
    UIButton *rightBtn;
}
@property (strong, nonatomic) NSArray *cateArr;
@end

@implementation Visit_list_detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cateArr = @[@"所有",@"已完成",@"未完成"];
    
    mutableArrayData = [NSMutableArray array];
    
    State = @"-1";
    
    self.navigationItem.title = @"拜访任务工单流程查看";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    rightBtn = [self setNaviRightBtnWithTitle:@"所有"];
    rightBtn.frame = CGRectMake(0, 3, 50, 25);
    rightBtn.layer.borderWidth = 1;
    rightBtn.layer.cornerRadius = 5;
//    rightBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    rightBtn.backgroundColor = [UIColor whiteColor];
    [rightBtn setTitleColor:RGBA(80, 80, 80, 1) forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self getData];
}

#pragma mark - ButtonMethod
- (void)backBtnClicked:(id)sender
{
    [_dropDown hideDropDown:rightBtn];
    _dropDown = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ButtonMethod
- (void)rightBtnClicked:(id)sender
{
    [self cateBtnClicked:sender andWith:_cateArr];
}

#pragma mark - 表格视图数据源代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 84;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mutableArrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *couponTableViewCellIdentifier=@"TaskTableViewCell";
    
    TaskTableViewCell *cell = (TaskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TaskTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    VisiteTask *entity = [mutableArrayData objectAtIndex:indexPath.row];
    NSString *is_chiefStr = @"";
    
    if ([entity.is_chief isEqualToString:@"1"]) {
        is_chiefStr = @"首席走访-";
    }
    
    NSString *title = [NSString stringWithFormat:@"%@(%@待执行)", entity.title ,is_chiefStr];
    
    if ([entity.state isEqualToString:@"0"] == YES) {
        title = [NSString stringWithFormat:@"%@(%@待执行)", entity.title ,is_chiefStr];
        cell.imageView.image = [UIImage imageNamed:@"start-1"];
    } else if ([entity.state isEqualToString:@"1"] == YES) {
        title = [NSString stringWithFormat:@"%@(%@等待填写纪要)", entity.title ,is_chiefStr];
        cell.imageView.image = [UIImage imageNamed:@"summary-1"];
    } else if ([entity.state isEqualToString:@"2"] == YES) {
        title = [NSString stringWithFormat:@"%@(%@任务完成)", entity.title ,is_chiefStr];
        cell.imageView.image = [UIImage imageNamed:@"finish-1"];
    } else if ([entity.state isEqualToString:@"-1"] == YES) {
        title = [NSString stringWithFormat:@"%@(%@已撤销)", entity.title ,is_chiefStr];
        cell.imageView.image = [UIImage imageNamed:@"cancle-1"];
    } else if ([entity.state isEqualToString:@"-2"] == YES) {
        title = [NSString stringWithFormat:@"%@(%@待接受)", entity.title ,is_chiefStr];
        cell.imageView.image = [UIImage imageNamed:@"start-1"];
    }
    
    if (![entity.cacsi isEqualToString:@"-1"]) {
        cell.rateView.hidden = NO;
        cell.rateLbl.text = [NSString stringWithFormat:@"%@分",entity.cacsi];
    }else{
        cell.rateView.hidden = YES;
    }
    
    NSString *customer = [NSString stringWithFormat:@"联系人：%@", entity.name];
    NSString *name = [NSString stringWithFormat:@"客户：%@", entity.company_name];
    
    cell.labelContact.text = customer;
    cell.labelCustomer.text = name;
    cell.labelTitle.text = title;

    if ([entity.color isEqualToString:@"red"]) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",entity.time]];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 10)];
        
        cell.labelDate.attributedText = str;
        
    }else{
        
        cell.labelDate.text = entity.time;
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VisiteTask *entity = [mutableArrayData objectAtIndex:indexPath.row];
    VisitTaskDetailViewController *vc = [[VisitTaskDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.visiteTask = entity;
    
    [_dropDown hideDropDown:rightBtn];
    _dropDown = nil;
}

- (void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
//    method = visit_list_detail
//    $state = 0表示未完成  1表示已完成（含待填写纪要状态）
//    $actor_id = 上一个列表项中的actor_id
//    $company_name = 集团名称
//    start_time = 开始时间（YYYY-MM-DD）
//    end_time = 结束时间（YYYY-MM-DD）

    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = @{@"method":@"visit_list_detail",
                            @"state":State,
                            @"actor_id":self.actor_id,
                            @"company_name":self.company_name,
                            @"start_time":self.startTime,
                            @"end_time":self.endTime,
                            };;
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            
            for (NSDictionary* attributes in array) {
                VisiteTask *entity = [[VisiteTask alloc] init];
                entity = [entity initWithAttributes:attributes];
                [mutableArrayData addObject:entity];
            }
            
        }else
        {
            
        }
        
        [self.tableView reloadData];
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

- (void)cateBtnClicked:(UIButton * )sender andWith:(NSArray *)arr
{
    CGFloat height = 40*self.cateArr.count;
    
    if (sender.tag == _type) {
        
    }else{
        [_dropDown hideDropDown:sender];
        
        
        _dropDown = nil;
    }
    
    _type = sender.tag;
    
    if (!_dropDown) {
        _dropDown = [[NIDropDown alloc] showDropDown:sender height:&height titleArr:arr imgArr:nil direction:@"down"];
        _dropDown.delegate = self;
    }else{
        [_dropDown hideDropDown:sender];
        _dropDown = nil;
    }
}

- (void)niDropDownDelegateMethod:(NIDropDown *)sender didSelectIndex:(int)index
{
    
//    [rightBtn setTitleColor:RGBA(80, 80, 80, 1) forState:UIControlStateNormal];
    [_dropDown hideDropDown:rightBtn];
    [rightBtn setTitle:self.cateArr[index] forState:UIControlStateNormal];
    
    [mutableArrayData removeAllObjects];
    
    switch (index) {
        case 0:
            State = @"-1";
            break;
        case 1:
            State = @"1";
            break;
        case 2:
            State = @"0";
            break;
        default:
            break;
    }
    
    [self getData];
    
    _dropDown = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
