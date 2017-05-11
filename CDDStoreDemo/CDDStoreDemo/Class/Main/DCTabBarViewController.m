//
//  DCTabBarViewController.m
//  CDDStoreDemo
//
//  Created by apple on 2017/3/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#define DCClassKey  @"rootVCClassString"
#define DCTitleKey  @"title"
#define DCImageKey  @"imageName"
#define DCSelImageKey  @"selectedImageName"


#import "DCTabBarViewController.h"
#import "DCNavigationController.h"
#import "DCStoreViewController.h"
#import "DCMineViewController.h"
#import "DCShopCarViewController.h"

@interface DCTabBarViewController ()

@end

@implementation DCTabBarViewController

#pragma mark - 设置tabBar字体格式
+(void)load
{
    UITabBarItem *titleItem = [UITabBarItem appearance];
    //正常
    [titleItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor] , NSFontAttributeName : [UIFont systemFontOfSize:11]} forState:UIControlStateNormal];
    //选中
    [titleItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
}


/**
 提供两种加载在控制器的方法
 a.
 */
- (void)viewDidLoad {
    [super viewDidLoad];

//    [self setUpAllChildView];
    
    [self setUpAddChilViewController];
}

#pragma mark - 加载子控制器
- (void)setUpAddChilViewController
{
    //商城
    NSArray *childArray = @[@{
                                DCClassKey : @"DCStoreViewController",
                                DCTitleKey : @"商城",
                                DCImageKey : @"home_home_tab",
                                DCSelImageKey : @"home_home_tab_s"
                                
                                },

                            @{
                                DCClassKey : @"DCShopCarViewController",
                                DCTitleKey : @"购物车",
                                DCImageKey : @"home_home_tab",
                                DCSelImageKey : @"home_home_tab_s"
                                
                                },
                            @{
                                DCClassKey : @"DCMineViewController",
                                DCTitleKey : @"我的",
                                DCImageKey : @"home_home_tab",
                                DCSelImageKey : @"home_home_tab_s"
                                
                                }];
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc =[NSClassFromString(dict[DCClassKey]) new];
        vc.title = dict[DCTitleKey];
        DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.image = [UIImage imageNamed:dict[DCImageKey]];
        item.selectedImage = [[UIImage imageNamed:dict[DCSelImageKey]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self addChildViewController:nav];
    }];

}



//#pragma mark - 添加子控制器
//-(void)setUpAllChildView
//{
//    //商城
//    DCStoreViewController *indentVc = [[DCStoreViewController alloc]init];
//    [self setUpOneViewController:indentVc WithImage:@"home_home_tab" WithSelImage:@"home_home_tab_s" WithTitle:@"商城"];
//    
//    DCShopCarViewController *shopCarVc = [[DCShopCarViewController alloc]init];
//    [self setUpOneViewController:shopCarVc WithImage:@"home_home_tab" WithSelImage:@"home_home_tab_s" WithTitle:@"商城"];
//    
//    DCMineViewController *meVc = [[DCMineViewController alloc]init];
//    [self setUpOneViewController:meVc WithImage:@"home_home_tab" WithSelImage:@"home_home_tab_s" WithTitle:@"我的"];
//    
//}
//
//
//- (void)setUpOneViewController :(UIViewController *)Vc WithImage:(NSString *)image WithSelImage:(NSString *)selImage WithTitle:(NSString *)title{
//    
//    DCNavigationController *navC = [[DCNavigationController alloc]initWithRootViewController:Vc];
//    Vc.tabBarItem.image = [UIImage imageNamed:image];
//    Vc.tabBarItem.selectedImage = [UIImage imageNamed:selImage];
//    Vc.tabBarItem.title = title;
//    [self addChildViewController:navC];
//}

@end
