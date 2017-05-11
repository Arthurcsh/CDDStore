//
//  DCShopCarItem.h
//  CDDStoreDemo
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 RockectChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DCShopCarItem : NSObject

/** 购物车 商品标题  */
@property (nonatomic, copy) NSString *goods_title;
/** 购物车  商品价格 */
@property (nonatomic, copy) NSString *price;
/** 购物车 商品 单个数量 */
@property (nonatomic, copy) NSString *goodsnum;
/** 购物车 商品 已选 */
@property (nonatomic, copy) NSString *goodsattrs;
/** 购物车 商品 图片 */
@property (nonatomic, copy) NSString *imgs;


/* 购物车商品选择 */
@property (nonatomic,assign)BOOL isSelected;
/* 商户商品全选商品选择 */
@property (nonatomic,assign)BOOL allIsSelected;


/** cell行高 */
@property (nonatomic , assign) CGFloat cellHeight;

@end
