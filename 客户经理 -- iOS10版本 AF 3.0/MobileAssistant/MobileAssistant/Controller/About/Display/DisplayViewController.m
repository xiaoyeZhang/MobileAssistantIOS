
//
//  DisplayViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/3/20.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "DisplayViewController.h"
#import "MBProgressHUD.H"
#import "WebViewViewController.h"

@interface DisplayViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) NSMutableArray *arrayCutomer;

@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"全省客户经理服务指标展示";
    
    self.arrayCutomer = [NSMutableArray array];

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self loadData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayCutomer.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
    }
    cell.textLabel.text = [[self.arrayCutomer objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WebViewViewController *vc = [[WebViewViewController alloc]init];
    
    vc.strTitle = [[self.arrayCutomer objectAtIndex:indexPath.row] objectForKey:@"title"];
    vc.url = [[self.arrayCutomer objectAtIndex:indexPath.row] objectForKey:@"url"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)loadData{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    [self getData];
}

- (void)getData{
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *dic = @{@"method":@"display_index"};
    [service getNetWorkData:dic Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            for (NSDictionary *dic in [entity valueForKey:@"content"]) {
                
                [self.arrayCutomer addObject:dic];
                
            }
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
