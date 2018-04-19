//
//  GGMainViewController.m
//  GGWaterFlowLayout(瀑布流)
//
//  Created by LGQ on 2018/3/20.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "GGMainViewController.h"
#import "GGFallsLayoutViewController.h"
#import "GGAngleLayoutViewController.h"

static NSString *cellIdentifier = @"reuseIdentifier";

@interface GGMainViewController ()<UITableViewDelegate, UITableViewDataSource>
// 数据
@property (nonatomic, strong) NSArray<NSDictionary *> *titleArray;
// view
@property (nonatomic, strong) UITableView *tableView;

@end


@implementation GGMainViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
    [self initSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)initDataSource {
    self.titleArray = @[
                        @{@"clsName" : @"GGFallsLayoutViewController", @"title" : @"瀑布流布局"},
                        @{@"clsName" : @"GGAngleLayoutViewController", @"title" : @"三角形布局"},
                        ];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *rowDict = self.titleArray[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = rowDict[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *rowDict = self.titleArray[indexPath.row];
    
    UIViewController *vc = [[NSClassFromString(rowDict[@"clsName"]) alloc] init];
    vc.title = rowDict[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
