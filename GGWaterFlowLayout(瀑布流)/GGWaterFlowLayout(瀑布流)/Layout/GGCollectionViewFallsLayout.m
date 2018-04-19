//
//  GGCollectionViewLayout.m
//  GGWaterFlowLayout(瀑布流)
//
//  Created by LGQ on 16/5/4.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import "GGCollectionViewFallsLayout.h"

#define GGCollectionW self.collectionView.frame.size.width

/** 每一行之间的间距 */
static const CGFloat GGDefaultRowSpacing = 10;
/** 每一列之间的间距 */
static const CGFloat GGDefaultColumsSpacing = 10;
/** 组边距 */
static const UIEdgeInsets GGDefaultSectionInset = {10, 10, 10, 10};
/** 默认的列数 */
static const int GGDefaultColumsCount = 3;


@interface GGCollectionViewFallsLayout ()
/** 每一列的最大Y值 */
@property (nonatomic, strong) NSMutableArray *maxYArray;
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end


@implementation GGCollectionViewFallsLayout

+ (instancetype)layoutWithColumsCount:(NSInteger)columsCount {
    return [[self alloc] initWithColumsCount:columsCount];
}

- (instancetype)initWithColumsCount:(NSInteger)columsCount {
    
    if (self = [self init]) {
        self.columsCount = columsCount;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _rowSpacing    = GGDefaultRowSpacing;
        _columnSpacing = GGDefaultColumsSpacing;
        _sectionInset  = GGDefaultSectionInset;
        _columsCount   = GGDefaultColumsCount;
    }
    return self;
}

- (void)setRowSpacing:(CGFloat)rowSpacing columnSpacing:(CGFloat)columnSpacing sectionInset:(UIEdgeInsets)sectionInset {
    self.rowSpacing    = rowSpacing;
    self.columnSpacing = columnSpacing;
    self.sectionInset  = sectionInset;
}
#pragma mark - 私有方法
/**
 *  对 maxYArray 全部赋予相同的值
 */
- (void)setMaxYArrayAllIndexWithValue:(NSNumber *)value {
    for (NSInteger i = 0; i < self.columsCount; i++) {
        self.maxYArray[i] = value;
    }
}

/**
 *  拥有最小值的index
 */
- (NSUInteger)minYIndexOfMaxYArray {
    __block NSUInteger minIndex = 0;
    [self.maxYArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.maxYArray[minIndex] floatValue] > obj.floatValue) {
            minIndex = idx;
        }
    }];
    return minIndex;
}

/**
 *  拥有最大值的index
 */
- (NSUInteger)maxYIndexOfMaxYArray {
    __block NSUInteger maxIndex = 0;
    [self.maxYArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.maxYArray[maxIndex] floatValue] < obj.floatValue) {
            maxIndex = idx;
        }
    }];
    return maxIndex;
}

#pragma mark - 实现内部的方法
- (void)prepareLayout
{
    [super prepareLayout];

    [self.attrsArray removeAllObjects];
    
    // 重置每一列的最大Y值, 初始为0
    [self setMaxYArrayAllIndexWithValue:@0];
    
    
    for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
        
        // 添加 scetion 头视图布局属性
        UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                             atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        if (headerAttrs) {
            [self.attrsArray addObject:headerAttrs];
        }
        
        // 添加 section top 间距
        [self setMaxYArrayAllIndexWithValue:@([self.maxYArray[0] floatValue] + self.sectionInset.top)];

        // 计算所有cell的布局属性
        NSUInteger count = [self.collectionView numberOfItemsInSection:i];
        for (NSUInteger j = 0; j < count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrsArray addObject:attrs];
        }
        
        // 添加 section bottom 间距
        NSInteger maxIndex = [self maxYIndexOfMaxYArray];
        [self setMaxYArrayAllIndexWithValue:@([self.maxYArray[maxIndex] floatValue] + self.sectionInset.bottom)];
        
        // 添加 scetion 底部视图布局属性
        UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                             atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
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
    CGFloat xMargin = self.sectionInset.left + self.sectionInset.right + (self.columsCount - 1) * self.columnSpacing;
    // cell的宽度
    CGFloat w = (GGCollectionW - xMargin) / self.columsCount;
    // cell的高度，测试数据，随机数
    CGFloat h = 0;
    if (self.itemHeightBlock) {
        h = self.itemHeightBlock(w, indexPath);
    } else {
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:width:)]) {
            h = [self.delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath width:w];
        }
    }
    
    
    // 找出最短那一列
    NSUInteger minIndex = [self minYIndexOfMaxYArray];
    
    // cell的x值
    CGFloat x = self.sectionInset.left + minIndex * (w + self.columnSpacing);
    
    // cell的y值
    CGFloat minY = [self.maxYArray[minIndex] floatValue];
    CGFloat y = indexPath.row < self.columsCount ? minY : minY + self.rowSpacing;
    
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
    [self setMaxYArrayAllIndexWithValue:@(CGRectGetMaxY(attrs.frame))];
    
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


@end
