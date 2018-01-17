
//
//  AppDelegate.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-13.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "MainViewController.h"
#import "UploadPictureService.h"
#import "PictureEntity.h"
#import "SVProgressHUD.h"
#import "MobClick.h"
#import "AFNetworking.h"
#import "CommonService.h"
#import "UIAlertView+Blocks.h"
#import "JPUSHService.h"
#import "UserEntity.h"
#import "MainViewController.h"
#import "ProvinceVIPViewController.h"
#import "UserService.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,JPUSHRegisterDelegate>
{
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
    NSString *locaLatitude;
    NSString *locaLongitude;
    NSString *address;
}
@property (strong,nonatomic) Reachability *hostReach;
@property (nonatomic, strong) NSMutableArray *arrayAddress;
@property (nonatomic, strong) MALocationEntity *mLocationEntity;

@end

BMKMapManager* _mapManager;

@implementation AppDelegate
@synthesize loginViewController;
@synthesize taskListVC;
@synthesize arrayAddress;
@synthesize mLocationEntity;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [NSThread sleepForTimeInterval:1.5];//设置启动页面时间
    
    DataSql *db = [[DataSql alloc]init];
    [db getDbpath];
    
//    if (!db) {
        [db createMyDB];
//    }
    
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    // Override point for customization after application launch.
    [MobClick startWithAppkey:@"55471d0e67e58e1ff6005ca7" reportPolicy:BATCH   channelId:@""];
    [MobClick setCrashReportEnabled:YES];
    
    _mapManager = [[BMKMapManager alloc]init];
//  旧版地图KEY  utvhnYOa1FPbggvdFf2aUYCS
    BOOL ret = [_mapManager start:@"gsPWK9UMiedyD5b5uDeMzYqPnde3LLLR" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

    arrayAddress = [[NSMutableArray alloc] init];
    
//    NSData *userData=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEntity"];
    UserEntity *userInfo = [UserEntity sharedInstance];//[NSKeyedUnarchiver unarchiveObjectWithData:userData];

//    if ([userInfo.type_id intValue] == ROLE_CUSTOMER) { //客户经理才请求GPS
//        [[LocationManagement sharedInstance] startGPS];
//        [LocationManagement sharedInstance].delegate = self;
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    //判断网络是否可用
    self.hostReach = [Reachability reachabilityWithHostName: @"www.baidu.com"];
    [self.hostReach startNotifier];
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBackground"] forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:154.0/255.0 blue:204.0/255.0 alpha:0]];
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:15] forKey:NSFontAttributeName]];
    
    //////////////////////////////////
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    NSDictionary *naviBarTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                            NSForegroundColorAttributeName:[UIColor whiteColor]};
    [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"bg"]
                                  forBarMetrics:UIBarMetricsDefault];
    
    [navigationBarAppearance setTitleTextAttributes:naviBarTextAttributes];
    ////////////////////
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window = window;
    
        //如果 App 状态为未运行，此函数将被调用，如果launchOptions包含UIApplicationLaunchOptionsRemoteNotificationKey表示用户点击apn 通知导致app被启动运行；如果不含有对应键值则表示 App 不是因点击apn而被启动，可能为直接点击icon被启动或其他
//        NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        if (remoteNotification && userInfo.user_id.length > 0 && userInfo.tel.length > 0) { //已登录
//            MainViewController *vc = [[MainViewController alloc] init];
//            vc.isAutoInP_VIP = YES;
//            
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//            self.window.rootViewController = nav;
//        }else{
//            
//            NSData *userData=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEntity"];
//            if (userData != nil) {
//                UserEntity *userEntity = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
//                
//                if (userEntity != nil) {
//                    MainViewController *vc = [[MainViewController alloc] init];
//                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//                    self.window.rootViewController = nav;
//                }
//            } else {
//                loginViewController = [[LoginViewController alloc] init];
//                
//                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//                self.window.rootViewController = nav;
//            }
//        }
    
    
        loginViewController = [[LoginViewController alloc] init];
        
        self.nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        self.window.rootViewController = self.nav;
    
//    SGLNavigationViewController *fullScreenNavigationViewController = [[SGLNavigationViewController alloc] initWithRootViewController:loginViewController];
//    
//    self.window.rootViewController = fullScreenNavigationViewController;
    

    
    [self.window makeKeyAndVisible];
    
    
    //显示状态栏网络状态
//    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [self checkUpdate];
    
    // Required
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                       UIUserNotificationTypeSound |
//                                                       UIUserNotificationTypeAlert)
//                                           categories:nil];
//    } else {
//        //categories 必须为nil
//        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                       UIRemoteNotificationTypeSound |
//                                                       UIRemoteNotificationTypeAlert)
//                                           categories:nil];
//    }
//    
//    // Required
//    [APService setupWithOption:launchOptions];

    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    //    [JPUSHService setAlias:@"" callbackSelector:<#(SEL)#> object:<#(id)#>]
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    
    [JPUSHService setupWithOption:launchOptions appKey:@"4eb2df1e89f7fae9029a0098" channel:@"pub.avatek.com.cn" apsForProduction:FALSE];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    
    NSUserDefaults *locationDefaults = [NSUserDefaults standardUserDefaults];
    [locationDefaults removeObjectForKey:@"locaLatitude"];
    [locationDefaults removeObjectForKey:@"locaLongitude"];
    [locationDefaults removeObjectForKey:@"address"];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
//    [JPUSHService setBadge:0];//重置JPush服务器上面的badge值。如果下次服务端推送badge传"+1",则会在你当时JPush服务器上该设备的badge值的基础上＋1；
//    
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//apple自己的接口，变更应用本地（icon）的badge值；
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([r currentReachabilityStatus] == ReachableViaWiFi)    //wifi
    {
        UploadPictureService *service = [[UploadPictureService alloc] init];
        NSArray *imageArray = [service loadAllPictureFromDB];
        if (imageArray && [imageArray count] > 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"你有尚未上传的图片，是否需要现在上传?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 998;
            [alert show];
        }
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Push

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//    ALERT_ERR_MSG(@"推送功能启用失败");
    DebugLog(@"%@",error);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//     Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
//    notification.setSound(Uri.parse("android.resource://" + context.getPackageName() + "/" +R.raw.test));
    
    // 取得自定义字段内容
//    NSString *pushTag = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
//    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",content,badge,sound,pushTag);
    
//    if ([pushTag isEqualToString:@""]) { //收到指定类型的推送打开指定界面
//        UINavigationController *navi = (UINavigationController *)self.window.rootViewController;
        
//        [navi pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>];
        
//        UserEntity *userInfo = [UserEntity sharedInstance];
//    }
//    NSLog(@"didReceiveRemoteNotification1 aps=%@",aps);
    
    if (application.applicationState == UIApplicationStateActive) {
        
        UINavigationController *navi = (UINavigationController *)self.window.rootViewController;
        UIViewController *vc = [[navi viewControllers] lastObject];
        if ([vc isMemberOfClass:[LoginViewController class]]) {
            return;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送消息"
                                                        message:content
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"查看", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex != alert.cancelButtonIndex) {
                
//                ProvinceVIPViewController *vc = [[ProvinceVIPViewController alloc] init];
//                [navi pushViewController:vc animated:YES];
            }
        }];
    }
    
    
    // Required
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
//    {
//        "_j_msgid" = 3018060401;
//        aps =     {
//            alert = 1111111;
//            badge = 1;
//            sound = default;
//        };
//    }

    NSDictionary *aps = userInfo[@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    if (application.applicationState == UIApplicationStateActive) {
        
        UINavigationController *navi = (UINavigationController *)self.window.rootViewController;
        UIViewController *vc = [[navi viewControllers] lastObject];
        if ([vc isMemberOfClass:[LoginViewController class]]) {
            return;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送消息"
                                                        message:content
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"查看", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            
            if (buttonIndex != alert.cancelButtonIndex) {

                if ([content rangeOfString:@"该版本已停用"].location != NSNotFound | [content rangeOfString:@"最新版本"].location != NSNotFound) {
                    
                    [self checkUpdate];
                    
                }else{
//                    ProvinceVIPViewController *vc = [[ProvinceVIPViewController alloc] init];
//                    [navi pushViewController:vc animated:YES];
                }
                
            }
        }];
    }
    
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark -

int imagecount =0;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 998) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            [SVProgressHUD show];
            UploadPictureService *service = [[UploadPictureService alloc] init];
            NSArray *imageArray = [service loadAllPictureFromDB];
            for (PictureEntity *entity in imageArray) {
                UIImage *image = [UIImage imageWithContentsOfFile:entity.picturePath];
                if ([service uploadPicture:entity.state ImageFileName:entity.pictureName Image:UIImageJPEGRepresentation(image,0.5)]) {
                    [service deletePictureFromDBWithID:entity.pictureID];
                }
            }
            
            //            for (NSString *imageName in imageArray) {
            //                imagecount ++;
            //                //[Utilies UploadImage:path];
            //                NSString *path = [[[Utilies getCheckInImagePath] stringByAppendingString:@"/"] stringByAppendingString:imageName];
            //                UIImage *imaage = [UIImage imageWithContentsOfFile:path];
            //                NSString *str = [imageName substringToIndex:[imageName length]-4];
            //                [self uploadImage:imaage FileName:str Path:path];
            //            }
            [SVProgressHUD dismiss];
        }
    }
}

#pragma mark "reachability notification"
//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    NSLog(@"**********reachabilityChanged************");
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    //[self updateInterfaceWithReachability: curReach];
    
    
    if(NotReachable == [curReach currentReachabilityStatus])
    {
        NSString *networkNotAvailableString = @"无法连接到后台服务器，请检查网络！" ;
        NSString *networkConfirmButtonTitle = @"确定" ;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:networkNotAvailableString
                                                       delegate:nil
                                              cancelButtonTitle:networkConfirmButtonTitle
                                              otherButtonTitles:nil];
        [alert show];
    }
}

//- (void)locationUpdated
//{
//    LocationManagement *lm = [LocationManagement sharedInstance];
//    [lm performCoordinateGeocode:lm.location.coordinate
//                         success:^(id responseObject) {
//                             NSDictionary *placeCityDic = (NSDictionary *)responseObject;
//                             lm.city = [placeCityDic objectForKey:@"City"];
//                             
//                             [[NSUserDefaults standardUserDefaults] setObject:lm.city forKey:@"city"];
//                             [[NSUserDefaults standardUserDefaults] synchronize];
//                             
//                         } failure:^(NSError *error) {
//                         }];
//
//    [MALocationEntity sharedInstance].name = [[NSString alloc] initWithFormat:@"%@", [LocationManagement sharedInstance].address];
//    [MALocationEntity sharedInstance].lat = [[NSString alloc] initWithFormat:@"%f", [LocationManagement sharedInstance].location.coordinate.latitude];
//    [MALocationEntity sharedInstance].lont = [[NSString alloc] initWithFormat:@"%f", [LocationManagement sharedInstance].location.coordinate.longitude ];
//    
////    NSLog(@"%@,%@,%@",[MALocationEntity sharedInstance].name, [MALocationEntity sharedInstance].lat, [MALocationEntity sharedInstance].lont);
//    
//    /*
//    static int times = 0;
//    
//    MALocationEntity *locationEntity = [[MALocationEntity alloc] init];
//    locationEntity.name = [[NSString alloc] initWithFormat:@":%@", [LocationManagement sharedInstance].address];
//    locationEntity.lat = [[NSString alloc] initWithFormat:@":%f", [LocationManagement sharedInstance].location.coordinate.latitude];
//    locationEntity.lont = [[NSString alloc] initWithFormat:@"%f", [LocationManagement sharedInstance].location.coordinate.longitude ];
//    
//    if (times < 5) {
//        MALocationEntity *locationEntity = [[MALocationEntity alloc] init];
//        locationEntity.name = [[NSString alloc] initWithFormat:@":%@", [LocationManagement sharedInstance].address];
//        locationEntity.lat = [[NSString alloc] initWithFormat:@":%f", [LocationManagement sharedInstance].location.coordinate.latitude];
//        locationEntity.lont = [[NSString alloc] initWithFormat:@"%f", [LocationManagement sharedInstance].location.coordinate.longitude ];
//        [arrayAddress addObject:locationEntity];
//        
//        times++;
//    }
//    
//    if (times >= 5) {
//        for (int i = [arrayAddress count]-1; i >= 0; i--) {
//            MALocationEntity *le1 = [arrayAddress objectAtIndex:i];
//            for (int k = [arrayAddress count] - 1; k >= 0; k--) {
//                MALocationEntity *le2 = [arrayAddress objectAtIndex:k];
//                if ([le1.name isEqualToString:le2.name] == YES) {
//                    le1.times++;
//                }
//            }
//        }
//        
//        MALocationEntity *le1 = [arrayAddress objectAtIndex:[arrayAddress count]-1];
//        for (int i = [arrayAddress count]-1; i >= 0; i--) {
//            MALocationEntity *le2 = [arrayAddress objectAtIndex:i];
//            
//            if (le1.times < le2.times) {
//                le1 = le2;
//            }
//        }
//        
//        [[MALocationEntity sharedInstance] deepCopy:le1];
//        
//        //[[LocationManagement sharedInstance] stopGPS];
////        [LocationManagement sharedInstance].address = le1.name;
////        [LocationManagement sharedInstance].location = [[CLLocation alloc] initWithLatitude:[le1.lat doubleValue] longitude:[le1.lont doubleValue]];
//        
//        [arrayAddress removeAllObjects];
//        */
////        times = 0;
////    }
//
//}

- (void)locationUpdatedFailed:(int)errorCode ErrorMessage:(NSString *)message
{
}


- (void)checkUpdate
{
//#ifndef DEBUG
//    ALERT_ERR_MSG(@"这条信息不会影响功能仅显示一下");
//#endif
    //当前版本
    NSDictionary *clientInfoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *clientVersion = clientInfoDict[@"CFBundleVersion"]; //build版本
//    NSString *version = clientInfoDict[@"CFBundleShortVersionString"];
    
    NSDictionary *dict = @{@"method":@"update_ios_version",
                           @"version":clientVersion};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"result"] intValue];
                      if (state == 2) {
                          
                          NSDictionary *info = entity[@"info"];
                          if ([info isKindOfClass:[NSDictionary class]]) {
                              
                              NSString *content = info[@"content"];
                              NSString *urlStr = info[@"url"];
                              
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示"
                                                                              message:content
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"取消"
                                                                    otherButtonTitles:@"确定", nil];
                              
                              [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                                  if (buttonIndex != alert.cancelButtonIndex) {
                                      NSURL *url = [NSURL URLWithString:urlStr];
                                      
                                      [[UIApplication sharedApplication] openURL:url];
                                  }
                              }];
                          }
                      }else if(state == 3){ //强制更新
                          NSDictionary *info = entity[@"info"];
                          if ([info isKindOfClass:[NSDictionary class]]) {
                              
                              NSString *content = info[@"content"];
                              NSString *urlStr = info[@"url"];
                              
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示"
                                                                              message:content
                                                                             delegate:nil
                                                                    cancelButtonTitle:nil
                                                                    otherButtonTitles:@"确定", nil];
                              [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                                  NSURL *url = [NSURL URLWithString:urlStr];
                                  [[UIApplication sharedApplication] openURL:url];
                              }];
                          }
                      }
                  } Failed:^(int errorCode, NSString *message) {

                  }];
}

- (void) chnageRootToLoginVC {
    LoginViewController *vc = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
}

#pragma mark - 地图
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    locaLatitude = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];//纬度
    locaLongitude = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];//精度
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        DebugLog(@"反geo检索发送成功");
    }
    else
    {
        DebugLog(@"反geo检索发送失败");
    }
    
    NSUserDefaults *locationDefaults = [NSUserDefaults standardUserDefaults];
    [locationDefaults removeObjectForKey:@"locaLatitude"];
    [locationDefaults removeObjectForKey:@"locaLongitude"];
    [locationDefaults removeObjectForKey:@"address"];
    
    
    [locationDefaults setObject:locaLatitude forKey:@"locaLatitude"];
    [locationDefaults setObject:locaLongitude forKey:@"locaLongitude"];
    [locationDefaults setObject:@" " forKey:@"address"];
    
    [locationDefaults synchronize];
}
//接收反向地理编码结果
- (void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result   errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        address = result.address;

        //保存到userdefault
        NSUserDefaults *locationDefaults = [NSUserDefaults standardUserDefaults];
        
//        [locationDefaults setObject:locaLatitude forKey:@"locaLatitude"];
//        [locationDefaults setObject:locaLongitude forKey:@"locaLongitude"];
        [locationDefaults setObject:address forKey:@"address"];
        
        [locationDefaults synchronize];
        
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

@end
