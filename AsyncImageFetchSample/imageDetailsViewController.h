//
//  imageDetailsViewController.h
//  AsyncImageFetchSample
//
//  Created by Satish on 07/05/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imageDetailsViewController : UIViewController
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, weak) IBOutlet UIImageView *detailsImageView;
@property (nonatomic, strong) NSString *backButtonTitle;
@end
