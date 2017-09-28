//
//  Marking_listViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/12.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Marking_listViewController.h"
#import "Ooe_LabelTableViewCell.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "Marking_detailViewController.h"
#import "Marking_listEntity.h"
#import "Matching_SectgionView.h"
#import "Marking_listTableViewCell.h"

@interface Marking_listViewController ()<MBProgressHUDDelegate,MJRefreshBaseViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    Marking_listTableViewCell *cell;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_fooder;
    MBProgressHUD *HUD;
    NSMutableDictionary *selectedDic;//二级列表是否展开状态
}
@property (assign, nonatomic) int pageNum;
@property (strong, nonatomic) NSMutableArray *arrayCutomer;
@property (strong, nonatomic) NSMutableArray *arrayCutomerTmep;
@property (strong, nonatomic) NSMutableArray *arrayCutomerAll;
@end

@implementation Marking_listViewController

- (void)dealloc{
    
    [_header free];
    [_fooder free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayCutomer = [[NSMutableArray alloc]init];
    self.arrayCutomerTmep = [[NSMutableArray alloc]init];
    self.arrayCutomerAll = [[NSMutableArray alloc]init];
    self.pageNum = 0;
    self.navigationItem.title = @"营销活动方案";
    
    self.tableView.tableFooterView = [[UITableView alloc]init];
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getData:self.pageNum];
    
    if (!selectedDic) {
        selectedDic = [[NSMutableDictionary alloc]init];
    }
    
    [selectedDic setObject:@"1" forKey:@"0"];
    [selectedDic setObject:@"1" forKey:@"1"];
    
//    [self addRefreshView];
}

- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.tableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [weakSelf.arrayCutomer removeAllObjects];
        
        [weakSelf getData:weakSelf.pageNum];
    };
    
    _fooder = [MJRefreshFooterView footer];
    _fooder.scrollView = self.tableView;
    
    
    _fooder.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weakSelf.pageNum = weakSelf.pageNum + 12;
        
        [weakSelf getData:weakSelf.pageNum];
        
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.arrayCutomer.count;
    }else if (section == 1){
        return self.arrayCutomerTmep.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([selectedDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]) {
        cell.iconImage.alpha = 1;
        return 90;
    }
    cell.iconImage.alpha = 0;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Matching_SectgionView *view = [[[NSBundle mainBundle] loadNibNamed:@"Matching_SectgionView" owner:nil options:nil] firstObject];
    
    view.sectionName.textColor = RGBA(65, 65, 65, 1);
    
    view.backgroundColor = RGBA(242, 242, 242, 1);
    
    if (section == 0) {
        view.sectionName.text = @"省级";
    }else if (section == 1) {
        view.sectionName.text = @"市级";
    }
    
    view.tag = section;
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTop:)];
    singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
    [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
    [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Marking_listTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Marking_listEntity *entity;
    
    if (indexPath.section == 0) {
        entity = [self.arrayCutomer objectAtIndex:indexPath.row];
        cell.iconBtn.tag = indexPath.row;
        
    }else if (indexPath.section == 1){
        
        cell.iconBtn.tag = indexPath.row + self.arrayCutomer.count;
        entity = [self.arrayCutomerTmep objectAtIndex:indexPath.row];
    }
    
    [cell.iconBtn addTarget:self action:@selector(goFQA:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.titleLabel.text = entity.name;
    cell.oneLabel.text = [NSString stringWithFormat:@"生效时间：%@   发布人：%@",entity.start_time,entity.user_name];
    cell.twoLabel.text = [NSString stringWithFormat:@"更新发布时间：%@",[entity.update_time substringToIndex:10]];
    cell.threeLabel.text = [NSString stringWithFormat:@"失效时间：%@",entity.end_time];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Marking_listEntity *entity;
    
    if (indexPath.section == 0) {
        entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    }else if (indexPath.section == 1){
        entity = [self.arrayCutomerTmep objectAtIndex:indexPath.row];
    }
        
    Marking_detailViewController *vc = [[Marking_detailViewController alloc]init];
    vc.entity = entity;
    vc.field = @"content";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goFQA:(UIButton *)sender{
    
    
    Marking_listEntity  *entity = [self.arrayCutomerAll objectAtIndex:sender.tag];

    Marking_detailViewController *vc = [[Marking_detailViewController alloc]init];
    vc.entity = entity;
    vc.field = @"faq";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)SingleTop:(UITapGestureRecognizer *)recognizer{
    
    NSInteger didsection = recognizer.view.tag;
    
    NSString *key = [NSString stringWithFormat:@"%ld",(long)didsection];
    
    if (![selectedDic objectForKey:key]) {
        [selectedDic setObject:@"1" forKey:key];
    }else{
        [selectedDic removeObjectForKey:key];
    }
    
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:didsection] withRowAnimation:UITableViewRowAnimationFade];
    
    
}

-(void)getData:(int)page{
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"get_marketing_list",
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            NSMutableArray *arr = [entity valueForKey:@"content"];
            for (NSDictionary *Attributes in arr) {
                Marking_listEntity *entity = [[Marking_listEntity alloc]init];
                entity = [entity initWithAttributes:Attributes];
                
                if([entity.level isEqualToString:@"0"])
                {
                    [self.arrayCutomer addObject:entity];
                }else if([entity.level isEqualToString:@"1"])
                {
                    [self.arrayCutomerTmep addObject:entity];
                }
                
                [self.arrayCutomerAll addObject:entity];
            }
            
            
        }else{
            
            self.pageNum = 0;
            
            [_fooder endRefreshing];
            
            iToast *toast = [iToast makeText:@"暂无数据"];
            [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
            [toast setDuration:5000];
            [toast show:iToastTypeNotice];
        }
        [self.tableView reloadData];
        [HUD hide:YES];
        [_fooder endRefreshing];
        [_header endRefreshing];
    } Failed:^(int errorCode, NSString *message) {
        iToast *toast = [iToast makeText:@"无法连接到服务器"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:5000];
        [toast show:iToastTypeNotice];
        
        [HUD hide:YES];
        [_fooder endRefreshing];
        [_header endRefreshing];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
