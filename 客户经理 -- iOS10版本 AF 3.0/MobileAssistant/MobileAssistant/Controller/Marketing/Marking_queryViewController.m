//
//  Marking_queryViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/29.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Marking_queryViewController.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "Marking_Detail_ListEntity.h"
#import "fourTableViewCell.h"
#import "Marking_detailViewController.h"
#import "Marking_listEntity.h"
#import "Marking_detail_ListViewController.h"

#define WIDTH self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height
#define MAINSCROLLHEIGHT self.view.bounds.size.height - 64

@interface Marking_queryViewController ()<UIScrollViewDelegate,MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource>
{
    Marking_listEntity *MarkingEntity;
    UITableView *tableview;
    MBProgressHUD *HUD;
    NSMutableArray *Marking_Detail_ListArr;
    UILabel *oneLabel;
    UILabel *twoLabel;
    UILabel *threeLabel;
    UILabel *fourLabel;
}

@end

@implementation Marking_queryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"营销活动ID查询";
    
    Marking_Detail_ListArr = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //横向分割线
    self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, (WIDTH - 1)/2, 2)];
    self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#0099CC"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//防止留白
    ////////////////////////////定义主页面//////////////////////////
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, MAINSCROLLHEIGHT)];
    _mainScrollView.contentSize = CGSizeMake(WIDTH * 2, MAINSCROLLHEIGHT);
    _mainScrollView.pagingEnabled = YES;//整个页面翻页
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    
    ////////////////////////////定义标题页面//////////////////////////
    _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    _titleScrollView.contentSize = CGSizeMake(WIDTH, 44);
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _titleScrollView.showsVerticalScrollIndicator = NO;
    _titleScrollView.delegate = self;
    
    [self addMyButtons];
    [self addMyViews];
    [self.view addSubview:self.lineLabel];
    [self.view addSubview:_mainScrollView];
    [self.view addSubview:_titleScrollView];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addMyButtons
{
    _button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (WIDTH - 1)/2, 38)];
    [_button1 setTitle:@"活动ID查询" forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1] forState:UIControlStateNormal];
    _button2 = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 1)/2 + 1, 0, (WIDTH - 1)/2, 38)];
    [_button2 setTitle:@"子活动ID查询" forState:UIControlStateNormal];
    [_button2 setTitleColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1] forState:UIControlStateNormal];
    
    _button1.titleLabel.font = [UIFont systemFontOfSize:13];
    _button2.titleLabel.font = [UIFont systemFontOfSize:13];

    
    _button1.backgroundColor = [UIColor colorWithRed:210.0/255 green:210.0/255 blue:210.0/255 alpha:1];
    _button2.backgroundColor = [UIColor colorWithRed:210.0/255 green:210.0/255 blue:210.0/255 alpha:1];

    
    _button1.tag = 1;
    _button2.tag = 2;

    
    
    [_button1 addTarget:self action:@selector(turn:) forControlEvents:UIControlEventTouchUpInside];
    [_button2 addTarget:self action:@selector(turn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [_titleScrollView addSubview:_button1];
    [_titleScrollView addSubview:_button2];
    
    
}

- (void)addMyViews
{
    _ActivityView = [[Activity_ID_queryView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, MAINSCROLLHEIGHT)];
    _ChildActivityView = [[ChildActivity_ID_queryView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, MAINSCROLLHEIGHT)];
   
    _ActivityView.certainButton.tag = 1;
    _ChildActivityView.certainButton.tag = 2;
    
    [_ActivityView.certainButton addTarget:self action:@selector(certainButton:) forControlEvents:UIControlEventTouchUpInside];
    [_ChildActivityView.certainButton addTarget:self action:@selector(certainButton:) forControlEvents:UIControlEventTouchUpInside];

    [_ActivityView.activity_titlename addTarget:self action:@selector(pushViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainScrollView addSubview:_ActivityView];
    [_mainScrollView addSubview:_ChildActivityView];

    
}


#pragma mark ------- scrollView的滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [UIView animateWithDuration:0.5 animations:^{
        _x = _mainScrollView.contentOffset.x;
        self.lineLabel.frame = CGRectMake( _x/self.mainScrollView.contentSize.width*WIDTH, 38, (WIDTH-1)/2, 2);
    }];
}

- (void)pushViewController:(UIButton *)sender{
    
    if (_ActivityView.activity_titlename.titleLabel.text.length == 0) {
       
        return;
        
    }else{
//        Marking_detailViewController *vc = [[Marking_detailViewController alloc]init];
//        
//        vc.entity = MarkingEntity;
//        
//        vc.field = @"content";
//        
//        
//        [self.navigationController pushViewController:vc animated:YES];
        Marking_detail_ListViewController *vc = [[Marking_detail_ListViewController alloc]init];
        
        vc.marketing_id = MarkingEntity.marketing_id;
        vc.name = MarkingEntity.name;
        vc.num = MarkingEntity.num;
        
        [self.navigationController pushViewController:vc animated:YES];

    }
    
}

- (void)turn:(UIButton*)sender{
    
    NSInteger i = sender.tag - 1;
    
    [_mainScrollView setContentOffset:CGPointMake(i * WIDTH, 0) animated:YES];

}

- (void)certainButton:(UIButton *)sender{

    if (sender.tag == 1) {
        
        [self getData_Activity];
        
    }else if(sender.tag == 2){
        
        [self getData_ChildActivity];
    }
    
}

#pragma mark - 获取活动ID信息
- (void)getData_Activity{
    
    [self.view endEditing:YES];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"get_marketing_list",
                           @"id":_ActivityView.activity_ID_query.text,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {

            NSDictionary *dic = [entity valueForKey:@"content"][0];
            
            MarkingEntity = [[Marking_listEntity alloc]init];
            MarkingEntity = [MarkingEntity initWithAttributes:dic];
            
            [_ActivityView.activity_titlename setTitle:[NSString stringWithFormat:@"活动ID:%@",[[[entity objectForKey:@"content"] objectAtIndex:0] objectForKey:@"num"]] forState:UIControlStateNormal];
            
        }else{
            
            [_ActivityView.activity_titlename setTitle:@"" forState:UIControlStateNormal];
            
            iToast *toast = [iToast makeText:@"暂无数据"];
            [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
            [toast setDuration:5000];
            [toast show:iToastTypeNotice];
        }

        [HUD hide:YES];

    } Failed:^(int errorCode, NSString *message) {
        iToast *toast = [iToast makeText:@"无法连接到服务器"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:5000];
        [toast show:iToastTypeNotice];
        
        [HUD hide:YES];
        
    }];

    
}
#pragma mark - 获取子活动ID信息
- (void)getData_ChildActivity{
    
    [self.view endEditing:YES];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"get_sub_marketing_list",
//                           @"marketing_id":_ChildActivityView.activity_ID_query.text,
                           @"id":_ChildActivityView.activity_ID_query.text,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        [Marking_Detail_ListArr removeAllObjects];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            [_ChildActivityView.activity_titlename setTitle:[[[entity objectForKey:@"content"] objectAtIndex:0] objectForKey:@"name"] forState:UIControlStateNormal];
            
            NSMutableArray *arr = [entity valueForKey:@"content"];
            for (NSDictionary *Attributes in arr) {
                Marking_Detail_ListEntity *entity = [[Marking_Detail_ListEntity alloc]init];
                entity = [entity initWithAttributes:Attributes];
                [Marking_Detail_ListArr addObject:entity];
            }
            
            [self setTableview];
            
        }else{
            
            [_ChildActivityView.activity_titlename setTitle:@"" forState:UIControlStateNormal];
            
            iToast *toast = [iToast makeText:@"暂无数据"];
            [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
            [toast setDuration:5000];
            [toast show:iToastTypeNotice];
        }
        
        [HUD hide:YES];
        
    } Failed:^(int errorCode, NSString *message) {
        iToast *toast = [iToast makeText:@"无法连接到服务器"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:5000];
        [toast show:iToastTypeNotice];
        
        [HUD hide:YES];
        
    }];
    
}

- (void)setTableview{
    
    if (tableview == nil) {
        
        tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, _ChildActivityView.activity_titlename.frame.origin.y, SCREEN_WIDTH, _ChildActivityView.frame.size.height - _ChildActivityView.activity_titlename.frame.origin.y)];
        tableview.delegate = self;
        tableview.dataSource = self;
        
        [_ChildActivityView addSubview:tableview];
    }else{
        
        [tableview reloadData];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return Marking_Detail_ListArr?Marking_Detail_ListArr.count + 1:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [twoLabel sizeThatFits:CGSizeMake(twoLabel.frame
                                                             .size.width, MAXFLOAT)];
    if (size.height == 0) {
        return 40;
    }
    return size.height + 24;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"fourTableViewCell";
    
    fourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    oneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, 40)];
    twoLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 40)];
    threeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/4, 40)];
    fourLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4 * 3, 0, SCREEN_WIDTH/4, 40)];
    
    oneLabel.font = [UIFont systemFontOfSize:13];
    oneLabel.textAlignment = NSTextAlignmentCenter;
    
    twoLabel.font = [UIFont systemFontOfSize:13];
    twoLabel.textAlignment = NSTextAlignmentCenter;
    twoLabel.numberOfLines = 0;
    
    threeLabel.font = [UIFont systemFontOfSize:13];
    threeLabel.textAlignment = NSTextAlignmentCenter;
    
    fourLabel.font = [UIFont systemFontOfSize:13];
    fourLabel.textAlignment = NSTextAlignmentCenter;
    
    [cell addSubview:oneLabel];
    [cell addSubview:twoLabel];
    [cell addSubview:threeLabel];
    [cell addSubview:fourLabel];
    if (indexPath.row == 0) {
        
        oneLabel.text = @"子活动ID";
        twoLabel.text = @"子活动名";
        threeLabel.text = @"活动生效时间";
        fourLabel.text = @"活动失效时间";

    }else{
        
        Marking_Detail_ListEntity *entity = [Marking_Detail_ListArr objectAtIndex:indexPath.row - 1];
        
        oneLabel.text = entity.num;
        twoLabel.text = entity.name;
        threeLabel.text = entity.start_time;
        fourLabel.text = entity.end_time;
        
        CGSize size = [twoLabel sizeThatFits:CGSizeMake(twoLabel.frame
                                                        .size.width, MAXFLOAT)];
        
        oneLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, size.height + 24);
        twoLabel.frame = CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, size.height + 24);
        threeLabel.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/4, size.height + 24);
        fourLabel.frame = CGRectMake(SCREEN_WIDTH/4 * 3, 0, SCREEN_WIDTH/4, size.height + 24);
        
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
