//
//  DCStoreViewController.m
//  CDDStoreDemo
//
//  Created by apple on 2017/3/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DCStoreViewController.h"
#import "DCCustomViewController.h"
#import "DCWebViewController.h"
#import "DCStoreDetailViewController.h"
#import "DCNavigationController.h"
#import "DCStoreCollectionViewController.h"

#import "DCStoreItem.h"
#import "DCStoreItemCell.h"

#import "DCConsts.h"
#import "DCSpeedy.h"
#import "DCStoreButton.h"
#import "UIView+DCExtension.h"
#import "XWDrawerAnimator.h"
#import "DCStoreCoverLabel.h"
#import "UIViewController+XWTransition.h"
#import "UIBarButtonItem+DCBarButtonItem.h"

#import <PYSearch.h>
#import <Masonry.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <SDCycleScrollView.h>
#import <TXScrollLabelView.h>

static NSString *DCStoreItemCellID = @"DCStoreItemCell";
static UIView *coverView;

@interface DCStoreViewController ()<UITableViewDelegate , UITableViewDataSource,SDCycleScrollViewDelegate,UISearchBarDelegate,PYSearchViewControllerDelegate>
@property (nonatomic , strong) UITableView *tableView;
/* 数据 */
@property (strong , nonatomic)NSMutableArray<DCStoreItem *> *storeItem;

/* 小标题 */
@property (assign , nonatomic)NSString *scrollTitle;

/* 轮播图 */
@property (weak ,nonatomic)SDCycleScrollView *cycleScrollView;

/* cell */
@property (weak ,nonatomic)DCStoreItemCell *cell;

@end

@implementation DCStoreViewController
{
    UIButton *diffButton;
    UIButton *sameButton;
    DCStoreCoverLabel *nameLabel;
    DCStoreCoverLabel *desLabel;
    DCStoreCoverLabel *serLabel;
    DCStoreCoverLabel *exLabel;
    
}

#pragma mark - 懒加载
- (NSMutableArray<DCStoreItem *> *)storeItem
{
    if (!_storeItem) {
        _storeItem = [NSMutableArray array];
    }
    return _storeItem;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTab];
    
    [self loadStoreDatas];
    
    [self setUpHeaderView:@[@"mainHead",@"mainHead"] WithAdvertisement:@"项目整理不易，赏个星呗！"];
}

#pragma mark - 头部轮播图
- (void)setUpHeaderView : (NSArray *)bannerImages WithAdvertisement : (NSString *)advertise{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenHNoNavi * 0.4 + 15)];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenHNoNavi * 0.4 - 20) imageURLStringsGroup:bannerImages];
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycleScrollView.autoScrollTimeInterval = 5.0;
    [view addSubview:cycleScrollView];
    _cycleScrollView = cycleScrollView;
    
    cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView.delegate = self;
    self.tableView.tableHeaderView = view;
    
    
    UIView *scrollLabelView = [[UIView alloc]init];
    scrollLabelView.backgroundColor = [UIColor whiteColor];
    [cycleScrollView addSubview:scrollLabelView];
    
    UIView *intervalView = [[UIView alloc] init];
    intervalView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    [view addSubview:intervalView];
    
    [scrollLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cycleScrollView.mas_left);
        make.right.mas_equalTo(cycleScrollView.mas_right);
        [make.top.mas_equalTo(cycleScrollView.mas_top)setOffset:cycleScrollView.dc_height];
        make.height.mas_equalTo(@(30));
    }];
    
    [intervalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cycleScrollView.mas_left);
        make.right.mas_equalTo(cycleScrollView.mas_right);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.height.mas_equalTo(@(7));
    }];
    
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"notice"];
    [scrollLabelView addSubview:image];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(scrollLabelView.mas_left)setOffset:10];
        make.centerY.mas_equalTo(scrollLabelView.mas_centerY);
        make.width.mas_equalTo(@(14));
        make.height.mas_equalTo(@(15));
    }];
    
    TXScrollLabelView *labelView = [TXScrollLabelView scrollWithTitle:advertise type:TXScrollLabelViewTypeFlipNoRepeat velocity:5.0 options:UIViewAnimationOptionCurveEaseInOut];
    labelView.frame = CGRectMake(20, 6, ScreenW - 15, 20);
    labelView.backgroundColor = [UIColor clearColor];
    labelView.font = [UIFont systemFontOfSize:12];
    labelView.scrollTitleColor = [UIColor blackColor];
    labelView.userInteractionEnabled = NO;
    [scrollLabelView addSubview:labelView];
    [labelView beginScrolling];
    
    //喇叭通知点击
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:clickBtn];
    clickBtn.frame = CGRectMake(0, cycleScrollView.dc_bottom, ScreenW, 10 * 3);
    [clickBtn addTarget:self action:@selector(shopAdvertiseClick) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    __weak typeof(self)weakSelf = self;
    DCWebViewController *bannerWebVc = [[DCWebViewController alloc] init];
    if (index == 0) {
        
        bannerWebVc.url = @"https://www.baidu.com/";
        
    }else if(index == 1){
        
        bannerWebVc.url = @"https://github.com/RocketsChen/CDDStore";
    }
    
    [weakSelf.navigationController pushViewController:bannerWebVc animated:YES];
}

#pragma mark - 点击了广告跳转
- (void)shopAdvertiseClick {
    
    DCWebViewController *titleWebVc = [[DCWebViewController alloc] init];
    
    titleWebVc.url = @"https://www.baidu.com/";
    
    [self.navigationController pushViewController:titleWebVc animated:YES];
}

#pragma mark - 中间筛选视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    
    [self setUpSeachPhoneView:view];
    
    return view;
}


#pragma mark - 商品数
- (void)setUpSeachPhoneView:(UIView *)view
{
    UIView *seachPhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    seachPhoneView.backgroundColor = [UIColor whiteColor];
    
    UILabel *showNum_Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW * 0.4, 50)];
    [seachPhoneView addSubview:showNum_Label];
    NSString *shopCount = [NSString stringWithFormat:@"%zd",_storeItem.count];
    showNum_Label.text = [NSString stringWithFormat:@"共筛选出 %@ 件商品",shopCount];
    showNum_Label.font = [UIFont systemFontOfSize:12];
    
    [DCSpeedy setSomeOneChangeColor:showNum_Label SetSelectArray:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"] SetChangeColor:[UIColor orangeColor]];
    
    DCDetailButton *customButton = [DCDetailButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(ScreenW - 60, 0 , 60 , 40);
    [customButton setTitle:@"筛选" forState:UIControlStateNormal];
    [customButton setImage:[UIImage imageNamed:@"tbsearch_sortbar_filter_default"] forState:UIControlStateNormal];
    customButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [customButton addTarget:self action:@selector(customButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [seachPhoneView addSubview:customButton];
    
    [view addSubview:seachPhoneView];
}

#pragma mark - 筛选点击
- (void)customButtonClick
{
    XWDrawerAnimatorDirection direction = XWDrawerAnimatorDirectionRight;
    CGFloat distance = ScreenW * 0.8; //分享窗口宽度
    XWDrawerAnimator *animator = [XWDrawerAnimator xw_animatorWithDirection:direction moveDistance:distance];
    animator.toDuration = 0.5;
    animator.backDuration = 0.5;
    animator.parallaxEnable = YES;
    //点击当前界面返回
    DCCustomViewController *shopsCustomVc = [[DCCustomViewController alloc] init];
    shopsCustomVc.sureButtonClickBlock = ^(NSString *attributeViewBrandString,NSString * attributeViewSortString){

        NSLog(@"刷选回调 选择的品牌：%@   展示方式：%@",attributeViewBrandString,attributeViewSortString);
    };
    
    [self xw_presentViewController:shopsCustomVc withAnimator:animator];
    __weak typeof(self)weakSelf = self;
    [animator xw_enableEdgeGestureAndBackTapWithConfig:^{
        [weakSelf selfAlterViewback];
    }];

}

#pragma 退出界面
- (void)selfAlterViewback{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


- (void)loadStoreDatas
{
    NSArray *storeArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"MallShops.plist" ofType:nil]];
    _storeItem = [DCStoreItem mj_objectArrayWithKeyValuesArray:storeArray];
    
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _storeItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCStoreItemCell *cell = [tableView dequeueReusableCellWithIdentifier:DCStoreItemCellID forIndexPath:indexPath];
    _cell = cell;
    cell.storeItem = _storeItem[indexPath.row];
    __weak typeof(cell)weakCell = cell;
    cell.choseMoreBlock = ^(UIImageView *iconImageView){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{ //单列
            coverView = [UIButton buttonWithType:UIButtonTypeCustom];
            
            diffButton = [[UIButton alloc] init];
            sameButton = [[UIButton alloc] init];
            
            nameLabel = [[DCStoreCoverLabel alloc] init];
            desLabel = [[DCStoreCoverLabel alloc] init];
            serLabel = [[DCStoreCoverLabel alloc] init];
            exLabel = [[DCStoreCoverLabel alloc] init];
        });
        
        coverView.dc_height = weakCell.contentView.dc_height;
        coverView.dc_y = 0;
        coverView.dc_width = weakCell.contentView.dc_width - CGRectGetMaxX(iconImageView.frame);
        coverView.dc_x = weakCell.contentView.dc_width;
        [UIView animateWithDuration:0.5 animations:^{
            coverView.dc_x = CGRectGetMaxX(iconImageView.frame);
        }];
        
        coverView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];
        [weakCell.contentView addSubview:coverView];
        
        [diffButton setTitle:@"无相同" forState:UIControlStateNormal];
        diffButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [diffButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [diffButton setBackgroundColor:[UIColor redColor]];
        [diffButton addTarget:self action:@selector(noDiff) forControlEvents:UIControlEventTouchUpInside];
        
        [sameButton setTitle:@"找相似" forState:UIControlStateNormal];
        sameButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [sameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sameButton setBackgroundColor:[UIColor orangeColor]];
        [sameButton addTarget:self action:@selector(lookSame) forControlEvents:UIControlEventTouchUpInside];
        
        
        nameLabel.text = @"RockectChen直营店";
        
        desLabel.text = @"描述 4.9         评论（12）";
        
        serLabel.text = @"服务 4.9         有图（4）";
        
        exLabel.text = @"物流 4.9         追加（6）";
        
        NSArray *array = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"."];
        [DCSpeedy setSomeOneChangeColor:desLabel SetSelectArray:array SetChangeColor:[UIColor orangeColor]];
        [DCSpeedy setSomeOneChangeColor:serLabel SetSelectArray:array SetChangeColor:[UIColor orangeColor]];
        [DCSpeedy setSomeOneChangeColor:exLabel SetSelectArray:array SetChangeColor:[UIColor orangeColor]];
        
        [coverView addSubview:diffButton];
        [coverView addSubview:sameButton];
        
        [coverView addSubview:nameLabel];
        [coverView addSubview:desLabel];
        [coverView addSubview:serLabel];
        [coverView addSubview:exLabel];
        
        
        [diffButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(coverView).multipliedBy(0.5);
            make.right.mas_equalTo(coverView);
            make.top.mas_equalTo(coverView);
            make.width.mas_equalTo(@(60));
        }];
        
        [sameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(coverView).multipliedBy(0.5);
            make.right.mas_equalTo(coverView);
            make.top.mas_equalTo(diffButton.mas_bottom);
            make.width.mas_equalTo(@(60));
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.left.mas_equalTo(coverView.mas_left)setOffset:DCMargin];
            [make.right.mas_equalTo(sameButton.mas_left)setOffset:DCMargin];
            [make.top.mas_equalTo(coverView)setOffset:DCMargin];
            
        }];
        
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.left.mas_equalTo(coverView.mas_left)setOffset:DCMargin];
            [make.top.mas_equalTo(nameLabel.mas_bottom)setOffset:DCMargin];
            
        }];
        [serLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.left.mas_equalTo(coverView.mas_left)setOffset:DCMargin];
            [make.top.mas_equalTo(desLabel.mas_bottom)setOffset:4];
            
        }];
        [exLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.left.mas_equalTo(coverView.mas_left)setOffset:DCMargin];
            [make.top.mas_equalTo(serLabel.mas_bottom)setOffset:4];
            
        }];
        
        coverView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewRemove)];
        [coverView addGestureRecognizer:tap];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _storeItem[indexPath.row].cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCStoreDetailViewController *dcStoreDetailVc = [[DCStoreDetailViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    //传商品属性
    dcStoreDetailVc.goodspics = _storeItem[indexPath.row].goodspics;
    dcStoreDetailVc.stockStr = _storeItem[indexPath.row].stock;
    dcStoreDetailVc.shopPrice = _storeItem[indexPath.row].price;
    dcStoreDetailVc.goods_title = _storeItem[indexPath.row].goods_title;
    dcStoreDetailVc.expressage = _storeItem[indexPath.row].expressage;
    dcStoreDetailVc.saleCount = _storeItem[indexPath.row].sale_count;
    dcStoreDetailVc.site = _storeItem[indexPath.row].goods_address;
    
    [self.navigationController pushViewController:dcStoreDetailVc animated:YES];
}


- (void)setUpTab
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"商城";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DCStoreItemCell class]) bundle:nil] forCellReuseIdentifier:DCStoreItemCellID];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"search"] WithHighlighted:[UIImage imageNamed:@"search"] Target:self action:@selector(searchButtonClick)];
}

#pragma mark - 搜索
-(void)searchButtonClick
{
    NSArray *hotSeaches = @[@" 苹果7P ", @" 三星 ", @" OPPO ", @" 坚果Pro ",
                            @" 华为荣耀 "];
    
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"总有商品一款适合你", @"搜索你喜欢的商品") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {

        DCStoreCollectionViewController *storeVc = [[DCStoreCollectionViewController alloc]init];
        [searchViewController.navigationController pushViewController:storeVc animated:YES];
    }];

    searchViewController.hotSearchStyle = PYHotSearchStyleARCBorderTag;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;

    searchViewController.delegate = self;
    DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)noDiff
{
    [self coverViewRemove];
}

- (void)lookSame
{
    [self coverViewRemove];
}


#pragma mark - 移除视图
- (void)coverViewRemove
{
    [UIView animateWithDuration:0.5 animations:^{
        coverView.dc_x = _cell.contentView.dc_width;
    } completion:^(BOOL finished) {
        [coverView removeFromSuperview];
        [nameLabel removeFromSuperview];
        [desLabel removeFromSuperview];
        [serLabel removeFromSuperview];
        [exLabel removeFromSuperview];
        [diffButton removeFromSuperview];
        [sameButton removeFromSuperview];
    }];
    
}
@end
