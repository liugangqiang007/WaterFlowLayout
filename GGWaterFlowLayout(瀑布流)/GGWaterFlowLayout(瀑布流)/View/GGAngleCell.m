//
//  GGAngleCell.m
//  GGWaterFlowLayout(瀑布流)
//
//  Created by LGQ on 16/7/19.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import "GGAngleCell.h"

@interface GGAngleCell ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *textLabel;
@end

@implementation GGAngleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self imageView];
        [self textLabel];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setStyle:(GGAngleCellStyle)style {
    _style = style;
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    CGFloat imageViewW = 0;
    CGFloat imageViewH = 0;
    
    CGFloat textLabelX = 0;
    CGFloat textLabelY = 0;
    CGFloat textLabelW = 0;
    CGFloat textLabelH = 0;
    
    if (self.style == GGAngleCellStyleLeft || self.style == GGAngleCellStyleRight) {
        imageViewH = height;
        textLabelH = height;
        
        imageViewW = width * 0.6;
        textLabelW = width - imageViewW;
        
        imageViewX = self.style == GGAngleCellStyleLeft ? 0 : textLabelW;
        textLabelX = self.style == GGAngleCellStyleLeft ? imageViewW : 0;
        
    } else {
        imageViewH = height * 0.6;
        textLabelH = height - imageViewH;
        
        imageViewW = width;
        textLabelW = width;
        
        imageViewY = self.style == GGAngleCellStyleTop ? 0 : textLabelH;
        textLabelY = self.style == GGAngleCellStyleTop ? imageViewH : 0;
    }
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    self.textLabel.frame = CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH);
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        imageView.backgroundColor = [UIColor blueColor];
        _imageView = imageView;
    }
    return _imageView;
}
- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *textLabel = [[UILabel alloc] init];
        [self.contentView addSubview:textLabel];
        textLabel.backgroundColor = [UIColor grayColor];
        _textLabel = textLabel;
    }
    return _textLabel;
}

@end
