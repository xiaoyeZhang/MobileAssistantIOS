//
//  FMDBHelper.m
//  MyDressingRoom
//
//  Created by Sky-TechLab on 6/13/13.
//  Copyright (c) 2013 Sky. All rights reserved.
//

#import "FMDBHelper.h"

@implementation FMDBHelper

static FMDatabase *shareInstance;

+ (FMDatabase *)instance {
	
	@synchronized(self){
		if (!shareInstance) {
			BOOL success;
			NSError *error;
			NSFileManager *fm = [NSFileManager defaultManager];
			NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"MobileAssistant.sqlite"];
			
			success = [fm fileExistsAtPath:writableDBPath];
			if(!success){
				NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MobileAssistant.sqlite"];
				success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
				if(!success){
					NSLog(@"%@",[error localizedDescription]);
				}
				else {
                    
                    NSURL * fileURL;
                    fileURL = [ NSURL fileURLWithPath: writableDBPath ]; 
                    [ fileURL setResourceValue: [ NSNumber numberWithBool: YES ] forKey: NSURLIsExcludedFromBackupKey error: nil ];
                    
					shareInstance = [[FMDatabase databaseWithPath:writableDBPath] retain];
					//For Debug
					[shareInstance setLogsErrors:TRUE];
					[shareInstance setTraceExecution:TRUE];
					if ([shareInstance open]) {
						[shareInstance setShouldCacheStatements:YES];
					}else{
						NSLog(@"Failed to open database.");
						success = NO;
					}
					
				}
                
				success = NO;
			}
			if(success){
				shareInstance = [[FMDatabase databaseWithPath:writableDBPath] retain];
				//For Debug
				[shareInstance setLogsErrors:TRUE];
				[shareInstance setTraceExecution:TRUE];
				if ([shareInstance open]) {
					[shareInstance setShouldCacheStatements:YES];
				}else{
					NSLog(@"Failed to open database.");
					success = NO;
				}
			}
			
		}
	}
	
	return shareInstance;
}


+ (id)allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (shareInstance == nil) {
            shareInstance = [self instance];
            return shareInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone //第四步
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
    
}

- (id)autorelease
{
    return self;
}

- (id)init
{
    @synchronized(self) {
        [super init];//往往放一些要初始化的变量.
        return self;
    }
}


@end
