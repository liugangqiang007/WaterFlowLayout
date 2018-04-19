//
//  GGFallsLayoutViewController.m
//  GGWaterFlowLayout(瀑布流)
//
//  Created by LGQ on 2018/3/20.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "GGFallsLayoutViewController.h"
#import "GGCollectionViewFallsLayout.h"

static NSString * const reuseIdentifier = @"GGCollectionViewFallsCellID";

@interface GGFallsLayoutViewController ()<GGCollectionViewFallsLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end



@implementation GGFallsLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self initSubviews];
}

- (void)initSubviews {
    
    GGCollectionViewFallsLayout *layout = [[GGCollectionViewFallsLayout alloc] initWithColumsCount:3];
    layout.columnSpacing = 10;
    layout.rowSpacing = 10;
    layout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}

#pragma mark - GGCollectionViewFallsLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(GGCollectionViewFallsLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
                    width:(CGFloat)width {
    return arc4random_uniform(50) + 100;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
