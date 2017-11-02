//
//  Engrave.h
//  IVERIFY
//
//  Created by Bach Ung on 9/12/14.
//  Copyright (c) 2014MaTran All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageBox.h"
#define TOUCHID_NONE        0
#define TOUCHID_START       1
#define TOUCHID_FINISHED    2

@class MainTestViewController;
//@interface TouchID : NSObject <SBUIBiometricEventMonitorDelegate>
@interface TouchID : NSObject
{
    int status;
    int ID;
    MessageBox *msgBox;
    BOOL isAskFromLinux;
    BOOL isFinished;
    BOOL isTestAgain;
    int isPassed;
//    BOOL _wasMatching;
//    id _monitorDelegate;
//    NSArray *_monitorObservers;
//    BOOL isMonitoringEvents;
    NSThread* myThread;
    int callCount;
    NSTimer *timer;
    int count;
    UIAlertView *alert;
    
    BOOL isAskSetupTouch;
}

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) int ID;
@property (nonatomic, assign) int isPassed;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) MainTestViewController *parentView;

- (void) successCheck:(NSString*)desc;
- (void) failedCheck:(NSString*)desc;
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param;
- (void) preTest;
- (void) testerCheck;
- (BOOL) isStetupTouchID;
@end
