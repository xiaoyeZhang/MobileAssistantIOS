//
//  StateViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-16.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "StateViewController.h"
#import "NameTableViewCell.h"
#import "StateEntity.h"

@interface StateViewController ()

@end

@implementation StateViewController

@synthesize mutableArry, tableView;
@synthesize title, item;
@synthesize caVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = title;
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"StateViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"StateViewController"];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [mutableArry count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *couponTableViewCellIdentifier=@"NameTableViewCell";
    NameTableViewCell *cell = (NameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NameTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    StateEntity *entity = [mutableArry objectAtIndex:indexPath.row];
    
    cell.labelName.text = entity.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StateEntity * entity = [mutableArry objectAtIndex:indexPath.row];
    if (item == 1) {
        caVC.stateEntity1 = entity;
    } else if (item == 2) {
        caVC.stateEntity2 = entity;
    } else if (item == 3) {
        caVC.stateEntity3 = entity;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
