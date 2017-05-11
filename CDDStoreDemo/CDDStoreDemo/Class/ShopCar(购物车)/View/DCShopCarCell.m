//
//  DCShopCarCell.m
//  CDDStoreDemo
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 RockectChen. All rights reserved.
//

#import "DCShopCarCell.h"

#import "DCShopCarItem.h"

@interface DCShopCarCell()


/* 商品头像 */
@property (weak, nonatomic) IBOutlet UIImageView *storeCarImageView;
/* 商品标题 */
@property (weak, nonatomic) IBOutlet UILabel *storeCarTitleLabel;
/* 商品已选种类 */
@property (weak, nonatomic) IBOutlet UILabel *storeCarSelectType;
/* 商品价格 */
@property (weak, nonatomic) IBOutlet UILabel *storeCarPriceLabel;
/* 商品购买数量 */
@property (weak, nonatomic) IBOutlet UILabel *storeCarNum;


@end

@implementation DCShopCarCell

- (void)setCarItem:(DCShopCarItem *)carItem
{
    _carItem = carItem;
    
    self.storeCarImageView.image = [UIImage imageNamed:carItem.imgs];
    self.storeCarNum.text = [NSString stringWithFormat:@"× %@",carItem.goodsnum];
    self.storeCarPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[carItem.price floatValue]];
    self.storeCarTitleLabel.text = carItem.goods_title;
    self.storeCarSelectType.text = carItem.goodsattrs;
    
    
    if (carItem.isSelected) {//判断cell的选中状态
        self.storeSelectButton.selected = YES;
    } else {
        self.storeSelectButton.selected = NO;
    }

}

- (IBAction)isSelectedClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectBtnClick) {
        self.selectBtnClick(sender.selected);
    }
}

- (IBAction)allIsSelectedClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.allSelectBtnClick) {
        self.allSelectBtnClick(sender.selected);
    }
}
@end
