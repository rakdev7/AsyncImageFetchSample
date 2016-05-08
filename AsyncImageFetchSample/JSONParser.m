//
//  JSONParser.m
//  AsyncImageFetchSample
//
//  Created by Satish on 07/05/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import "JSONParser.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDataModel.h"

@interface JSONParser ()
@property(strong,nonatomic)NSString *serviceURL;

@end
@implementation JSONParser
-(instancetype)initWithURLString:(NSString *)urlString
{
    if (self=[super init]) {
        self.serviceURL=urlString;
    }

    return self;
}
-(void)startHTTPSessionWithCompletion:(void (^)(NSError *, NSArray *))completionBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:self.serviceURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *urlArray=[[NSMutableArray alloc]init];
        NSArray *dataArray=[responseObject objectForKey:@"data"];
        for (id each in dataArray) {
            NSLog(@"%@",[[[each objectForKey:kImagesKey]objectForKey:kStandrdResolutionKey]objectForKey:kurlKey]);
            [urlArray addObject:[[[each objectForKey:kImagesKey]objectForKey:kStandrdResolutionKey]objectForKey:kurlKey]];
            
        }
        completionBlock(nil,urlArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionBlock(error,nil);
    }];
}
@end
