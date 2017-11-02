//
//  DeviceInfoViewController.m
//  MassTrade
//
//  Created by Admin on 9/28/17.
//  Copyright © 2017 GDT. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "Utilities.h"
#import "iDevice.h"
#import "AppDelegate.h"
#import "MainTestViewController.h"
#import "TestListViewController.h"
#import "StartTestingViewController.h"

@interface DeviceInfoViewController ()

@end

@implementation DeviceInfoViewController
@synthesize modelDev;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppShare = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    modelDev = [[NSString alloc] initWithFormat:@"%@",[AppShare.checkPart getModelFull]];
    dicInfor = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                [[UIDevice currentDevice] name],@"name",
                getPhoneModal(4),@"productname",
                [NSString stringWithFormat:@"%@ GB",[AppShare.checkPart getCapacity]],@"capacity",
                [AppShare.checkPart getColorCode],@"color",
                [AppShare.checkPart getCarier],@"carrier",
                modelDev,@"model",
                [AppShare.checkPart deviceSerial],@"serial",
                [AppShare.checkPart deviceIMEI],@"imei",
                nil];
//
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mobileModel setText:[NSString stringWithFormat:@"%@ %@ GB",getPhoneModal(4),[AppShare.checkPart getCapacity]]];
    [_phoneColor setText:[AppShare.checkPart getColor]];
    [_phoneModel setText:modelDev];
    if ([[dicInfor objectForKey:@"carrier"] isEqualToString:@"N/A"]) {
        [_mobileType setText:@"Carrier Pending"];
    }
    else {
        [_mobileType setText:[dicInfor objectForKey:@"carrier"]];
    }
    
    [_serialNumber setText:[AppShare.checkPart deviceSerial]];
    [_phoneImei setText:[AppShare.checkPart deviceIMEI]];

}

- (void)viewWillDisappear:(BOOL)animated {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startTesting:(id)sender {
    StartTestingViewController* testController = [self.storyboard instantiateViewControllerWithIdentifier:@"StartTestingViewController"];
    [self presentViewController:testController animated:YES completion:nil];
}
- (IBAction)showTestList:(id)sender {
    TestListViewController* testController = [self.storyboard instantiateViewControllerWithIdentifier:@"TestListViewController"];
    [self presentViewController:testController animated:YES completion:nil];
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
