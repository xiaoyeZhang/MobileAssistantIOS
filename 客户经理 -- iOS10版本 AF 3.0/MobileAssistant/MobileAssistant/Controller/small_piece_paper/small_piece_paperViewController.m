//
//  small_piece_paperViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/12.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "small_piece_paperViewController.h"
#import "Small_prece_paperTableViewCell.h"
#import "MBProgressHUD.h"
#import "small_piece_paperEntity.h"
#import "small_piece_paperSubmitViewController.h"
#import "small_piece_paperDetailViewController.h"

@interface small_piece_paperViewController ()<MBProgressHUDDelegate>
{
    UserEntity *userInfo;
    MBProgressHUD *HUD;
    NSString *unreply;  //    0表示获取未回复数据 1表示获得已回复数据
    
    NSMutableArray *no_replyArr;
    NSMutableArray *Already_replyArr;
}
@end

@implementation small_piece_paperViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"小纸条";
    
    unreply = @"0";
    
    no_replyArr = [[NSMutableArray alloc]init];
    Already_replyArr = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.no_replyNum.alpha = 0;
    self.Already_replyNum.alpha = 0;
    
    [self setTape_num];

    if ([self.tape_num intValue] <= 0) {
        [self gettape_num];
    }
    
    self.view.backgroundColor = RGBA(242, 242, 242, 1);
    self.tableView.backgroundColor = RGBA(242, 242, 242, 1);
    
    self.No_reply.layer.borderWidth = 1;
    self.Already_reply.layer.borderWidth = 1;
    
    self.No_reply.layer.borderColor = RGBA(66, 187, 233, 1).CGColor;
    self.Already_reply.layer.borderColor = RGBA(66, 187, 233, 1).CGColor;
    
    self.No_reply.backgroundColor = RGBA(66, 187, 233, 1);
    [self.No_reply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBezierPath *No_replyPath = [UIBezierPath bezierPathWithRoundedRect:self.No_reply.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *No_replyLayer = [[CAShapeLayer alloc] init];
    No_replyLayer.frame = self.No_reply.bounds;
    No_replyLayer.path = No_replyPath.CGPath;
    self.No_reply.layer.mask = No_replyLayer;
    
    UIBezierPath *Already_replyPath = [UIBezierPath bezierPathWithRoundedRect:self.Already_reply.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *Already_replyLayer = [[CAShapeLayer alloc] init];
    Already_replyLayer.frame = self.Already_reply.bounds;
    Already_replyLayer.path = Already_replyPath.CGPath;
    self.Already_reply.layer.mask = Already_replyLayer;
 
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTape_num{
    //客户经理才能提交
    userInfo = [UserEntity sharedInstance];
    
    if ([userInfo.type_id intValue] == ROLE_CUSTOMER) {
        
        if ([self.tape_num intValue]> 0) {
            
            self.no_replyNum.alpha = 1;
            self.no_replyNum.text = self.tape_num;
            
        }else{
            
            self.no_replyNum.alpha = 0;
        }
        
    }else{
        
        UIButton *addBtn = [self setNaviRightBtnWithTitle:@"添加"];
        [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.tape_num intValue]> 0) {
            
            self.Already_replyNum.alpha = 1;
            self.Already_replyNum.text = self.tape_num;
            
        }else{
            
            self.Already_replyNum.alpha = 0;
        }
        
    }

   self.UnreadNum.text = [NSString stringWithFormat:@"未读%@条",self.tape_num?self.tape_num:@"0"];
    
}
//添加
- (void)addBtnClicked:(id)sender
{
    
    small_piece_paperSubmitViewController *vc = [[small_piece_paperSubmitViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([unreply isEqualToString:@"0"]) {
        return no_replyArr.count;
    }else if ([unreply isEqualToString:@"1"]){
        return Already_replyArr.count;
        
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *couponTableViewCellIdentifier=@"Small_prece_paperTableViewCell";
    Small_prece_paperTableViewCell *cell = (Small_prece_paperTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"Small_prece_paperTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        
        cell.backgroundColor = RGBA(242, 242, 242, 1);
        
        cell.bgView.layer.borderWidth = 1;
        cell.bgView.layer.borderColor = RGBA(225, 225, 225, 1).CGColor;
    }
    
    small_piece_paperEntity *entity;
    
    if ([unreply isEqualToString:@"0"]) {

        entity = [no_replyArr objectAtIndex:indexPath.row];
        
    }else if ([unreply isEqualToString:@"1"]){
        
        entity = [Already_replyArr objectAtIndex:indexPath.row];
        
    }
    
    cell.titleLabel.text = [NSString stringWithFormat:@"主题：%@",entity.title];
    
    if ([entity.isnew isEqualToString:@"0"]) {
        cell.isNewLabel.alpha = 0;
    }else if ([entity.isnew isEqualToString:@"1"]) {
        cell.isNewLabel.alpha = 1;
    }
    
    cell.messageLabel.text = [NSString stringWithFormat:@"内容：%@",entity.content];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"客户经理姓名：%@",entity.user_name];
    cell.timeLabel.text = [NSString stringWithFormat:@"发送时间：%@",entity.create_time];
    
    
    if (entity.img_name.length > 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 18)];
        label.text = cell.titleLabel.text;
        CGSize size = [label sizeThatFits:CGSizeMake(label.frame
                                                               .size.width, MAXFLOAT)];
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(size.width + cell.titleLabel.frame.origin.x+3, 13, 18, 18)];
        iconImage.image = [UIImage imageNamed:@"icon_has_img"];
        [cell addSubview:iconImage];
    }
    
    return cell;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    
    small_piece_paperEntity *entity;
    
    if ([unreply isEqualToString:@"0"]) {
        
        entity = [no_replyArr objectAtIndex:indexPath.row];
        
    }else if ([unreply isEqualToString:@"1"]){
        
        entity = [Already_replyArr objectAtIndex:indexPath.row];
        
    }
    
    [self doTape_read:entity.tape_id];
    
    small_piece_paperDetailViewController *vc = [[small_piece_paperDetailViewController alloc]init];
    vc.entity = entity;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getData
{
    

    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           userInfo.user_id, @"user_id",
                           unreply, @"unreply",
                           @"tape_list", @"method", nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        [no_replyArr removeAllObjects];
        
        [Already_replyArr removeAllObjects];
        
        if ([strState isEqualToString:@"0"] == YES) {

        } else {
            
            NSMutableArray *array = [entity objectForKey:@"content"];
       
            for (NSDictionary* attributes in array) {
                small_piece_paperEntity *entity = [[small_piece_paperEntity alloc] init];
                entity = [entity initWithAttributes:attributes];

                if ([unreply isEqualToString:@"0"]) {
                    [no_replyArr addObject:entity];
                }else if ([unreply isEqualToString:@"1"]){
                    [Already_replyArr addObject:entity];
                }
                
            }

        }
        
        [self.tableView reloadData];
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

- (void)doTape_read:(NSString *)tape_id
{
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           userInfo.user_id, @"user_id",
                           tape_id, @"tape_id",
                           @"tape_read", @"method", nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];

        if ([strState isEqualToString:@"0"] == YES) {
            
            
        } else {
            
            
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
        

    } Failed:^(int errorCode, NSString *message) {
        
    }];
}

- (IBAction)changeState:(UIButton *)sender {
    
    if (sender.tag == 0) {
        
        unreply = @"0";
        
        self.No_reply.backgroundColor = RGBA(66, 187, 233, 1);
        [self.No_reply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.Already_reply.backgroundColor = RGBA(242, 242, 242, 1);
        [self.Already_reply setTitleColor:RGBA(66, 187, 233, 1) forState:UIControlStateNormal];
    }
    
    if (sender.tag == 1) {
        
        unreply = @"1";
        
        self.Already_reply.backgroundColor = RGBA(66, 187, 233, 1);
        [self.Already_reply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.No_reply.backgroundColor = RGBA(242, 242, 242, 1);
        [self.No_reply setTitleColor:RGBA(66, 187, 233, 1) forState:UIControlStateNormal];
    }
    
    [self getData];
}

#pragma mark - 小纸条脚标
- (void)gettape_num
{
    NSDictionary *dict = @{@"user_id":userInfo.user_id,
                           @"method":@"tape_num"};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      
                      self.tape_num = entity[@"state"];
                      
                      [self setTape_num];
                      
//                      self.UnreadNum.text = [NSString stringWithFormat:@"未读%@条",self.tape_num];
     
     
                      [_tableView reloadData];
                      
                      
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];
    
}

#pragma mark - 刷新数据

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
   
    [self getData];
    
    [self gettape_num];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
