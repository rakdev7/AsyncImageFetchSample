//
//  AsyncImageFetchCollectionViewController.m
//  AsyncImageFetchSample
//
//  Created by Satish on 08/05/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import "AsyncImageFetchCollectionViewController.h"
#import "CollectionViewImageCell.h"
#import "DatabaseHandler.h"
#import "imagesViewModel.h"
#import "UIKit+AFNetworking.h"
#import "imageDetailsViewController.h"

#define kHeaderHeight 32
#define kInterSectionMargin 8

@interface AsyncImageFetchCollectionViewController ()
@property(strong,nonatomic)NSMutableArray *imagesArray;

@end

@implementation AsyncImageFetchCollectionViewController

static NSString * const reuseIdentifier = @"CollectionCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesArray=[[NSMutableArray alloc]init];
    [[DatabaseHandler sharedManager]fetchImagesFromDB:^(NSError *error, NSArray *result) {
        NSLog(@"%@",result);
        for (Images *imageObject in result) {
            imagesViewModel *imageVM=[[imagesViewModel alloc]initWith:imageObject];
            [self.imagesArray addObject:imageVM];
        }
        [self.collectionView reloadData];
    }];
    self.navigationItem.title = @"Grid View";


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    imagesViewModel *imageViewModel=(imagesViewModel*)[self.imagesArray objectAtIndex:indexPath.row];
    NSLog(@"%@",imageViewModel.imageURLString);
    NSURLRequest *imageRequest =
[NSURLRequest requestWithURL:[NSURL URLWithString:imageViewModel.imageURLString]
                     cachePolicy:NSURLRequestReturnCacheDataElseLoad
                 timeoutInterval:5];
    
    __weak CollectionViewImageCell *mycell  = cell;
    [cell.cellimageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"loading_large@3x"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        mycell.cellimageView.alpha = 0.0;
        mycell.cellimageView.image = image;
        [UIView animateWithDuration:0.25
                         animations:^{
                             mycell.cellimageView.alpha = 1.0;
                         }];
    } failure:NULL];
    
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, kHeaderHeight);
    }
    return CGSizeMake(0, kHeaderHeight + kInterSectionMargin);
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"collectionSegue" sender:nil];
    
}

#pragma mark Segue methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"collectionSegue"])
    {
        imageDetailsViewController *vc=(imageDetailsViewController*)[segue destinationViewController];
        NSIndexPath * selectedIndexPath = [self.collectionView indexPathsForSelectedItems][0];
        NSLog(@"%@",selectedIndexPath);
        imagesViewModel *imageViewModel=(imagesViewModel*)[self.imagesArray objectAtIndex:selectedIndexPath.row];
        NSLog(@"%@",imageViewModel.imageURLString);
        vc.urlString=imageViewModel.imageURLString;
    }
}

@end
