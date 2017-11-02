//
//  Bluetooth.h
//  testprod

//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import <GameKit/GameKit.h>

#import "BluetoothDeviceHandler.h"
#import "BluetoothManagerHandler.h"

#define BLUETOOTH_NONE 0
#define BLUETOOTH_INIT 1
#define BLUETOOTH_STARTED 2
#define BLUETOOTH_POWERON 3
#define BLUETOOTH_CONNECTING 4
#define BLUETOOTH_FINISHED 5
#define BLUETOOTH_CLOSED 6
#define BLUETOOTH_ACCEPTED 7
@class MainTestViewController;
@interface Bluetooth : NSObject <GKPeerPickerControllerDelegate, GKSessionDelegate, CBCentralManagerDelegate,CBPeripheralDelegate>
{
    int ID;
    int status;
    int count;
    int callCount;
    BOOL isAskFromLinux;
    GKPeerPickerController *pick22;
    GKSession *gkSession;
    
    BOOL isPassed;
    NSTimer *reloop;
    
    
    BOOL statusBegin;
    NSString *msg;
    NSString *peerKeyID;
    CBCentralManager *cm;
    MessageBox *msgBox;
}

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) BluetoothManagerHandler *btManager;
@property (nonatomic, assign) BOOL isPassed;
@property (nonatomic, assign) int ID;
@property (nonatomic, strong) MainTestViewController *parentView;

@property (nonatomic, assign) BOOL manual;

- (void) successCheck:(NSString*)desc;
- (void) failedCheck:(NSString*)desc;
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param;
- (void) exitTest;
- (BOOL) BluetoothStatus;
// Additional functions
- (void) preTest;

@end
