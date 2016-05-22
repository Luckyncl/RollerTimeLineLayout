//
//  PhotoCollectionViewController.m
//  RollerTimeLine
//
//  Created by Stan on 5/21/16.
//  Copyright © 2016 Stan. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "PhotoCell.h"
#import "RollerLayout.h"

@interface PhotoCollectionViewController ()
@property (strong, nonatomic) NSMutableArray *images;
@property (assign, nonatomic) CGFloat margin;
@end

static NSString * const reuseIdentifier = @"PhotoCell";
@implementation PhotoCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _images = [NSMutableArray new];
    for (NSInteger i = 0; i < 30; i++) {
        [_images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"image_%ld", i % 23 + 1]]];
    }
    
    _margin = ((RollerLayout *)self.collectionView.collectionViewLayout).margin;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = _images[indexPath.item];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView setContentOffset:CGPointMake(0, indexPath.item * _margin) animated:YES];
}

-(void)adjustContentOffset {
    CGPoint center = CGPointMake(_margin/2.0,
                                 self.collectionView.center.y + self.collectionView.contentOffset.y);
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:center];
    [self.collectionView setContentOffset:CGPointMake(0, indexPath.item * _margin) animated:YES];
}

#pragma mark <UIScrollViewDelegate>

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.collectionView.collectionViewLayout invalidateLayout];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self adjustContentOffset];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self adjustContentOffset];
    }
}

@end
