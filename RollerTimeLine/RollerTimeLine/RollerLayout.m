//
//  RollerLayout.m
//  RollerTimeLine
//
//  Created by Stan on 5/21/16.
//  Copyright © 2016 Stan. All rights reserved.
//

#import "RollerLayout.h"

@interface RollerLayout ()
@property (assign, nonatomic) CGFloat itemWidth;
@property (assign, nonatomic) CGFloat itemHeight;
@property (assign, nonatomic) CGFloat midY;
@property (assign, nonatomic) NSInteger itemCount;
@property (strong, nonatomic) NSMutableDictionary *layoutInfos;
@property (strong, nonatomic) NSMutableArray *layoutInfosArray;
@end

@implementation RollerLayout

-(id)init {
    if(self = [super init]) {
        [self commondInit];
    }
    return self;
}

-(void)awakeFromNib {
    [self commondInit];
}

-(void)commondInit {
    _layoutInfos = [NSMutableDictionary new];
    _layoutInfosArray = [NSMutableArray new];
}

- (void)prepareLayout {
    _itemWidth = self.collectionView.bounds.size.width;
    _itemHeight = _itemWidth / 4.0 * 3.0;
    _midY = (self.collectionView.bounds.size.height - _itemHeight) / 2.0;
    
    NSInteger sections = [self.collectionView numberOfSections];
    NSAssert(sections == 1, @"Only 1 section supported!");
    
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    _itemCount = items;
    CGFloat offsetY = self.collectionView.contentOffset.y;
    
    for (NSInteger item = 0; item < items; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attr = _layoutInfos[indexPath];
        if (!attr) {
            NSLog(@"attr == nil");
            attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        }
        
//        CATransform3D transform = CATransform3DIdentity;
//        transform.m34 = -1.0/1000.0;
//        transform = CATransform3DRotate(transform, -0.6, 0, 1, 0);
//        attr.transform3D = transform;
        
        CGFloat diff =  fabs((offsetY/_margin) - item);
        NSInteger z = _itemCount/2 - diff;
        attr.zIndex = z;
        
        CGFloat x = diff * _margin;
        attr.frame = CGRectMake(x,
                                _midY + _margin * item,
                                _itemWidth,
                                _itemHeight);
        [_layoutInfos setObject:attr forKey:indexPath];
    }
}

-(CGSize)collectionViewContentSize {
    CGFloat height = _margin * (_itemCount - 1) +  _itemHeight + 2 * _midY;
    return CGSizeMake(_itemWidth, height);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    [_layoutInfosArray removeAllObjects];
    for (NSIndexPath *indexPath in _layoutInfos) {
        UICollectionViewLayoutAttributes *attr = [_layoutInfos objectForKey:indexPath];
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [_layoutInfosArray addObject:attr];
        }
    }
    return _layoutInfosArray;
}

@end