//
//  StartTestingViewController.m
//  MassTrade
//
//  Created by Admin on 9/28/17.
//  Copyright © 2017 GDT. All rights reserved.
//

#import "StartTestingViewController.h"
#import "MainTestViewController.h"
#import "DeviceInfoViewController.h"

@interface StartTestingViewController ()

@end

@implementation StartTestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startButtonTapped:(id)sender {
    MainTestViewController* testController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTestViewController"];
    [self presentViewController:testController animated:YES completion:nil];
}
- (IBAction)myInfoButtonTapped:(id)sender {

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
