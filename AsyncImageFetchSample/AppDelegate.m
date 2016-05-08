//
//  AppDelegate.m
//  AsyncImageFetchSample
//
//  Created by Satish on 07/05/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseHandler.h"
#import "JSONParser.h"
#import "NSString+URLString.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create("populate_data#1", 0);
    dispatch_async(backgroundQueue, ^{
        [self populateAndParseData];
    
    });
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

-(void) populateAndParseData {
    NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]);
    
   if([[DatabaseHandler sharedManager] isApplicationLaunchedFirstTime])
  {
       JSONParser *parser=[[JSONParser alloc]initWithURLString:[NSString getAPIUrl]];
        [parser startHTTPSessionWithCompletion:^(NSError *error, NSArray *results) {
            if (results !=nil) {
                
                [[DatabaseHandler sharedManager]populateImageURLsToDB:results];
            }
        }];
        
    }
}

@end
