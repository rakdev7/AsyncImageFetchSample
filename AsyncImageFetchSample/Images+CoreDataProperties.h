//
//  Images+CoreDataProperties.h
//  AsyncImageFetchSample
//
//  Created by Satish on 07/05/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Images.h"

NS_ASSUME_NONNULL_BEGIN

@interface Images (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageURL;

@end

NS_ASSUME_NONNULL_END
