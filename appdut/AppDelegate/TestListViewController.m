//
//  TestListViewController.m
//  MassTrade
//
//  Created by Admin on 9/29/17.
//  Copyright © 2017 GDT. All rights reserved.
//

#import "TestListViewController.h"
#import "TestListTableViewCell.h"
#import "AppDelegate.h"

@interface TestListViewController ()

@end

@implementation TestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    AppShare = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(AppShare.testedData == Nil)
        AppShare.testedData = [[NSMutableArray alloc] init];
    else [AppShare.testedData removeAllObjects];
    int totals = AppShare.tableData.count;
    int passed = 0;
    for (int i = 0; i< totals; i++) {
        NSString *temp = AppShare.tableData[i];
        if ([temp containsString:@"PASSED"]) {
            passed += 1;
            [AppShare.testedData addObject:@"1"];
        }
        else if ([temp containsString:@"FAILED"]) {
            [AppShare.testedData addObject:@"2"];
        }
        else {
            [AppShare.testedData addObject:@"0"];
        }
    }
    NSLog(@"%@", AppShare.testedData);
    _progressBar.maxValue = 100;
    _progressBar.value = (passed*100/totals);
}

- (void)viewWillAppear:(BOOL)animated
{
    [_tableView flashScrollIndicators];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (AppShare.canCheck == 0)
        return;
    AppShare.checkListEnabled = YES;
    AppShare.checkListNum = indexPath.row;
    [self dismissViewControllerAnimated:true completion:Nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (AppShare.tableData)
        return AppShare.tableData.count;
    else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView flashScrollIndicators];
    static NSString *celldentifier = @"TestListTableViewCell";
    TestListTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:celldentifier];
    NSLog(@"%@", AppShare.tableData);
    NSString *data = AppShare.tableData[indexPath.row];
    if ([data containsString:@"PASSED"]) {
        myCell.iconImage.image = [UIImage imageNamed:@"icon_finish"];
    }
    else if ([data containsString:@"FAILED"]) {
        myCell.iconImage.image = [UIImage imageNamed:@"icon_testfailed"];
    }
    else {
        myCell.iconImage.image = [UIImage imageNamed:@"icon_needtodo"];
    }
    [myCell.itemLabel setText:[[data componentsSeparatedByString:@"#"][0] uppercaseString]];
    if (AppShare.canCheck == 0) {
        [myCell.itemLabel setTextColor:[UIColor colorWithWhite:0.6 alpha:1]];
    }
    else {
        [myCell.itemLabel setTextColor:[UIColor colorWithWhite:0 alpha:1]];
    }
    return myCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:Nil];
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
