//
//  GGAngleLayoutViewController.m
//  GGWaterFlowLayout(瀑布流)
//
//  Created by LGQ on 2018/3/20.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "GGAngleLayoutViewController.h"
#import "GGCollectionViewAngleLayout.h"
#import "GGAngleCell.h"

static NSString * const reuseIdentifier = @"GGCollectionViewAngleCellID";

@interface GGAngleLayoutViewController ()<GGCollectionViewAngleLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation GGAngleLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
}

- (void)initSubviews {
    
    GGCollectionViewAngleLayout *layout = [GGCollectionViewAngleLayout angleLayout];
    layout.delegate = self;
    [layout setRowSpacing:5 columnSpacing:5 sectionInset:UIEdgeInsetsMake(10, 5, 10, 5)];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[GGAngleCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"supplementaryView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"supplementaryView"];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 32;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GGAngleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSInteger index = indexPath.row % 6;
    GGAngleCellStyle style;
    if (index == 2 || index == 3) {
        style = GGAngleCellStyleTop;
    } else if (index == 0 || index == 4){
        style = GGAngleCellStyleLeft;
    } else {
        style = GGAngleCellStyleRight;
    }
    cell.style = style;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"supplementaryView" forIndexPath:indexPath];
    view.backgroundColor = [UIColor greenColor];
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        view.backgroundColor = [UIColor blueColor];
    }
    return view;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
