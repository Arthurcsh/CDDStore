//
//  DCShopCarViewController.m
//  CDDStoreDemo
//
//  Created by mac on 2017/5/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DCShopCarViewController.h"

#import "DCShopCarItem.h"
#import "DCShopCarCell.h"

#import "DCConsts.h"

#import <Masonry.h>
#import <MJExtension.h>

static float dc_totalPrice = 0;
static int dc_jiesuanNum = 0;

@interface DCShopCarViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* 全选按钮 */
@property (weak, nonatomic) IBOutlet UIButton *allButton;
/* 总金额 */
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
/* 结算 */
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
/* 编辑 */
@property (nonatomic, weak) UIButton *editButton;
/* 数据 */
@property (strong , nonatomic)NSMutableArray<DCShopCarItem *> *carItems;

@end

static NSString *DCShopCarCellID = @"DCShopCarCell";

@implementation DCShopCarViewController

#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 63, ScreenW, ScreenH - 64 - 49 - 55) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DCShopCarCell class]) bundle:nil] forCellReuseIdentifier:DCShopCarCellID];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray<DCShopCarItem *> *)catItems
{
    if (!_carItems) {
        _carItems = [NSMutableArray array];
    }
    return _carItems;
}


#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpTab];
    
    [self setUpShopCarData];

}

- (void)setUpTab
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *editButton = [[UIButton alloc] initWithFrame:(CGRect){10, 10, 44, 44}];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitle:@"完成" forState:UIControlStateSelected];
    editButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editBarItemBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.editButton = editButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
}

#pragma mark - 编辑按钮
- (void)editBarItemBtnClick {
    _editButton.selected = !_editButton.selected;
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

#pragma mark - 购物车数据
- (void)setUpShopCarData
{
    NSArray *storeArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"shopCarItem.plist" ofType:nil]];
    _carItems = [DCShopCarItem mj_objectArrayWithKeyValuesArray:storeArray];
    
    [self.tableView reloadData];
}

#pragma mark - 全选
- (IBAction)allButtonClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.selected = YES;
        int i = 0;
        float totalCount = 0;
        for (DCShopCarItem *model in self.catItems) {
            model.isSelected = YES;
            float total = [model.goodsnum intValue]  * [model.price floatValue];
            totalCount += total;
            i += [model.goodsnum intValue];
        }
        dc_jiesuanNum = i;
        dc_totalPrice = totalCount;
        [_closeButton setTitle:[NSString stringWithFormat:@"结算(%d)", i] forState:UIControlStateNormal];
        _totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", totalCount];
        [self.tableView reloadData];
    }else {
        sender.selected = NO;
        for (DCShopCarItem *model in self.catItems) {
            model.isSelected = NO;
        }
        [_closeButton setTitle:@"结算(0)" forState:UIControlStateNormal];
        _totalMoneyLabel.text = @"￥0";
        dc_jiesuanNum = 0;
        dc_totalPrice = 0;
        [self.tableView reloadData];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _carItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:DCShopCarCellID forIndexPath:indexPath];
    __weak typeof(self)weakSelf = self;
    
    cell.selectBtnClick = ^(BOOL isSelected) {
        DCShopCarItem *model = weakSelf.carItems[indexPath.row];
        model.isSelected = isSelected;
        if (isSelected) {
            dc_jiesuanNum += [model.goodsnum intValue];
            dc_totalPrice += [model.goodsnum intValue] * [model.price floatValue];
            weakSelf.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", dc_totalPrice];
            [weakSelf.closeButton setTitle:[NSString stringWithFormat:@"结算(%d)", dc_jiesuanNum] forState:UIControlStateNormal];
            
        } else {
            dc_jiesuanNum -= [model.goodsnum intValue];
            dc_totalPrice -= [model.goodsnum intValue] * [model.price floatValue];
            weakSelf.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", dc_totalPrice];
            [weakSelf.closeButton setTitle:[NSString stringWithFormat:@"结算(%d)", dc_jiesuanNum] forState:UIControlStateNormal];

        }
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        //cell 选择判断
        int selectCount = 0;
        for (DCShopCarItem *model in weakSelf.carItems) {
            if (!model.isSelected) {// 全选未选择
                strongSelf.allButton.selected = NO;
            }else{
                // 单个选择累计
                selectCount ++;
            }
            if (selectCount == weakSelf.carItems.count) {// 累计全部 所有按钮选择
                strongSelf.allButton.selected = YES;
            }
        }

    };

    cell.carItem = _carItems[indexPath.row];
    
    return cell;
}


#pragma mark - 结算
- (void)closeButtonClick
{
    
}

#pragma mark - 编辑状态的事件处理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {  // 点击了“删除”
        [self.catItems removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _carItems[indexPath.row].cellHeight;
}


#pragma mark - 界面消失数据还原
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_closeButton setTitle:@"结算(0)" forState:UIControlStateNormal];
    for (DCShopCarItem *model in self.carItems) {
        model.isSelected = NO;
    }
    [self.tableView reloadData];
    self.allButton.selected = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 全局变量 置为0
    dc_totalPrice = 0;
    dc_jiesuanNum = 0;
    _totalMoneyLabel.text = @"￥0";
    [_closeButton setTitle:@"结算(0)" forState:UIControlStateNormal];
}

@end
