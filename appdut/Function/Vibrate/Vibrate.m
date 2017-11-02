//
//  Vibrate.m
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright Coffee 2012 ccinteg. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "iDevice.h"
#import "Vibrate.h"

#import "Utilities.h"
#import "AppDelegate.h"
#import "MainTestViewController.h"
#define VIBRATE_NONE 0
#define VIBRATE_STARTED 1
#define VIBRATE_FINISHED 2

@implementation Vibrate
@synthesize key;
@synthesize ID;
- (id) init
{
    self = [super init];
    key = @"Vibration";
    ID = -1;
    status = VIBRATE_NONE;
    
    return self;
}

- (void) dealloc
{
}

- (void) failedCheck:(NSString*)desc
{
    if(status != VIBRATE_FINISHED)
    {
        status = VIBRATE_FINISHED;
    
        [self.parentView updateResult:ID value:[NSString stringWithFormat:@" %@#FAILED#%@",key,desc]];

    }

}

- (void) successCheck:(NSString*)desc
{
    if(status != VIBRATE_FINISHED)
    {
        status = VIBRATE_FINISHED;
        
        [self.parentView updateResult:ID value:[NSString stringWithFormat:@" %@#PASSED#%@",key,desc]];
    }
}
- (void)releaseResouce
{
    

}
// This function is started when Master Linux request
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param
{
    
    NSLog(@"%s",__FUNCTION__);
//    if(status == VIBRATE_FINISHED)
    {
        status = VIBRATE_NONE;
    }
    
    if(status != VIBRATE_NONE)
        return;

    [self askResult];
    [self performSelector:@selector(preTest) withObject:nil afterDelay:1];

   
}
- (void) preTest
{
    
    if(status == VIBRATE_NONE)
    {
        status = VIBRATE_STARTED;
        [self performSelector:@selector(vibrate) withObject:Nil afterDelay:0];
        [self performSelector:@selector(vibrate) withObject:Nil afterDelay:2];
        [self performSelector:@selector(vibrate) withObject:Nil afterDelay:4];
    }
}

- (void) vibrate
{
    if(status !=VIBRATE_FINISHED)
    {
    //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}


- (void) sendSuccess:(int)flag
{
    if (flag == 1) {
        [self successCheck:@""];
    }
    else {
        [self failedCheck:@""];
    }
}

- (void) askResult
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vibration test" message:@"Did the device vibrate?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
//    [alert show];
//    [alert release];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
        [self successCheck:@""];
    else [self failedCheck:@""];
}
@end
