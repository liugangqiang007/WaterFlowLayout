//
//  GGCollectionViewAngleLayout.h
//  GGWaterFlowLayout(瀑布流)
//
//  Created by LGQ on 16/7/19.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Collection三角布局
 *
 *      --------    |
 *                  |
 *      --------    |
 */
@class GGCollectionViewAngleLayout;

@protocol GGCollectionViewAngleLayoutDelegate <NSObject>

@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(GGCollectionViewAngleLayout*)collectionViewLayout heightForHeaderInSection:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(GGCollectionViewAngleLayout*)collectionViewLayout heightForFooterInSection:(NSInteger)section;

@end



@interface GGCollectionViewAngleLayout : UICollectionViewLayout

/**  行间距  **/
@property (nonatomic, assign) CGFloat rowSpacing;
/**  列间距  **/
@property (nonatomic, assign) CGFloat columnSpacing;
/**  组边距  **/
@property (nonatomic, assign) UIEdgeInsets sectionInset;

@property (nonatomic, weak) id<GGCollectionViewAngleLayoutDelegate> delegate;

+ (instancetype)angleLayout;

/** 属性设置 **/
- (void)setRowSpacing:(CGFloat)rowSpacing columnSpacing:(CGFloat)columnSpacing sectionInset:(UIEdgeInsets)sectionInset;

@end
