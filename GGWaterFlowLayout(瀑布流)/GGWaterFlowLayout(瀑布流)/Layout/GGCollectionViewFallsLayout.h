//
//  GGCollectionViewLayout.h
//  GGWaterFlowLayout(瀑布流)
//
//  Created by LGQ on 16/5/4.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 瀑布流
 */

@class GGCollectionViewFallsLayout;

@protocol GGCollectionViewFallsLayoutDelegate <NSObject>

@required
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(GGCollectionViewFallsLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
                    width:(CGFloat)width;

@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(GGCollectionViewFallsLayout *)layout
 heightForHeaderInSection:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(GGCollectionViewFallsLayout *)layout
 heightForFooterInSection:(NSInteger)section;

@end


@interface GGCollectionViewFallsLayout : UICollectionViewLayout

/**  总列数,默认是3  **/
@property (nonatomic, assign) NSInteger columsCount;
/**  行间距  **/
@property (nonatomic, assign) CGFloat rowSpacing;
/**  列间距  **/
@property (nonatomic, assign) CGFloat columnSpacing;
/**  组边距  **/
@property (nonatomic, assign) UIEdgeInsets sectionInset;


@property (nonatomic, weak) id<GGCollectionViewFallsLayoutDelegate> delegate;
/**  输入 item 高的 block, 优先级高于 delegate  **/
@property (nonatomic, strong) CGFloat(^itemHeightBlock)(CGFloat itemWidth, NSIndexPath *indexPath);

#pragma mark - 构造方法
+ (instancetype)layoutWithColumsCount:(NSInteger)columsCount;
- (instancetype)initWithColumsCount:(NSInteger)columsCount;

/** 属性设置 **/
- (void)setRowSpacing:(CGFloat)rowSpacing columnSpacing:(CGFloat)columnSpacing sectionInset:(UIEdgeInsets)sectionInset;

@end
