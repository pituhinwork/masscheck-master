//
//  TestListViewController.h
//  MassTrade
//
//  Created by Admin on 9/29/17.
//  Copyright © 2017 GDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBCircularProgressBar/MBCircularProgressBarView.h>

@interface TestListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (unsafe_unretained, nonatomic) IBOutlet MBCircularProgressBarView *progressBar;

@end
