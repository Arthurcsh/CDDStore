//
//  DCShopCarItem.m
//  CDDStoreDemo
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 RockectChen. All rights reserved.
//

#import "DCShopCarItem.h"
#import "DCSpeedy.h"
#import "DCConsts.h"

@implementation DCShopCarItem


- (CGFloat)cellHeight
{
    if (_cellHeight) return _cellHeight;
    CGSize commentSize = [DCSpeedy calculateTextSizeWithText:_goods_title WithTextFont:14 WithMaxW:ScreenW - 153];
    CGSize attriSize = [DCSpeedy calculateTextSizeWithText:_goodsattrs WithTextFont:14 WithMaxW:ScreenW - 188];
    _cellHeight = 45 + commentSize.height + attriSize.height + 10;
    
    return _cellHeight;
}




@end
