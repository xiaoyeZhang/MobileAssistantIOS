//
//  No_visit_baselistViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/5/3.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "No_visit_baselistViewController.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "Matching_SectgionView.h"
#import "No_visit_Detail_ListViewController.h"

#define WIDTH self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height
#define MAINSCROLLHEIGHT self.view.bounds.size.height - 104
@interface No_visit_baselistViewController ()<UIScrollViewDelegate,MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *leftTableView;
    MBProgressHUD *HUD;
    UILabel *label1;
    UILabel *label2;
    
    UIButton *rightBtn;
    UIButton *rightBtnTwo;
    
    NSMutableArray *arry;
    UIBarButtonItem *rightBtnitem;
    NSString *Type;
}
@end

@implementation No_visit_baselistViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arry = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"拜访任务";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UserEntity *userEntity = [UserEntity sharedInstance];
//    if ([userEntity.type_id intValue] == ROLE_CUSTOMER) {
//        
//        
//    }else{
//        
//        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        rightBtn.frame = CGRectMake(0, 0, 44, 44);
//        [rightBtn setTitle:@"多选" forState:UIControlStateNormal];
//        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        
//        rightBtnitem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//        
//        self.navigationItem.rightBarButtonItems = @[rightBtnitem];
//        
//        [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
//    [self getData:@"1"];
    [self getDataNum];
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(UIButton *)sender{
    
    [_No_visit_sumList1 selectde:sender.titleLabel.text];
    
    
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

- (void)addMyButtons
{
    _button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (WIDTH - 1)/2, 38)];
    [_button1 setTitle:@"未拜访" forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1] forState:UIControlStateNormal];
    _button2 = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 1)/2 + 1, 0, (WIDTH - 1)/2, 38)];
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    if ([userEntity.type_id intValue] == ROLE_CUSTOMER) {
        
        [_button2 setTitle:@"领导督办我的(0)" forState:UIControlStateNormal];
    }else{
        
        [_button2 setTitle:@"我督办的" forState:UIControlStateNormal];
    
    }
    
    [_button2 setTitleColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1] forState:UIControlStateNormal];
    
    _button1.titleLabel.font = [UIFont systemFontOfSize:15];
    _button2.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    _button1.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1];
    _button2.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1];
 
    _button1.tag = 1;
    _button2.tag = 2;
    
    
    [_button1 addTarget:self action:@selector(turn:) forControlEvents:UIControlEventTouchUpInside];
    [_button2 addTarget:self action:@selector(turn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_titleScrollView addSubview:_button1];
    [_titleScrollView addSubview:_button2];
    
}

- (void)addMyViews
{
//    label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 35)];
    label1.textAlignment = NSTextAlignmentCenter;
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    if ([userEntity.type_id intValue] == ROLE_CUSTOMER) {
        
        label1.text = @"超期未拜访总数  0户";
    }else{
        
        label1.text = @"客户总数：0户       客户经理人数：0人";
        
    }
    
    
    label1.textColor = [UIColor redColor];
    
    [_mainScrollView addSubview:label1];
    
    _No_visit_sumList1 = [[No_visit_sumListView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, MAINSCROLLHEIGHT - 35)];
    _No_visit_sumList2 = [[No_visit_sumListView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, MAINSCROLLHEIGHT)];
    
    
    
    leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, MAINSCROLLHEIGHT - 35) style:UITableViewStylePlain];
    leftTableView.tableFooterView = [[UITableView alloc]init];
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.editing = NO;
        
 
    [_mainScrollView addSubview:leftTableView];
    [_mainScrollView addSubview:_No_visit_sumList2.tableView];
    
    [_No_visit_sumList1 getData:@"1" andNum:self.num];

    [_No_visit_sumList2 getDataNum:self.user_id];
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == leftTableView) {
        
        return 4;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Matching_SectgionView *view = [[[NSBundle mainBundle] loadNibNamed:@"Matching_SectgionView" owner:nil options:nil] firstObject];
    
    view.sectionName.textColor = RGBA(65, 65, 65, 1);
    
    view.backgroundColor = [UIColor whiteColor];
    
    NSArray *countArr = [NSArray arrayWithObjects:@"6",@"3",@"2",@"1", nil];
    
    NSString *countNum = countArr[section];
    
    //    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"超期%@个月以上    （%@）",countNum,countStr]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"超期%@个月以上   ",countNum]];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(11+countNum.length,countStr.length)];
    
    if (tableView == leftTableView) {
        Type = @"1";
        view.icon.alpha = 0;
        view.sectionName.attributedText = str;
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
    
    if ([Type isEqualToString:@"1"]) {
        
        
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
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

#pragma mark------- scrollView的滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [UIView animateWithDuration:0.5 animations:^{
        _x = _mainScrollView.contentOffset.x;
        self.lineLabel.frame = CGRectMake( _x/self.mainScrollView.contentSize.width*WIDTH, 38, (WIDTH-1)/2, 2);
    }];
    
    if (_x == 0) {
//        [_No_visit_sumList1 getData:@"1" andNum:self.num];
        
        [UIView animateWithDuration:0.3 animations:^{
            rightBtn.alpha = 1;
            rightBtnTwo.alpha = 1;
        }];
        
    }else if (_x == WIDTH) {
        [_No_visit_sumList2 getDataNum:self.user_id];
        
        [UIView animateWithDuration:0.3 animations:^{
            rightBtn.alpha = 0;
            rightBtnTwo.alpha = 0;
        }];
        
    }

}

- (void)turn:(UIButton*)sender{
    
    NSInteger i = sender.tag - 1;
    
    [_mainScrollView setContentOffset:CGPointMake(i * WIDTH, 0) animated:YES];
    
}

- (void)getData:(NSString *)type{
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"method":@"company_list_unvisit",
                           @"user_id":userEntity.user_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            if ([userEntity.type_id intValue] == ROLE_CUSTOMER) {
                
                label1.text = [NSString stringWithFormat:@"超期未拜访总数  %@户",[[entity valueForKeyPath:@"content"] objectForKey:@"company_count"]];
                
            }else{
                
                label1.text = [NSString stringWithFormat:@"客户总数：%@户       客户经理人数：%@人",[[entity valueForKeyPath:@"content"] objectForKey:@"company_count"],[[entity valueForKeyPath:@"content"] objectForKey:@"user_count"]];
                
            }
            
        }else{
            
            
            
        }

    } Failed:^(int errorCode, NSString *message) {
        
    }];
    
}

- (void)getDataNum{
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"method":@"get_unvisit_task_list",
                           @"user_id":userEntity.user_id,
                           
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            if ([userEntity.type_id intValue] == ROLE_CUSTOMER) {
                
                [_button2 setTitle:[NSString stringWithFormat:@"领导督办我的(%@)",[[entity valueForKeyPath:@"content"] objectForKey:@"unfinish_num"]] forState:UIControlStateNormal];
            }else{
                
                [_button2 setTitle:@"我督办的" forState:UIControlStateNormal];
                
            }
            
        }else{
            
        }
        
    } Failed:^(int errorCode, NSString *message) {

    }];
}

- (void)rightBtnTWOClicked:(UIButton *)sender{
    
     [_No_visit_sumList1 sumtidata];
    
}

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    
//    [self getData:@"1"];
    [self getDataNum];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
