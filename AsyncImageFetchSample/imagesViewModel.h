//
//  imagesViewModel.h
//  AsyncImageFetchSample
//
//  Created by Satish on 07/05/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Images+CoreDataProperties.h"

@interface imagesViewModel : NSObject
@property (nonatomic, strong) NSString * imageURLString;
-(id)initWith:(Images*) image;

@end
