//
//  Marking_detail_ListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/18.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Marking_detail_ListViewController.h"
#import "MBProgressHUD.h"
#import "Marking_Detail_ListEntity.h"
#import "Matching_SectgionView.h"
#import "TwoTableViewCell.h"

@interface Marking_detail_ListViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *Marking_Detail_ListArr;
}
@end

@implementation Marking_detail_ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"营销活动ID";
    
    Marking_Detail_ListArr = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getData];
}

#pragma mark - ButtonMethod
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Marking_Detail_ListArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Matching_SectgionView *view = [[[NSBundle mainBundle] loadNibNamed:@"Matching_SectgionView" owner:nil options:nil] firstObject];
    view.sectionName.text = @"";
    view.icon.alpha = 0;
    UILabel *IDlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 44)];
    
    IDlabel.textAlignment = NSTextAlignmentCenter;
    
    IDlabel.text = @"活动ID";
    
    [view addSubview:IDlabel];
    
    UILabel *Namelabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, SCREEN_WIDTH - 120, 44)];
    
    Namelabel.textAlignment = NSTextAlignmentCenter;

    Namelabel.text = @"活动名";
    
    [view addSubview:Namelabel];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TwoTableViewCell";
    
    TwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        
        
        cell.OneLabel.text = self.num;
        cell.twoLabel.text = self.name;
        
    }else{
        
        Marking_Detail_ListEntity *entity = [Marking_Detail_ListArr objectAtIndex:indexPath.row - 1];
       
        cell.icon.alpha = 0;
        cell.OneLabel.text = entity.num;
        cell.twoLabel.text = entity.name;

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)getData{
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"get_sub_marketing_list",
                           @"marketing_id":self.marketing_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            NSMutableArray *arr = [entity valueForKey:@"content"];
            for (NSDictionary *Attributes in arr) {
                Marking_Detail_ListEntity *entity = [[Marking_Detail_ListEntity alloc]init];
                entity = [entity initWithAttributes:Attributes];
                [Marking_Detail_ListArr addObject:entity];
            }
        }else{
            

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
