//
//  LocationViewViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/6.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@interface LocationViewViewController : XYBaseViewController

@property (strong, nonatomic) BMKMapView* mapView;

@property (nonatomic, strong) NSString *time_type;

@property (strong, nonatomic) IBOutlet UIView *viewCondition;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UIView *Map_View;
@property (weak, nonatomic) IBOutlet UILabel *personLadbel;
@property (weak, nonatomic) IBOutlet UILabel *person_name;
@property (weak, nonatomic) IBOutlet UILabel *person_time;
@property (weak, nonatomic) IBOutlet UILabel *person_address;
@property (weak, nonatomic) IBOutlet UILabel *person_loction;
@end
