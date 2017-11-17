//
//  Marketing_CenterListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/12.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Marketing_CenterListViewController.h"
#import "MBProgressHUD.h"
#import "MarketingCaselistEntity.h"
#import "Marketing_CenterListTableViewCell.h"
#import "Marketing_CenterAllViewController.h"
#import "Marking_CenterDetailViewController.h"

@interface Marketing_CenterListViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    UserEntity *userEntity;
    NSMutableArray *arrayCustomerTemp;
    float cellHeight;
    UIButton *submitBtn;
    
}
@end

@implementation Marketing_CenterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"营销中心";
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    submitBtn = [self setNaviRightBtnWithTitle:@"我的推送"];
    submitBtn.frame = CGRectMake(0, 0, 100, 35);
    submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    userEntity = [UserEntity sharedInstance];
    arrayCustomerTemp = [NSMutableArray array];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    [self getDate];
}
//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitBtnClicked:(id)sender{

    Marketing_CenterAllViewController *vc = [[Marketing_CenterAllViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getDate{
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"m_case_list",
                           @"type":@"2",
                           @"user_id":userEntity.user_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        [arrayCustomerTemp removeAllObjects];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                MarketingCaselistEntity *entity = [[MarketingCaselistEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [arrayCustomerTemp addObject:entity];
            }
            
            
        }
        else
        {
            
        }
        
        [self.tableView reloadData];
        
        [HUD hide:YES];

    } Failed:^(int errorCode, NSString *message) {

        [HUD hide:YES];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrayCustomerTemp.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 64 + cellHeight + 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"Marketing_CenterListTableViewCell";
    Marketing_CenterListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.supportBtn.tag = indexPath.row;
        cell.reBtn.tag = indexPath.row;
        cell.shareBtn.tag = indexPath.row;
        
        [cell.supportBtn addTarget:self action:@selector(supportisClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.reBtn addTarget:self action:@selector(reisClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareBtn addTarget:self action:@selector(shareisClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    MarketingCaselistEntity *entity = [arrayCustomerTemp objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:entity.icon];
    
    [cell.iconImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    cell.titleLabel.text = entity.title;
    cell.timeLabel.text = entity.time;
    
    if ([entity.is_support isEqualToString:@"0"]) {
        cell.supportImage.image = [UIImage imageNamed:@"赞"];
    }else{
        cell.supportImage.image = [UIImage imageNamed:@"赞-拷贝"];
    }
    
    if (entity.share_num.length > 0) {
        [cell.shareBtn setTitle:[NSString stringWithFormat:@"分享 %@",entity.share_num] forState:UIControlStateNormal];
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 4; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f};
    
    CGSize size = [entity.summary boundingRectWithSize:CGSizeMake(cell.summaryLabel.frame.size.width, cell.summaryLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    cellHeight = size.height;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:entity.summary attributes:dic];
    cell.summaryLabel.attributedText = attributeStr;
    
//    cellHeight = [self heightForString:entity.summary fontSize:16 andWidth:cell.summaryLabel.frame.size.width];
//    cell.summaryLabel.text = entity.summary;

    int i= 0;
    
    NSMutableArray *reHeightArr = [NSMutableArray array];
    
    for (NSDictionary *dic in entity.re) {
        
//        NSString *comtent = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"name"],[dic objectForKey:@"content"]];
        
        NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
        paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
        paraStyle01.headIndent = 6.0f;//行首缩进
//        //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
        CGFloat emptylen = 6;
        paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
        
        NSMutableAttributedString *comtent = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",[dic objectForKey:@"name"],[dic objectForKey:@"content"]] attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
        
        [comtent addAttribute:NSForegroundColorAttributeName value:RGBA(52, 130, 224, 1) range:NSMakeRange(0, [[dic objectForKey:@"name"] length]+1)];
        
        int hightNum = 0;

        for (NSString *num in reHeightArr) {
            hightNum = hightNum + [num intValue];
        }

        UILabel *reLbael = [[UILabel alloc]init];
        
        if (entity.summary.length > 0) {
            reLbael.frame = CGRectMake(cell.summaryLabel.frame.origin.x, cell.supportView.frame.origin.y + cell.supportView.frame.size.height + 23 + hightNum, [UIScreen mainScreen].bounds.size.width - cell.summaryLabel.frame.origin.x - 12, [self heightForString:[comtent string] fontSize:15 andWidth:[UIScreen mainScreen].bounds.size.width - cell.summaryLabel.frame.origin.x + 10] - 10);
            
        }else{
            
            reLbael.frame = CGRectMake(cell.summaryLabel.frame.origin.x, cell.supportView.frame.origin.y + cell.supportView.frame.size.height - 8 + hightNum, [UIScreen mainScreen].bounds.size.width - cell.summaryLabel.frame.origin.x - 12, [self heightForString:[comtent string] fontSize:15 andWidth:[UIScreen mainScreen].bounds.size.width - cell.summaryLabel.frame.origin.x + 10] - 10);
            
        }

        reLbael.lineBreakMode = NSLineBreakByCharWrapping;
        [reLbael setFont:[UIFont systemFontOfSize:15]];
        reLbael.numberOfLines = 0;
        reLbael.backgroundColor = RGBA(232, 232, 232, 1);
        reLbael.textColor = RGBA(94, 94, 94, 1);
        
        [reHeightArr addObject:[NSString stringWithFormat:@"%f",reLbael.frame.size.height]];
        
        if (entity.summary.length > 0) {

            cellHeight = cellHeight + reLbael.frame.size.height;

        }else{
            
            cellHeight = cellHeight + reLbael.frame.size.height - 10;

        }
        
        reLbael.attributedText = comtent;
        
        [cell addSubview:reLbael];
        
        i++;
    }
    
//    NSString *comtentStr = @"";
//    
//    for (NSDictionary *dic in entity.re) {
//        
//        NSString *comtent = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"name"],[dic objectForKey:@"content"]];
//    
////        NSMutableAttributedString *comtent = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"name"],[dic objectForKey:@"content"]]];
////        
////        [comtent addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [[dic objectForKey:@"name"] length]+1)];
//        
//        if (comtentStr.length == 0) {
//            comtentStr = [NSString stringWithFormat:@"%@",comtent];
//
//        }else{
//            comtentStr = [NSString stringWithFormat:@"%@\n%@",comtentStr,comtent];
//        }
//        
//    }
//    
//    NSMutableAttributedString *comtent = [[NSMutableAttributedString alloc]initWithString:comtentStr];
//    
//    cell.ComentLabel.text = comtentStr;
//    
//    cellHeight = cellHeight + [self heightForString:comtentStr fontSize:15 andWidth:[UIScreen mainScreen].bounds.size.width - cell.summaryLabel.frame.origin.x - 15];;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MarketingCaselistEntity *entity = [arrayCustomerTemp objectAtIndex:indexPath.row];
    
    [self sumbitisClick:@"0" andMarks:@"" andCase_id:entity.case_id addEntity:entity];
}

//点赞
- (void)supportisClick:(UIButton *)sender{
    
    MarketingCaselistEntity *entity = [arrayCustomerTemp objectAtIndex:sender.tag];
    
    if ([entity.is_support isEqualToString:@"0"]) {
        
        [self sumbitisClick:@"1" andMarks:@"" andCase_id:entity.case_id addEntity:entity];

    }
    
}
//评论
- (void)reisClick:(UIButton *)sender{
    
    MarketingCaselistEntity *entity = [arrayCustomerTemp objectAtIndex:sender.tag];
    
    UIAlertController *contoller = [UIAlertController alertControllerWithTitle:@"评论" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [contoller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入评论内容";
        
        textField.returnKeyType = UIReturnKeyDone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *Marks = contoller.textFields.firstObject;

        [self sumbitisClick:@"3" andMarks:Marks.text andCase_id:entity.case_id addEntity:entity];

    }];
    
    otherAction.enabled = NO;
    
    [contoller addAction:cancelAction];
    [contoller addAction:otherAction];
    [self presentViewController:contoller animated:YES completion:nil];//弹出提醒框
    

    
}
//分享
- (void)shareisClick:(UIButton *)sender{

    MarketingCaselistEntity *entity = [arrayCustomerTemp objectAtIndex:sender.tag];
    // 设置分享内容
    NSString *text = entity.summary;
    //UIImage *image = [UIImage imageNamed:@"1.png"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",entity.url]];
//    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSArray *activityItems = @[text,url];

    // 服务类型控制器
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalInPopover = true;
    [self presentViewController:activityViewController animated:YES completion:nil];

    // 选中分享类型
    [activityViewController setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        
        // 显示选中的分享类型
        NSLog(@"act type %@",activityType);

        if (completed) {
            
            [self sumbitisClick:@"2" andMarks:@"" andCase_id:entity.case_id addEntity:entity];
            
            NSLog(@"ok");
        }else {
            NSLog(@"no ok");
        }
        
    }];
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        
        UITextField *mark = alertController.textFields.firstObject;

        UIAlertAction *okAction = alertController.actions.lastObject;
        
        okAction.enabled = mark.text.length > 0 && mark.text.length < 40;
        
    }
}

- (void)sumbitisClick:(NSString *)op andMarks:(NSString *)marks andCase_id:(NSString *)case_id addEntity:(MarketingCaselistEntity *) Entity{
    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.delegate = self;
//    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"m_case_op",
                           @"case_id":case_id,
                           @"user_id":userEntity.user_id,
                           @"op":op,
                           @"marks":marks,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        
        if ([state intValue] > 0) {
            
            if ([op isEqualToString:@"1"]) {
                
                iToast *toast = [iToast makeText:@"点赞成功"];
                [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                [toast setDuration:500];
                [toast show:iToastTypeNotice];
                
            }else if ([op isEqualToString:@"0"]){
                Marking_CenterDetailViewController *vc = [[Marking_CenterDetailViewController alloc]init];
                
                vc.url = Entity.url;
                vc.Title = Entity.title;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
        else
        {
            
        }
        
        [self getDate];
        
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
