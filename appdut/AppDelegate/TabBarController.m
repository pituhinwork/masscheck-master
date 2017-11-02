//
//  tabBarController.m
//  TestProject
//
//  Created by BachUng on 5/26/17.
//  Copyright © 2017 BachUng. All rights reserved.
//

#import "TabBarController.h"
#include "AppDelegate.h"

@interface TabBarController ()

@end

@implementation TabBarController

@synthesize inforView;
@synthesize dianoticView;
@synthesize resultView;
@synthesize settingView;
@synthesize upgradeView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor brownColor];
    
    UIViewController *item1 = [[UIViewController alloc] init];
    item1.view.frame = [UIScreen mainScreen].bounds;
    item1.title = @"Device Information";
    item1.view.backgroundColor = [UIColor whiteColor];
    inforView = item1;
   
    UIViewController *item2 = [[UIViewController alloc] init];
    item2.view.frame = [UIScreen mainScreen].bounds;
    item2.title = AppShare.DiagnosticsText;
    item2.view.backgroundColor = [UIColor whiteColor];
    dianoticView = item2;
   
    UIViewController *item3 = [[UIViewController alloc] init];
    item3.view.frame = [UIScreen mainScreen].bounds;
    item3.title = @"Test report";
    item3.view.backgroundColor = [UIColor whiteColor];
    resultView = item3;
    
    UIViewController *item4 = [[UIViewController alloc] init];
    item4.view.frame = [UIScreen mainScreen].bounds;
    item4.title = @"Settings";
    item4.view.backgroundColor = [UIColor whiteColor];
    settingView = item4;
   
    UIViewController *item5 = [[UIViewController alloc] init];
    item5.view.frame = [UIScreen mainScreen].bounds;
    item5.title = @"Upgrade";
    item5.view.backgroundColor = [UIColor whiteColor];
    upgradeView = item5;
   
  
    
    UINavigationController *tab1Nav = [[UINavigationController alloc] initWithRootViewController:inforView];
    tab1Nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Information" image:Nil selectedImage:nil];
    tab1Nav.tabBarItem.image =  [UIImage imageNamed:@"infoTab.png"];
    //    tab1Nav.tabBarItem.selectedImage = [UIImage imageNamed:@"infoTab.png"];
    
    UINavigationController *tab2Nav = [[UINavigationController alloc] initWithRootViewController:dianoticView];
    tab2Nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:AppShare.DiagnosticsText image:Nil selectedImage:nil];
    tab2Nav.tabBarItem.image = [UIImage imageNamed:@"chucnangTab.png"];
    
    UIBarButtonItem *btRetestFunc = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(RetestFunc:)];
    [btRetestFunc setImage:[UIImage imageNamed:@"retestnav.png"]];
    dianoticView.navigationItem.rightBarButtonItem = btRetestFunc;

    
    
    UINavigationController *tab3Nav = [[UINavigationController alloc] initWithRootViewController:resultView];
    tab3Nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Report" image:Nil selectedImage:nil];
   tab3Nav.tabBarItem.image = [UIImage imageNamed:@"resultTab.png"];

    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:AppShare.viewController action:@selector(ExportInfo:)];
    [anotherButton setImage:[UIImage imageNamed:@"exportnav.png"]];
    resultView.navigationItem.rightBarButtonItem = anotherButton;

    
    UINavigationController *tab4Nav = [[UINavigationController alloc] initWithRootViewController:settingView];
    tab4Nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:Nil selectedImage:nil];
    tab4Nav.tabBarItem.image = [UIImage imageNamed:@"settingTab.png"];
    
    UINavigationController *tab5Nav = [[UINavigationController alloc] initWithRootViewController:upgradeView];
    tab5Nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Upgrade" image:Nil selectedImage:nil];
    tab5Nav.tabBarItem.image = [UIImage imageNamed:@"upgradeTab.png"];
    
    [self setViewControllers:@[tab2Nav,tab1Nav,tab3Nav,tab5Nav,tab4Nav] animated:NO];
    self.selectedIndex = 0;
    
//    [item1 release];
//    [item2 release];
//    [item3 release];
//    [item4 release];
//    [item5 release];
}

-(void)RetestFunc:(id)sender
{
    AppLog();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
