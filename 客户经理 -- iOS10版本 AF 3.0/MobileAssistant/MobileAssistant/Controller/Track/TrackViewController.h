//
//  TrackViewController.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-8.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BMapKit.h"
#import "BasicMapAnnotation.h"

@interface TrackViewController : XYBaseViewController<BMKMapViewDelegate>

@property (strong,nonatomic) NSMutableArray *annotationArray;
@property (strong,nonatomic) NSMutableArray *mutableArray;

@property (strong, nonatomic) BMKMapView* mapView;

@end
