//
//  AsyncImageFectchTableViewController.m
//  AsyncImageFetchSample
//
//  Created by Satish on 07/05/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import "AsyncImageFectchTableViewController.h"
#import "UIKit+AFNetworking.h"
#import "DatabaseHandler.h"
#import "TableViewImageCell.h"
#import "Images+CoreDataProperties.h"
#import "imagesViewModel.h"
#import "imageDetailsViewController.h"

NSString *const cellIndentifier=@"tableCellIdentifier";

@interface AsyncImageFectchTableViewController ()
@property(strong,nonatomic)NSMutableArray *imagesArray;
@end
@implementation AsyncImageFectchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesArray=[[NSMutableArray alloc]init];
    [[DatabaseHandler sharedManager]fetchImagesFromDB:^(NSError *error, NSArray *result) {
        NSLog(@"%@",result);
        for (Images *imageObject in result) {
            imagesViewModel *imageVM=[[imagesViewModel alloc]initWith:imageObject];
            [self.imagesArray addObject:imageVM];
        }
        [self.tableView reloadData];

        
    }];
    self.navigationItem.title = @"List View";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imagesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewImageCell *cell=(TableViewImageCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    imagesViewModel *imageViewModel=(imagesViewModel*)[self.imagesArray objectAtIndex:indexPath.row];
    NSLog(@"%@",imageViewModel.imageURLString);
    NSURLRequest *imageRequest =
    [NSURLRequest requestWithURL:[NSURL URLWithString:imageViewModel.imageURLString]
                     cachePolicy:NSURLRequestReturnCacheDataElseLoad
                 timeoutInterval:5];
    
    __weak TableViewImageCell *mycell  = cell;
    [cell.imageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"loading_large@3x"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        mycell.imageView.alpha = 0.0;
        mycell.imageView.image = image;
        [UIView animateWithDuration:0.25
                         animations:^{
                             mycell.imageView.alpha = 1.0;
                         }];
    } failure:NULL];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detailSegue" sender:nil];

}

#pragma mark Segue methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"detailSegue"])
     {
         imageDetailsViewController *vc=(imageDetailsViewController*)[segue destinationViewController];
         NSIndexPath * selectedIndexPath = [self.tableView indexPathForSelectedRow];
         NSLog(@"%@",selectedIndexPath);
         imagesViewModel *imageViewModel=(imagesViewModel*)[self.imagesArray objectAtIndex:selectedIndexPath.row];

         vc.urlString=imageViewModel.imageURLString;



     }
}


@end