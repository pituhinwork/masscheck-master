//
//  tabBarController.h
//  TestProject
//
//  Created by BachUng on 5/26/17.
//  Copyright © 2017 BachUng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController
@property (nonatomic,strong) UIViewController *inforView;
@property (nonatomic,strong) UIViewController *dianoticView;
@property (nonatomic,strong) UIViewController *resultView;
@property (nonatomic,strong) UIViewController *settingView;
@property (nonatomic,strong) UIViewController *upgradeView;
@end
