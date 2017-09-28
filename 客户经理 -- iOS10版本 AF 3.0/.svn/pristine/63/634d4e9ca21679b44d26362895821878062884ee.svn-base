//
//  BasicMapAnnotation.m
//  baiduDemo
//
//  Created by apple on 13-9-30.
//  Copyright (c) 2013年 东和盛达. All rights reserved.
//

#import "BasicMapAnnotation.h"

@implementation BasicMapAnnotation

-(id)initWithLatitude:(CLLocationDegrees)latitude
         andLongitude:(CLLocationDegrees)longitude
                 Type:(NSString *)type
           VisiteTask:(VisiteTask *)visiteTask
                 Name:(NSString *)name
          BigImageUrl:(NSString *)imageUrl
        andInfoNumber:(int)number
             andArray:(NSArray *)array
{
    if (self=[super init]) {
        self.latitude=latitude;
        self.longitude=longitude;
        self.number=number;
        self.listArray =array;
        self.type = type;
        self.name = name;
        self.visiteTask = visiteTask;
        self.b_imageUrl = imageUrl;
    }
    return self;
}
-(CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate withNum:(int)num {
    self.latitude = newCoordinate.latitude;
    self.longitude = newCoordinate.longitude;
    self.number=num;
    
}

@end
