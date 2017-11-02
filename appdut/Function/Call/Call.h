//
//  Call.h
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCall.h>

@class MainTestViewController;
@interface Call : NSObject
{
    int status;
    int callCount;
    int countRecieve;
    
    int wlBackup;
    NSTimer *checkWareTimer;
    int ID;
    NSString *dataFileDetect;
    int stype;
    
    
    int wareCount;
    BOOL checkwareYES;
    BOOL manual;
    int wareMax;
    int wareMin;
    
    int flashCall;
    BOOL canPassWheBusy;// use for call busy
    
    NSTimer *timeOpen;// show notification
    
    int countTime;
     NSTimer *timer;
    NSTimer *checkTimer;
    NSString *numcall;
    MessageBox *msgBox;
    NSString *tempObject;
    int flag;
    int numCall;
}

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) int ID;
@property (nonatomic, assign) BOOL manual;
@property (nonatomic, assign) BOOL checkwareYES;
@property (nonatomic, assign) int wareMax;
@property (nonatomic, assign) int wareMin;
@property (nonatomic, strong) MainTestViewController *parentView;

- (void) successCheck:(NSString*)desc;
- (void) checkSuccess;
- (void) failedCheck:(NSString*)desc;
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param;

// Addition functions
- (void) callNotify:(CTCall*)call status:(NSNumber*)stsNumber;
- (void) forceFinishedCallTest;
- (void) stopShowNotific;
//- (void) appInBackground;

@end
