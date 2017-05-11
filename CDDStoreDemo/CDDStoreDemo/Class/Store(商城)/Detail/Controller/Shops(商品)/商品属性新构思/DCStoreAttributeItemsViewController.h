//
//  DCStoreAttributeItemsViewController.h
//  CDDStoreDemo
//
//  Created by mac on 2017/5/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCStoreAttributeItemsViewController : UIViewController

/** 购买数量 */
@property (nonatomic, assign) NSInteger buyNum;
/** 库存 */
@property (nonatomic, strong) NSString *stock;
/** 商品价格 */
@property (nonatomic, strong) NSString *money;
/** 商品ID */
@property (nonatomic, strong) NSString *goodsid;
/** 商品头像 */
@property (nonatomic, strong) NSString *iconImage;

@end
