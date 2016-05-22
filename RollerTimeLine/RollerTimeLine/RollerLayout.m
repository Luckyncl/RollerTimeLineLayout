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
    
    _itemCount = [self.collectionView numberOfItemsInSection:0];
    
    CGFloat offsetY = self.collectionView.contentOffset.y;
    NSInteger centerIndex = offsetY/_margin;
    if (centerIndex < 0) {
        centerIndex = 0;
    }
    
    // we only calculate visible items' layout attributes
    // 3 items, one for the item in center, 2 additional for the pre-layout items.
    NSInteger visibleCount = (self.collectionView.bounds.size.height - _itemHeight)/_margin + 3;
    NSInteger startIndex = centerIndex - visibleCount/2;
    if (startIndex < 0) {
        startIndex = 0;
    }
    
    NSInteger visibleItems = startIndex + visibleCount;
    for (NSInteger item = startIndex; item < visibleItems; item++) {
        
        /*
         *   fix bug 'UICollectionView received layout attributes for a cell with an index path that does not exist'
         */
        if (item >= _itemCount) break;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attr = _layoutInfos[indexPath];
        if (!attr) {
            attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        }
        
        NSInteger z = _itemCount/2 - labs(centerIndex - item);
        attr.zIndex = z;
        
        CGFloat diff =  fabs((offsetY/_margin) - item);
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