//
//  iDevice.h
//  testprod
//
//  Created by Bach Ung on 12/14/14.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageBox.h"
#define MAX_NUM_CMD 10
#define TIME_REFRESH_CHECK 5
#define LINUX_LOOP_CYCLE 10
#define CAMERA_RESPONSE 5


@interface _iDevice : NSObject
{
    UIAlertView *keepAliveAlert;
    int keepAliveCount;
    
    BOOL recieveRunRequest;
    BOOL inInStartCommand;
    
    BOOL isWriteRunResult;
    BOOL isWriteGroupResult;
    
    BOOL needCheat;
    
    BOOL checkEar_BT;
    
    MessageBox *msgBox;
    NSTimer *timer;
    
    NSString *previousStr;
    NSString *cmdStrBK;

    BOOL ManualTest;
    BOOL acceptWriteInBackgroud;// khi chay duoi background van cho write
    
    unsigned int sec;
}

@property (nonatomic, strong) NSString *requestFileName;
@property (nonatomic, strong) NSString *resultFileName;
@property (nonatomic, strong) NSString *statusFileName;
@property (nonatomic, strong) NSString *logFileName;
@property (nonatomic, strong) NSString *cmdFileName;
//@property (nonatomic, strong) NSString *livingFileName;

@property (nonatomic, assign) BOOL checkEar_BT;
@property (nonatomic, assign) BOOL isForceStopAlert;//== NO is start

@property (nonatomic, assign) BOOL isTestCompass;
@property (nonatomic, assign) BOOL isTestCompassCompleted;

@property (nonatomic, assign) BOOL isLCD;
@property (nonatomic, assign) BOOL isLCDCompleted;

@property (nonatomic, assign) BOOL isMotionSensor;
@property (nonatomic, assign) BOOL isMotionSensorCompleted;

@property (nonatomic, assign) BOOL isDigitizer;
@property (nonatomic, assign) BOOL isDigitizerCompleted;

@property (nonatomic, assign) BOOL isButton;
@property (nonatomic, assign) BOOL isButtonCompleted;

@property (nonatomic, assign) BOOL isButtonEar;
@property (nonatomic, assign) BOOL isButtonEarCompleted;

@property (nonatomic, assign) BOOL isSensor;
@property (nonatomic, assign) BOOL isSensorCompleted;

@property (nonatomic, assign) BOOL isSensorCom;
@property (nonatomic, assign) BOOL isSensorComCompleted;

// use for group
@property (nonatomic, assign) BOOL isBattery;
@property (nonatomic, assign) BOOL isBatteryCompleted;

@property (nonatomic, assign) BOOL isBluetooth;
@property (nonatomic, assign) BOOL isBluetoothCompleted;

@property (nonatomic, assign) BOOL isJailbreak;
@property (nonatomic, assign) BOOL isJailbreakCompleted;

@property (nonatomic, assign) BOOL isProximity;
@property (nonatomic, assign) BOOL isProximityCompleted;

@property (nonatomic, assign) BOOL acceptWriteInBackgroud;// cho phep write result khi duoi background hay khong

- (void) setupEnvironment;
- (void) startCommand;
- (void) startCMDCall:(NSString*)key param:(NSString*)param;
- (void) completedTest:(NSString*)key isPass:(BOOL)isPassed desc:(NSString*)desc;
- (NSString *)getParameter:(NSString*)datastr with:(NSString *)Name position:(int)pos;
- (void) checkGroupStart:(NSString*)commands;
- (void) checkGroupFinished:(NSString*)commands;
-(BOOL)acceptWrite;
-(BOOL)deleteFile:(NSString *)path;
@end

_iDevice *iDevice;
