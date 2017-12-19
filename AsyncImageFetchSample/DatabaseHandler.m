//
//  DatabaseHandler.m
//  AsyncImageFetchSample
//
//  Created by Satish on 07/05/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import "DatabaseHandler.h"
#import "AppDelegate.h"
#import "Images+CoreDataProperties.h"
#import "AppDataModel.h"

#define LHDBfileName @"AsyncImageFetchSample.sqlite"


@interface DatabaseHandler ()
@property BOOL firstLaunch;

@end
@implementation DatabaseHandler
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark
#pragma DataBaseHandler sharedManager

+(DatabaseHandler*) sharedManager {
    static DatabaseHandler *sharedDataBaseHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedDataBaseHandler = [[self alloc] init];
        sharedDataBaseHandler.firstLaunch = NO;

    });
    return sharedDataBaseHandler;
}
#pragma mark
#pragma MSDataBaseManager managedObjectContext

- (NSManagedObjectContext *)managedObjectContext {
    @synchronized([DatabaseHandler sharedManager]) {
        if (_managedObjectContext != nil) {
            return _managedObjectContext;
        }
        
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
        
        // observe the ParseOperation's save operation with its managed object context
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(mergeChanges:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
        
        
        return _managedObjectContext;
    }
}
- (void)mergeChanges:(NSNotification *)notification {
    
    if (notification.object != self.managedObjectContext) {
        [self performSelectorOnMainThread:@selector(updateMainContext:) withObject:notification waitUntilDone:NO];
    }
}
- (void)updateMainContext:(NSNotification *)notification {
    
    if(![[NSThread currentThread] isMainThread])
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    @synchronized([DatabaseHandler sharedManager]) {
        if (_managedObjectModel != nil) {
            return _managedObjectModel;
        }
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AsyncImageFetchSample" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        return _managedObjectModel;
    }
}



// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    @synchronized([DatabaseHandler sharedManager]) {
        
        if (_persistentStoreCoordinator != nil) {
            return _persistentStoreCoordinator;
        }
        
        NSURL *storeURL = [[DatabaseHandler sharedManager] checkLHDBfile];
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSSQLitePragmasOption: @{@"journal_mode": @"delete"},  NSMigratePersistentStoresAutomaticallyOption : @YES,NSInferMappingModelAutomaticallyOption : @YES} error:&error]) {
            
            abort();
        }
        return _persistentStoreCoordinator;
    }
}


#pragma mark - Application's Documents directory
- (NSURL *)applicationDocumentsDirectory {
    @synchronized([DatabaseHandler sharedManager]) {
        
        return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    }
}

-(BOOL) isApplicationLaunchedFirstTime {
    [self checkLHDBfile];
    return [DatabaseHandler sharedManager].firstLaunch;
    
}
- (void)saveContext {
    @synchronized([DatabaseHandler sharedManager]) {
        
        NSError *error = nil;
        NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
        if (managedObjectContext != nil) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                abort();
            }
        }
    }
}

- (NSURL*)checkLHDBfile {
    NSURL *storeURL = nil;
    if([[[UIApplication sharedApplication] delegate] isKindOfClass:[AppDelegate class]])
        storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:LHDBfileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        [DatabaseHandler sharedManager].firstLaunch = YES;
    }
    return  storeURL;
}
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
}
#pragma mark -
#pragma mark Key Value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Create Status
        NSString *status = [NSString stringWithFormat:@"Fetched %li Records", (long)[[change objectForKey:@"new"] integerValue]];
        
        NSLog(@"%@",status);
    });
}



#pragma mark - DataBase Population Methods
-(void)populateImageURLsToDB:(NSArray*)imageURLs
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized([DatabaseHandler sharedManager])
        {
           
            for (NSString *urlString in imageURLs) {
                 Images *imageEntity=(Images*)[NSEntityDescription insertNewObjectForEntityForName:kEntityImages inManagedObjectContext:[[DatabaseHandler sharedManager] managedObjectContext]];
                [imageEntity setImageURL:urlString];
                [[DatabaseHandler sharedManager] saveContext];
            }
        }
    });
 
}

-(void)fetchImagesFromDB:(void (^)(NSError* error,NSArray* result))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized([DatabaseHandler sharedManager])
        {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity =[self getEntityDescriptionForEntityName:kEntityImages inContext:[[DatabaseHandler sharedManager] managedObjectContext]];
            [fetchRequest setEntity:entity];
            
            __block NSError *error = nil;
            NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetchRequest completionBlock:^(NSAsynchronousFetchResult *result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // Remove Observer
                    [result.progress removeObserver:[DatabaseHandler sharedManager] forKeyPath:@"completedUnitCount" context:NULL];
                    
                    if(result.finalResult.count >0)
                    {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           completionBlock(nil,result.finalResult);
                       });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(error,nil);
                        });
                    }
                    
                });
            }];
            
            [self executeFetchRequest:asynchronousFetchRequest withError:error];
            
        }
        
    });

}
- (void)executeFetchRequest:(NSAsynchronousFetchRequest *)asynchronousFetchRequest withError:(NSError*)error {
    __block NSError *blockErrorObject = error;
    
    [[DatabaseHandler sharedManager].managedObjectContext performBlock:^{
        NSProgress *progress = [NSProgress progressWithTotalUnitCount:1];
        [progress becomeCurrentWithPendingUnitCount:1];
        NSError *asynchronousFetchRequestError = nil;
        NSAsynchronousFetchResult *asynchronousFetchResult = (NSAsynchronousFetchResult *)[[DatabaseHandler sharedManager].managedObjectContext executeRequest:asynchronousFetchRequest error:&asynchronousFetchRequestError];
        
        if (asynchronousFetchRequestError) {
        }
        blockErrorObject = asynchronousFetchRequestError;
        
        // Add Observer
        [asynchronousFetchResult.progress addObserver:[DatabaseHandler sharedManager] forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:NULL];
        
        // Resign Current
        [progress resignCurrent];
    }];
}

-(NSFetchRequest*)getFetchRequestForEntity:(NSString*)entityName {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[self getEntityDescriptionForEntityName:entityName inContext:[[DatabaseHandler sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    return fetchRequest;
    
}
-(NSEntityDescription*)getEntityDescriptionForEntityName:(NSString*)entityName inContext:(NSManagedObjectContext*)ctx {
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:ctx];
}
@end
