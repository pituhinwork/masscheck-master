//  VuNguyen510
//  Wifi.h
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageBox.h"
#define WIFI_MODE_WIFI 2

@class MainTestViewController;
@interface Wifi : NSObject
{
    int count;
    int status;
    int callRecieve;
    int countAP;
    BOOL isConnectedAP;
    int ID;
    BOOL gotActive;
    BOOL isAskFromLinux;
    
    UIWebView *wv;
    MessageBox *msgBox;
    NSTimer *timer;
    int timeleft;
    
    BOOL kqOPEN;
    BOOL kqconnectAcceptPoin;
    BOOL kqConnectInternet;
    
    double timeConnec;// use get time ping
}

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *resultDesc;
@property (nonatomic, assign) BOOL result;
@property (nonatomic, assign) int fmode;
@property (nonatomic, assign) int ID;
@property (nonatomic, assign) BOOL manual;
@property (nonatomic, strong) MainTestViewController *parentView;

- (void) successCheck:(NSString*)desc;
- (void) failedCheck:(NSString*)desc;
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param;
- (void) preTest;

// Addiction Function

@end
