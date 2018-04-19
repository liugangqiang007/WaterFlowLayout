//
//  GGAngleCell.h
//  GGWaterFlowLayout(瀑布流)
//
//  Created by LGQ on 16/7/19.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GGAngleCellStyle) {
    GGAngleCellStyleLeft,
    GGAngleCellStyleRight,
    GGAngleCellStyleTop,
    GGAngleCellStyleBottom
};

@interface GGAngleCell : UICollectionViewCell

@property (nonatomic, assign) GGAngleCellStyle style;

@end
