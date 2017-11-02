//
//  Appearance.m
//  MassTrade
//
//  Created by BachUng on 7/31/17.
//  Copyright © 2017MaTran All rights reserved.
//
#import "AppDelegate.h"
#import "Appearance.h"
#import "MainTestViewController.h"

#define APPEARANCE_NONE 0
#define APPEARANCE_START 1
#define APPEARANCE_FINISHED 2

@interface Appearance ()

@end

@implementation Appearance
@synthesize ID;
@synthesize key;

- (void) dealloc
{
}
- (id) init
{
    self = [super init];
    key = @"Appearance";
    ID = -1;
    status = APPEARANCE_NONE;
    AppShare = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) successCheck:(NSString*)desc
{
    if (status != APPEARANCE_FINISHED)
    {
        status = APPEARANCE_FINISHED;
        
        [self.parentView updateResult:ID value:[NSString stringWithFormat:@" %@#%@#%@",key,@"PASSED",desc]];
        [self.parentView finishTest:key position:ID];
    }
    
}
- (void) failedCheck:(NSString*)desc
{
    if (status != APPEARANCE_FINISHED)
    {
        status = APPEARANCE_FINISHED;
        [self.parentView updateResult:ID value:[NSString stringWithFormat:@" %@#%@#%@",key,@"FAILED",desc]];
        [self.parentView finishTest:key position:ID];
    }
}
- (void) releaseResouce
{

    
}

- (void) startAutoTest:(NSString*)rKey param:(NSString*)param
{
    if(status == APPEARANCE_FINISHED)
    {
        status = APPEARANCE_NONE;
    }
    if (status != APPEARANCE_NONE)
        return;
    status = APPEARANCE_START;
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
