//
//  BasicMapAnnotation.h
//  baiduDemo
//
//  Created by apple on 13-9-30.
//  Copyright (c) 2013年 东和盛达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//#import "BMKAnnotation.h"
#import "VisiteTask.h"

@interface BasicMapAnnotation : NSObject<BMKAnnotation>

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * b_imageUrl;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) int number;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) VisiteTask *visiteTask;

-(id)initWithLatitude:(CLLocationDegrees)latitude
         andLongitude:(CLLocationDegrees)longitude
                 Type:(NSString *)type
                 VisiteTask:(VisiteTask *)visiteTask
                 Name:(NSString *)name
            BigImageUrl:(NSString *)imageUrl
         andInfoNumber:(int)number andArray:(NSArray *)array;
-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate withNum:(int)num ;

@end
