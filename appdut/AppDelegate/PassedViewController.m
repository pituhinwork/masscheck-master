//
//  PassedViewController.m
//  MassTrade
//
//  Created by Admin on 9/29/17.
//  Copyright © 2017 GDT. All rights reserved.
//

#import "PassedViewController.h"

@interface PassedViewController ()

@end

@implementation PassedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    IMMTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
}

- (void) timerHandler {
    [IMMTimer invalidate];
    IMMTimer = nil;
    [self dismissViewControllerAnimated:true completion:nil];
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
