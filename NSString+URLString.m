//
//  NSString+URLString.m
//  AsyncImageFetchSample
//
//  Created by Satish on 07/05/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import "NSString+URLString.h"
#import "AppConstants.h"

@implementation NSString (URLString)
+(NSString*)getAPIUrl
{
    return [kbaseURL stringByAppendingString:kAppAPIAccessToken];
}

@end
