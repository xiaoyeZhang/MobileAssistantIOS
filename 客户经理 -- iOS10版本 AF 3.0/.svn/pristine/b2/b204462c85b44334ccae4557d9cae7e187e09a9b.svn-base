//
//  ContactViewController.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCreateViewController.h"
#import "Task_Two_CreateViewController.h"

//add by xy
@class ContactViewController;
@protocol ContactViewControllerDelegate <NSObject>

@optional
- (void)contactViewController:(ContactViewController *)vc didSelectClient:(ContactEntity *)entity;

@end
//end


@interface ContactViewController : XYBaseViewController

@property (nonatomic, strong) IBOutlet UITableView *tableViewContact;
@property (nonatomic, strong) NSMutableArray *arrayContact;
@property (nonatomic, strong) TaskCreateViewController *tcVC;
@property (nonatomic, strong) Task_Two_CreateViewController *t_two_cVC;

@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) CompEntity *compEntity;

@property(nonatomic, weak) id<ContactViewControllerDelegate> delegate; //add by xy

- (void) addContactObj:(ContactEntity *)entity;

@end


