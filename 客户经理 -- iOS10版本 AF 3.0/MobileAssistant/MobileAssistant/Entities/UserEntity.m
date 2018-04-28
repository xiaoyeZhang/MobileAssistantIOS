//
//  UserEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-13.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity

static UserEntity * _sharedInstance = nil;

+ (id)sharedInstance
{
    static dispatch_once_t p = 0;
    dispatch_once(&p, ^{
        
        NSData *userData=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEntity"];
        if (userData) {
            _sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        }else{
            _sharedInstance = [[UserEntity alloc] init];
        }
    });
    return _sharedInstance;
}

- (void) deepCopy:(UserEntity *)sender
{
    _sharedInstance.state = [sender.state mutableCopy];
    _sharedInstance.reason = [sender.reason mutableCopy];
    _sharedInstance.name = [sender.name mutableCopy];
    _sharedInstance.weather = [sender.weather mutableCopy];
    _sharedInstance.tel = [sender.tel mutableCopy];
    _sharedInstance.password = [sender.password mutableCopy];
    _sharedInstance.dep_id = [sender.dep_id mutableCopy];
    _sharedInstance.type_id = [sender.type_id mutableCopy];
    _sharedInstance.area_id = [sender.area_id mutableCopy];
    _sharedInstance.user_id = [sender.user_id mutableCopy];
    _sharedInstance.dep_name = [sender.dep_name mutableCopy];
    _sharedInstance.num = [sender.num mutableCopy];
    _sharedInstance.is_first = [sender.is_first mutableCopy];
    _sharedInstance.notice = [sender.notice mutableCopy];
}

-(void)update:(NSDictionary*)attributes
{
    NSNumber *state = [attributes valueForKeyPath:@"state"];
    self.state= [NSString stringWithFormat:@"%d", [state intValue]];
    
    if ([self.state isEqualToString:@"3"] == YES) {
        NSNumber *numberReason = [attributes valueForKeyPath:@"reason"];
        self.reason= [NSString stringWithFormat:@"%d", [numberReason intValue]];
    } else {
        self.reason = [attributes valueForKeyPath:@"reason"];
    }
    if ([[attributes allKeys] containsObject:@"weather"])
    {
        self.weather = [attributes valueForKeyPath:@"weather"];
    }

    NSDictionary *content = [attributes valueForKey:@"content"];
    
    if (content != nil) {
        self.user_id = [content valueForKeyPath:@"user_id"];
        self.tel = [content valueForKeyPath:@"tel"];
        self.password = [content valueForKeyPath:@"password"];
        self.dep_id = [content valueForKeyPath:@"dep_id"];
        self.type_id = [content valueForKeyPath:@"type_id"];
        self.area_id = [content valueForKeyPath:@"area_id"];
        self.name = [content valueForKeyPath:@"name"];
        self.dep_name = [content valueForKey:@"dep_name"];
        self.num = [content valueForKey:@"num"];
        self.is_first = [content valueForKey:@"is_first"];
        self.notice = [content valueForKey:@"notice"];
    }
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self update:attributes];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.state forKey:@"state"];
    [encoder encodeObject:self.reason forKey:@"reason"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.weather forKey:@"weather"];
    [encoder encodeObject:self.user_id forKey:@"user_id"];
    [encoder encodeObject:self.tel forKey:@"tel"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.dep_id forKey:@"dep_id"];
    [encoder encodeObject:self.type_id forKey:@"type_id"];
    [encoder encodeObject:self.area_id forKey:@"area_id"];
    [encoder encodeObject:self.dep_name forKey:@"dep_name"];
    [encoder encodeObject:self.num forKey:@"num"];
    [encoder encodeObject:self.is_first forKey:@"is_first"];
    [encoder encodeObject:self.notice forKey:@"notice"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init]) {
        self.content = [decoder decodeObjectForKey:@"content"];
        self.state = [decoder decodeObjectForKey:@"state"];
        self.reason = [decoder decodeObjectForKey:@"reason"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.weather = [decoder decodeObjectForKey:@"weather"];
        self.user_id = [decoder decodeObjectForKey:@"user_id"];
        self.tel = [decoder decodeObjectForKey:@"tel"];
        self.password = [decoder decodeObjectForKey:@"password"];
        self.dep_id = [decoder decodeObjectForKey:@"dep_id"];
        self.type_id = [decoder decodeObjectForKey:@"type_id"];
        self.area_id = [decoder decodeObjectForKey:@"area_id"];
        self.dep_name = [decoder decodeObjectForKey:@"dep_name"];
        self.num = [decoder decodeObjectForKey:@"num"];
        self.is_first = [decoder decodeObjectForKey:@"is_first"];
        self.notice = [decoder decodeObjectForKey:@"notice"];
    }
    return  self;
}

@end
