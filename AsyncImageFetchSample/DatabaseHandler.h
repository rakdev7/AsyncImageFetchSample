//
//  DatabaseHandler.h
//  AsyncImageFetchSample
//
//  Created by Satish on 07/05/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DatabaseHandler : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
+(DatabaseHandler*) sharedManager;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(BOOL) isApplicationLaunchedFirstTime;

-(void)populateImageURLsToDB:(NSArray*)imageURLs;
-(void)fetchImagesFromDB:(void (^)(NSError* error,NSArray* result))completionBlock;


@end
