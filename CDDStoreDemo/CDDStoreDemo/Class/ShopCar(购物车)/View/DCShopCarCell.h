//
//  DCShopCarCell.h
//  CDDStoreDemo
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 RockectChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCShopCarItem;

@interface DCShopCarCell : UITableViewCell

/* 购物车属性 */
@property (strong , nonatomic)DCShopCarItem *carItem;

/* 商品选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton *storeSelectButton;

@property (nonatomic, copy) void (^selectBtnClick)(BOOL isSelecteds);

@property (nonatomic, copy) void (^allSelectBtnClick)(BOOL isSelecteds);



#pragma mark - 后续完成
/* 商品每组全选选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton *storeAllSectionSelectBtn;
/* 商店名 */
@property (weak, nonatomic) IBOutlet UIButton *storeName;
/* 商编辑 */
@property (weak, nonatomic) IBOutlet UIButton *storeEditBtn;

@end
