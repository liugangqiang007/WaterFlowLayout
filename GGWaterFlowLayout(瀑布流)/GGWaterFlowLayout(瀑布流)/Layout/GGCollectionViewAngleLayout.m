//
//  GGCollectionViewAngleLayout.m
//  GGWaterFlowLayout(瀑布流)
//
//  Created by LGQ on 16/7/19.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import "GGCollectionViewAngleLayout.h"

#define GGCollectionW self.collectionView.frame.size.width
/** 每一行之间的间距 */
static const CGFloat GGDefaultRowSpacing = 10;
/** 每一列之间的间距 */
static const CGFloat GGDefaultColumsSpacing = 10;
/** 组边距 */
static const UIEdgeInsets GGDefaultSectionInset = {10, 10, 10, 10};
/** 默认的列数 */
static const int GGDefaultColumsCount = 2;


@interface GGCollectionViewAngleLayout ()
/** 每一列的最大Y值 */
@property (nonatomic, strong) NSMutableArray *maxYArray;
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation GGCollectionViewAngleLayout

+ (instancetype)angleLayout {
    return [[self alloc] init];
}

- (instancetype)init {
    
    if (self = [super init]) {
        _rowSpacing    = GGDefaultRowSpacing;
        _columnSpacing = GGDefaultColumsSpacing;
        _sectionInset  = GGDefaultSectionInset;
    }
    return self;
}

- (void)setRowSpacing:(CGFloat)rowSpacing columnSpacing:(CGFloat)columnSpacing sectionInset:(UIEdgeInsets)sectionInset {
    self.rowSpacing    = rowSpacing;
    self.columnSpacing = columnSpacing;
    self.sectionInset  = sectionInset;
}


#pragma mark - 懒加载
- (NSMutableArray *)maxYArray {
    if (!_maxYArray) {
        _maxYArray = [[NSMutableArray alloc] init];
    }
    return _maxYArray;
}

- (NSMutableArray *)attrsArray {
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

#pragma mark - 实现内部的方法

- (void)prepareLayout
{
    [super prepareLayout];
    
    // 重置每一列的最大Y值, key为列, value为Y值, 初始为0
    for (NSUInteger i = 0; i < GGDefaultColumsCount; i++) {
        self.maxYArray[i] = @(0);
    }
    
    [self.attrsArray removeAllObjects];
    
    for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
        
        // 添加 scetion 头视图布局属性
        UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        if (headerAttrs) {
            [self.attrsArray addObject:headerAttrs];
        }
        
        // 添加 section top 间距
        [self.maxYArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.maxYArray[idx] = @([self.maxYArray[idx] floatValue] + self.sectionInset.top);
        }];

        
        // 计算所有cell的布局属性
        NSUInteger count = [self.collectionView numberOfItemsInSection:i];
        for (NSUInteger j = 0; j < count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrsArray addObject:attrs];
        }
        
        // 添加 section bottom 间距
        __block NSUInteger maxIndex = 0;
        [self.maxYArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self.maxYArray[maxIndex] floatValue] < obj.floatValue) {
                maxIndex = idx;
            }
        }];

        CGFloat maxY = [self.maxYArray[maxIndex] floatValue] + self.sectionInset.bottom;
        
        [self.maxYArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.maxYArray[idx] = @(maxY);
        }];
        
        // 添加 scetion 头视图布局属性
        UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        if (footerAttrs) {
            [self.attrsArray addObject:footerAttrs];
        }
    }
    
}


/**
 * 说明cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /** 计算indexPath位置cell的布局属性 */
 
    // 水平方向上的总间距
    CGFloat xMargin = self.sectionInset.left + self.sectionInset.right + self.columnSpacing;
    // cell的宽度
    CGFloat unit = (GGCollectionW - xMargin) / (GGDefaultColumsCount + 1);
    CGFloat w = 0;
    CGFloat h = 0;
    CGFloat x = 0;
    
    NSInteger index = indexPath.row % 6;
    
    if (index == 2 || index == 3) {
        w = unit;
        h = 2 * unit;
        
    } else {
        w = 2 * unit;
        h = (w - self.rowSpacing) / 2;
        
    }

    if (index == 4 || index == 5) {
        x = self.sectionInset.right + self.columnSpacing + unit;
    } else if (index == 2){
        x = self.sectionInset.right + self.columnSpacing + 2 * unit;
    } else {
        x = self.sectionInset.right;
    }
    
    NSUInteger minIndex = (index == 2 || index == 4 || index == 5) ? 1 : 0;
 
    CGFloat minY = [self.maxYArray[minIndex] floatValue];
    
    // cell的y值
    CGFloat y = (minY == self.sectionInset.top) ? minY : minY + self.rowSpacing;
    // cell的frame
    attrs.frame = CGRectMake(x, y, w, h);

    // 更新数组中的最大Y值
    self.maxYArray[minIndex] = @(CGRectGetMaxY(attrs.frame));


    return attrs;
}

/**
 *  说明补充控件的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    CGFloat height = 0;
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader] &&
        [self.delegate respondsToSelector:@selector(collectionView:layout:heightForHeaderInSection:)]) {
        height = [self.delegate collectionView:self.collectionView layout:self heightForHeaderInSection:indexPath.section];
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter] &&
               [self.delegate respondsToSelector:@selector(collectionView:layout:heightForFooterInSection:)]) {
        height = [self.delegate collectionView:self.collectionView layout:self heightForFooterInSection:indexPath.section];
    } else {
        return nil;
    }
    
    
    attrs.frame = CGRectMake(0, [self.maxYArray[0] floatValue], GGCollectionW, height);
    [self.maxYArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.maxYArray[idx] = @(CGRectGetMaxY(attrs.frame));
    }];

    return attrs;
}

/**
 * 决定了collectionView的contentSize
 */
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, [self.maxYArray[0] floatValue]);
}

/**
 * 说明所有元素（比如cell、补充控件、装饰控件）的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}


@end
