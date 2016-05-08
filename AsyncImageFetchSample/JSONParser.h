//
//  JSONParser.h
//  AsyncImageFetchSample
//
//  Created by Satish on 07/05/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject
-(instancetype)initWithURLString:(NSString *)urlString;
-(void)startHTTPSessionWithCompletion:(void (^)(NSError *error,NSArray *results))completionBlock;
@end
