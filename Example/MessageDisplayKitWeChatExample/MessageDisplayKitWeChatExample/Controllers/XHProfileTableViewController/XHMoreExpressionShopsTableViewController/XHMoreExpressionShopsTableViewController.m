//
//  XHMoreExpressionShopsTableViewController.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-22.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHMoreExpressionShopsTableViewController.h"

#import "XHMoreExpressionShopsTableViewCell.h"

#import "XHExpressionDetailTableViewController.h"

@interface XHMoreExpressionShopsTableViewController ()

@property (nonatomic, strong) UIImageView *topEmotionImageView;

@end

@implementation XHMoreExpressionShopsTableViewController

- (void)loadDataSource {
    self.isDataLoading = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *dataSource = [NSMutableArray arrayWithArray:@[@"emotionShopOne", @"emotionShopOne", @"emotionShopOne", @"emotionShopOne", @"emotionShopTwo", @"emotionShopOther", @"emotionShopTwo", @"", @"emotionShopTwo", @"emotionShopOther", @"emotionShopOne", @"emotionShopOther", @"emotionShopTwo", @"emotionShopOne", @"emotionShopTwo"]];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.isDataLoading = NO;
            if (self.requestCurrentPage) {
                NSMutableArray *indexPaths = [NSMutableArray array];
                [dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:self.dataSource.count + idx inSection:0]];
                }];
                
                [self.dataSource addObjectsFromArray:dataSource];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
                [self endLoadMoreRefreshing];
            } else {
                self.dataSource = dataSource;
                [self.tableView reloadData];
                [self endPullDownRefreshing];
            }
        });
    });
}

#pragma mark - Propertys

- (UIImageView *)topEmotionImageView {
    if (!_topEmotionImageView) {
        _topEmotionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 160)];
        _topEmotionImageView.image = [UIImage imageNamed:@"AlbumHeaderBackgrounImage"];
    }
    return _topEmotionImageView;
}

#pragma mark - Life cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startPullDownRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"Expression", @"MessageDisplayKitString", @"");
    
    self.tableView.tableHeaderView = self.topEmotionImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    XHMoreExpressionShopsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XHMoreExpressionShopsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.newExpressionEffect = YES;
    cell.expressionStateType = (indexPath.row % 2 ? XHExpressionStateTypeRemoteExpression : XHExpressionStateTypeDownloadedExpression);
    
    cell.imageView.image = [UIImage imageNamed:self.dataSource[indexPath.row]];
    cell.textLabel.text = @"甜甜私房猫";
    cell.detailTextLabel.text = @"梦猫小气的甜蜜旅行";
    
    return cell;
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XHExpressionDetailTableViewController *expressionDetailTableViewController = [[XHExpressionDetailTableViewController alloc] init];
    [self pushNewViewController:expressionDetailTableViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

@end
