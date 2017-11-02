

//
//  Bluetooth.m
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTestViewController.h"

#import "iDevice.h"
#import "Bluetooth.h"

#import "Utilities.h"

#define BLUETOOTH_KEYNAME @"AI_ITEST"

#define BLUETOOTHBUG
#if defined(BLUETOOTHBUG) || defined(DEBUG_ALL)
#   define BluetoothLog(LichDuyet, ...) NSLog((@"%s[Line %d] " LichDuyet), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define BluetoothLog(...)
#endif

@implementation Bluetooth
@synthesize key;
@synthesize ID;
@synthesize btManager;
@synthesize isPassed;
@synthesize manual;
- (id) init
{
    self = [super init];
    key = @"Bluetooth";
    isPassed = YES;
    isAskFromLinux = NO;
    peerKeyID = Nil;
    status = BLUETOOTH_NONE;
    ID = -1;
    manual = NO;
    msgBox = Nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDiscovered:) name:@"BluetoothDeviceDiscoveredNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothAvailabilityChanged:) name:@"BluetoothAvailabilityChangedNotification" object:nil];
    
//    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(),NULL, MyCallBack, NULL, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    
    return self;
}
//void MyCallBack (CFNotificationCenterRef center,void *observer,CFStringRef name,const void *object,CFDictionaryRef userInfo)
//{
////    BluetoothLog(@"%s Name:%@ Data:%@",__FUNCTION__, name, userInfo);
//}

- (void)bluetoothAvailabilityChanged:(NSNotification *)notification
{
    BluetoothLog(@" called. BT Enable: %d , powered: %d", [btManager enabled],[btManager powered]);
}
- (void)deviceDiscovered:(NSNotification *) notification {
    
    BluetoothDeviceHandler *bt = [notification object];
    
    BluetoothLog(@"name:%@ address:%@ get list____________________________________%@",bt.name, bt.address,[notification mutableCopy]);

}

- (void) dealloc
{
    BluetoothLog();
}


- (void) failedCheck:(NSString*)desc
{
    if((status != BLUETOOTH_FINISHED) && (status != BLUETOOTH_CLOSED))
    {
        BluetoothLog();
        [self performSelector:@selector(releaseResource) withObject:nil afterDelay:1];
        isPassed = NO;
        status = BLUETOOTH_FINISHED;
        msg = [[NSString alloc] initWithFormat:@"%@", desc];
        [self performSelector:@selector(completedDelay) withObject:nil afterDelay:2];
    }
}

- (void) successCheck:(NSString*)desc
{
    if((status != BLUETOOTH_FINISHED) && (status != BLUETOOTH_CLOSED))
    {
        BluetoothLog();
        [self performSelector:@selector(releaseResource) withObject:nil afterDelay:1];
        isPassed = YES;
        status = BLUETOOTH_FINISHED;
        msg = [[NSString alloc] initWithFormat:@"%@", desc];
        [self performSelector:@selector(completedDelay) withObject:nil afterDelay:2];
       
    }
}
- (void) writeValue
{
//    [iDevice checkGroupFinished:key];
}


- (void) completedDelay
{
    BluetoothLog();
    [self writeValue];
    
    if((status == BLUETOOTH_CLOSED || status == BLUETOOTH_FINISHED) && isAskFromLinux == YES)
    {
        [AppShare.parentView updateResult:ID value:[NSString stringWithFormat:@"%@#%@#%@",key,isPassed?@"PASSED":@"FAILED",msg]];
    }
}

- (void) releaseResource
{
    BluetoothLog();
    if(status != BLUETOOTH_CLOSED)
    {
        if(status != BLUETOOTH_FINISHED)
            status = BLUETOOTH_CLOSED;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
      // CFNotificationCenterRemoveObserver ( CFNotificationCenterGetLocalCenter(), NULL, NULL, NULL);
        if(cm)
        {
            cm = nil;
        }
        if(gkSession)
        {
            gkSession = nil;
        }
        
        if(peerKeyID)
        {
            peerKeyID = nil;
        }
        
        if(reloop && [reloop isValid])
        {
            [reloop invalidate];
        }
        
        if(pick22)
        {
            [self setBluetoothStatus:NO];
            if([pick22 isVisible])
            {
                [pick22 dismiss];
            }
            
//            pick22.delegate = Nil;
//            [pick22 release];
//             pick22 = nil;
        }
        if(msgBox)
        {
            [msgBox dismiss];
            msgBox = Nil;
        }

    }
}

- (void) setBluetoothStatus:(BOOL)pwr
{

    BluetoothLog("start");
    if(btManager)
    {
        BluetoothLog(@" %@",pwr?@"YES":@"NO");
        [btManager setEnabled:pwr];
        [btManager setPower:pwr];
    }
}

// This function is started when Master Linux request
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param
{
    BluetoothLog();
    // Code implementated hereby.
    status = BLUETOOTH_NONE;
    isAskFromLinux = YES;
    if((status != BLUETOOTH_FINISHED) && (status != BLUETOOTH_CLOSED))
        [self preTest];
    else [self performSelector:@selector(completedDelay) withObject:nil afterDelay:0];//[iDevice completedTest:key isPass:isPassed desc:msg];

}

- (void) preTest
{
    BluetoothLog();
    if(status == BLUETOOTH_NONE)
    {
        
        if(manual == YES)
        {
            key = @"BluetoothManual";
            if(msgBox)
            {
                [msgBox dismiss];
                msgBox = Nil;
            }

            msgBox = [[MessageBox alloc] init];
            
            NSMutableArray * buttons = [[NSMutableArray alloc] init];
            [buttons addObject:@"Failed"];
            [buttons addObject:@"Passed"];

        }
        else
        {
            peerKeyID = [[NSString alloc] initWithFormat:@"%@", BLUETOOTH_KEYNAME];
            callCount++;
            count = 0;
            status = BLUETOOTH_STARTED;
            btManager = [BluetoothManagerHandler sharedInstance];
            statusBegin = YES;
            
            int delay = 1;
            if(btManager)
            {
                if(!btManager.powered)
                {
                    delay = 5;
                    statusBegin = NO;
                   
                    [self setBluetoothStatus:YES];
                }
                
                [self performSelector:@selector(checkPower) withObject:nil afterDelay:delay];
                [self performSelector:@selector(exitTest) withObject:nil afterDelay:300];
                
                [self startBluetoothStatusMonitoring];
                [self performSelector:@selector(onTimeOut:) withObject:[NSNumber numberWithInt:callCount] afterDelay:20];
            }
            else
            {
                BluetoothLog(@"get sharedInstance Failed");
                if(msgBox)
                {
                    [msgBox dismiss];
                    msgBox = Nil;
                }
                
                msgBox = [[MessageBox alloc] init];
                NSMutableArray * buttons = [[NSMutableArray alloc] init];
                [buttons addObject:@"Failed"];
                [buttons addObject:@"Passed"];
            }
        }
    }
}
- (void) onMessage:(NSNumber*)num
{
    status = BLUETOOTH_NONE;
    int tag = [num integerValue];
    switch (tag) {
        case 101:
            [self failedCheck:@"Manual"];
            break;
        case 102:
            [self successCheck:@"Manual"];
            break;
        default:
            [self preTest];
            break;
    }
}

- (void) exitTest
{
    BluetoothLog();
    if(status != BLUETOOTH_FINISHED && status != BLUETOOTH_CLOSED)
    {
        isPassed = NO;
        status = BLUETOOTH_CLOSED;
        [self writeValue];
        [iDevice completedTest:key isPass:isPassed desc:@"Time out exit"];
        [self performSelector:@selector(completedDelay)];
    }
    [self releaseResource];
}
- (void) onTimeOut:(NSNumber*)num
{
    BluetoothLog();
    BluetoothLog(@"================== Timeout");
    
    if([num intValue] == callCount)
    {
        if((status != BLUETOOTH_FINISHED) && (status != BLUETOOTH_CLOSED) && (status != BLUETOOTH_ACCEPTED))
        {
            [self failedCheck:@"Time out"];
        }
    
    }
    
}

//void setup()
//{
//    BluetoothDeviceAddress *addr;
//    
//    string s = "00-16-a4-00-72-3d"; // hardcoded BT address
//    CFStringRef str_addr;
//    str_addr = CFStringCreateWithCString(kCFAllocatorDefault, s.c_str(), kCFStringEncodingMacRoman);
//    
//    IOBluetoothCFStringToDeviceAddress(str_addr, addr);
//    IOBluetoothDeviceRef dev = IOBluetoothDeviceCreateWithAddress(addr);
//    IOBluetoothDeviceOpenConnection(dev, &bluetoothCreateConnection_c, NULL);
//    
//    printf("in openRFCOMMChannel\n");
//    CFArrayRef device_services = IOBluetoothDeviceGetServices(dev);
//    printf("Getting SDP service record\n");
//    IOBluetoothSDPServiceRecordRef service_record = (IOBluetoothSDPServiceRecordRef) CFArrayGetValueAtIndex(device_services, 0);
//    UInt8 channel_id;
//    IOBluetoothRFCOMMChannelRef channel_ref;
//    printf("Finding channel ID\n");
//    IOBluetoothSDPServiceRecordGetRFCOMMChannelID(service_record, &channel_id);
//    // Open channel and listen for RFCOMM data
//    IOBluetoothDeviceOpenRFCOMMChannelAsync(dev, &channel_ref, channel_id, &rfcommEventListener_c, NULL);
//}
- (BOOL) BluetoothStatus
{
    return [btManager powered];
}
- (void) checkPower
{
    BluetoothLog();
    if(status != BLUETOOTH_FINISHED)
    {
        if([btManager powered])
        {
//            [self showPeerConnection];
            BluetoothLog(@"passed");
            [self successCheck:@"PASSED"];
        }
        else
        {
            count++;
            if(count > 5)
            {
                [self failedCheck:@"Device broken"];
            }
            else
            {
                [self setBluetoothStatus:YES];
                [self performSelector:@selector(checkPower) withObject:nil afterDelay:2];
            }
        }
    }
}
- (void) refreshBluetooth
{
    if((status != BLUETOOTH_FINISHED) && (status != BLUETOOTH_CLOSED))
    {
        BluetoothLog();
        if(pick22)
        {
            if([pick22 isVisible])
            {
                [pick22 dismiss];
            }
            
            if(pick22)
            {
                pick22 = nil;
            }
        }
        
        [self showPeerConnection];
    }
}

- (void) showPeerConnection
{
    BluetoothLog();
    pick22 = [[GKPeerPickerController alloc] init];
    pick22.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    
    pick22.delegate = self;
    [pick22 show];
}

#pragma mark -
#pragma mark peerPickerController delegate
- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type
{
    BluetoothLog();
}
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    BluetoothLog();
}
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    BluetoothLog();
}
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    BluetoothLog(@" session.peerID:%@ peer:%@",session.peerID, peer);
    BluetoothLog(@"%@",[session displayNameForPeer:peer]);
    //    if([[session displayNameForPeer:peer] rangeOfString:[NSString stringWithFormat:@"%@_Bottom", peerKeyID]].location != NSNotFound)
    //    {
    [self successCheck:@"PASSED"];
    //    }
    
    
    //    NSString *str = [[NSString alloc]initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    ////     NSString *str = [[NSString alloc]init];
    ////    str = [NSString stringWithUTF8String:[data bytes]];
    //    NSLog(@"[BLUETOOTH] recieve data : %@", str);
    //    [str release];
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    BluetoothLog(@" peerKeyID :%@",peerKeyID);
    if(!gkSession)
    {
        BluetoothLog(@" gkSession!=Nil, peerKeyID :%@",peerKeyID);
        NSString *str = [[NSString alloc] initWithFormat:@"%@_DUT", peerKeyID];

        gkSession = [[GKSession alloc] initWithSessionID:peerKeyID displayName:str sessionMode:GKSessionModePeer];
        gkSession.delegate = self;

    }
    
    return gkSession;
}

#pragma mark -
#pragma mark GKSession delegate
- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
    BluetoothLog(@"session.peerID: %@, peerID:%@, error: %@",session.peerID,peerID, [error description]);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
    [self failedCheck:[error description]];
    BluetoothLog(@" session.peerID: %@:error: %@",session.peerID, [error description]);
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    BluetoothLog(@"session.peerID :%@, peerID: %@, state : %d, %@", session.peerID, peerID, state, [session displayNameForPeer:peerID]);
    BluetoothLog(@"%@",[session displayNameForPeer:peerID]);
    
    //    if([[session displayNameForPeer:peerID] rangeOfString:[NSString stringWithFormat:@"%@_Bottom", peerKeyID]].location != NSNotFound)
    //    {
    [self successCheck:@"PASSED"];
    //    }
    
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
    BluetoothLog(@"session.peerID:%@ peerID:%@",session.peerID, peerID);
    BluetoothLog(@"%@",[session displayNameForPeer:peerID]);
    //    if([[session displayNameForPeer:peerID] rangeOfString:[NSString stringWithFormat:@"%@_Bottom", peerKeyID]].location != NSNotFound)
    //    {
    [self successCheck:@"PASSED"];
    //    }
    
}

#pragma mark -
#pragma mark centralManager delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)manager
{
    BluetoothLog();
    //this is what gets logged when I run it on an iPhone 5
    if ([manager state] == CBCentralManagerStatePoweredOff) BluetoothLog(@"CBCentralManagerStatePoweredOff");
    if ([manager state] == CBCentralManagerStatePoweredOn)
    {
        BluetoothLog(@"CBCentralManagerStatePoweredOn");
//        CBUUID *myUUID = [CBUUID UUIDWithString:BLUETOOTH_KEYNAME];
//        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
//        [cm scanForPeripheralsWithServices:[NSArray arrayWithObject:myUUID] options:options];
        [self successCheck:@"PASSED"];

    }
    if ([manager state] == CBCentralManagerStateResetting) BluetoothLog(@"CBCentralManagerStateResetting");
    if ([manager state] == CBCentralManagerStateUnauthorized) BluetoothLog(@"CBCentralManagerStateUnauthorized");
    if ([manager state] == CBCentralManagerStateUnknown) BluetoothLog(@"CBCentralManagerStateUnknown");
    if ([manager state] == CBCentralManagerStateUnsupported) BluetoothLog(@"CBCentralManagerStateUnsupported");
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
//    BluetoothLog();
//    BluetoothLog(@"Did discover peripheral. peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.UUID, advertisementData);
//    [cm retrievePeripherals:[NSArray arrayWithObject:(id)peripheral.UUID]];
}
- (void) centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    
//    BluetoothLog(@"Currently known peripherals :");
//    int i = 0;
//    for(CBPeripheral *peripheral in peripherals) {
//        BluetoothLog(@"[%d] - peripheral : %@ with UUID : %@",i,peripheral,peripheral.UUID);
//        
//    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [cm scanForPeripheralsWithServices:nil options:options];
    
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    BluetoothLog();
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
{
    BluetoothLog();
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
   BluetoothLog();
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    BluetoothLog();
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    BluetoothLog();
}


- (void)startBluetoothStatusMonitoring {
    // Horrible formatting, but nicer for blog-width!
    float ios = [AppShare.parentView getIOS];
    BluetoothLog(@" ios: %.1f",ios);
    if(ios < 7) return;

    cm = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()
                                            options:@{CBCentralManagerOptionShowPowerAlertKey: @(NO)}];

}



@end
