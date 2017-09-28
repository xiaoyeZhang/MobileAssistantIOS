//
//  CommonService.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-17.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "CommonService.h"
#import "AFNetworking.h"
#import "UserEntity.h"

@implementation CommonService

- (void)getNetWorkData:(NSDictionary *)param Successed:(void(^)(id entity)) successed Failed:(void(^)(int errorCode ,NSString *message))failed
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

//    [self customSecurityPolicy:manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    NSData *userData=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEntity"];
 
    if (userData != nil) {
        
        UserEntity *userEntiy = [UserEntity sharedInstance];
        [dic setValue:userEntiy.password forKey:@"sn"];
        [dic setValue:userEntiy.user_id forKey:@"sn_id"];
    }
    
    [manager POST:BASEURL parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        
//        NSError *e;
//        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&e];
////
        successed(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger errorCode = error.code;
        NSString *errorMessage = [error localizedDescription];
        
        failed(errorCode,errorMessage);
    }];

}

- (void)uploadImage:(UIImage *)image addImageName:(NSString *)imageName ddParameters:(NSDictionary *)dic
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];//初始化请求对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置服务器允许的请求格式内容
    
    //上传图片/文字，只能同POST
    
    [manager POST:BASEURL parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //对于图片进行压缩
        NSData *data = UIImageJPEGRepresentation(image,0.5);
        //NSData *data = UIImagePNGRepresentation(image);
        //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
        [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"image/jpg"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"responseObject = %@, task = %@",responseObject,task);
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
//        successed([obj objectForKey:@"state"]);
        
        if ([[obj objectForKey:@"state"] intValue]== 1) {
            
            //            NSString *userPic = [NSString stringWithFormat:@"%@",[obj objectForKey:@"data"]];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
}

- (void)getWeatherNetWorkData:(NSDictionary *)param Successed:(void(^)(id entity)) successed Failed:(void(^)(int errorCode ,NSString *message))failed
{
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[[NSURL alloc] initWithString:@"http://cmm.avatek.com.cn/gzcmm/weather.php"]];
//    [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
//    client.parameterEncoding = AFFormURLParameterEncoding;
//    
//    [client getPath:PATH
//         parameters:param
//            success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                //NSDictionary *resultDictionary = responseObject;
//                NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                
//                successed(result);
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSInteger errorCode = error.code;
//                NSString *errorMessage = [error localizedDescription];
//                
//                failed(errorCode,errorMessage);
//            }];
}

- (void)customSecurityPolicy:(AFHTTPSessionManager *)manager
{
    
    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"dayo.net.cn" ofType:@"cer"];
    
    if (cerPath == nil) {
        NSLog(@"***文件路径没找到");
    }
    
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setPinnedCertificates:@[cerData]];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
}


@end
