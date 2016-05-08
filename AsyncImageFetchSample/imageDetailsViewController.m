//
//  imageDetailsViewController.m
//  AsyncImageFetchSample
//
//  Created by Satish on 07/05/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import "imageDetailsViewController.h"
#import "UIKit+AFNetworking.h"

@interface imageDetailsViewController ()

@end

@implementation imageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  NSURLRequest *imageRequest =  [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]
                     cachePolicy:NSURLRequestReturnCacheDataElseLoad
                 timeoutInterval:5];
    
    [self.detailsImageView setImageWithURLRequest:imageRequest
                          placeholderImage:nil
                                   success:nil
                                   failure:nil];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
