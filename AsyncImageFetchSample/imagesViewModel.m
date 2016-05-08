//
//  imagesViewModel.m
//  AsyncImageFetchSample
//
//  Created by Satish on 07/05/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import "imagesViewModel.h"

@implementation imagesViewModel
-(id)initWith:(Images*) image
{
    self=[super init];
    if(self)
    {
        self.imageURLString=[image.imageURL copy ];
    }
    return self;

}
- (id)copyWithZone:(NSZone *)zone {
    imagesViewModel *copy = [[imagesViewModel alloc] init];
    if (copy) {
        
        copy.imageURLString = [self.imageURLString copyWithZone:zone];
        
    }
    
    return copy;
}
@end
