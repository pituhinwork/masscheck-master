//
//  iDevice.m
//  testprod
//
//  Created by Bach Ung on 12/16/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import <AddressBook/AddressBook.h>

#import <CoreTelephony/CoreTelephonyDefines.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import <MessageUI/MessageUI.h>
#import "MainTestViewController.h"
#import <sqlite3.h>

#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <util.h>

#include <stdio.h>

#import "Reachability.h"

#import "AppDelegate.h"

#import "iDevice.h"

#import "Utilities.h"



#define IDEVICEBUG
#if defined(IDEVICEBUG) || defined(DEBUG_ALL)
#   define IDeviceLog(BachUng, ...) NSLog((@"%s[Line %d] " BachUng), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define IDeviceLog(...)
#endif




@implementation _iDevice
@synthesize resultFileName;
@synthesize requestFileName;
@synthesize statusFileName;
@synthesize logFileName;
@synthesize cmdFileName;
//@synthesize livingFileName;


@synthesize isForceStopAlert;
@synthesize checkEar_BT;

@synthesize isTestCompass;
@synthesize isTestCompassCompleted;

@synthesize isLCD;
@synthesize isLCDCompleted;

@synthesize isMotionSensor;
@synthesize isMotionSensorCompleted;

@synthesize isDigitizer;
@synthesize isDigitizerCompleted;

@synthesize isButton;
@synthesize isButtonCompleted;

@synthesize isButtonEar;
@synthesize isButtonEarCompleted;

@synthesize isSensor;
@synthesize isSensorCompleted;

@synthesize isSensorCom;
@synthesize isSensorComCompleted;


@synthesize isBattery;
@synthesize isBatteryCompleted;

@synthesize isBluetooth;
@synthesize isBluetoothCompleted;

@synthesize isJailbreak;
@synthesize isJailbreakCompleted;

@synthesize isProximity;
@synthesize isProximityCompleted;

@synthesize acceptWriteInBackgroud;

/* ************************************************************************
    Init the pesuedo singleton iDevice
 ************************************************************************** */
- (id) init
{
    self = [super init];
    
    inInStartCommand = NO;
    keepAliveCount = 0;
    isForceStopAlert = NO;
    previousStr = @"$$$";
    cmdStrBK = @" ";
    checkEar_BT = NO;
    isWriteRunResult = NO;
    isWriteGroupResult = NO;
    msgBox = Nil;
    
    acceptWriteInBackgroud = YES;
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    requestFileName = [[NSString alloc] initWithFormat:@"%@/request.txt", [paths objectAtIndex:0]];
    resultFileName  = [[NSString alloc] initWithFormat:@"%@/result.txt", [paths objectAtIndex:0]];
    statusFileName  = [[NSString alloc] initWithFormat:@"%@/status.txt", [paths objectAtIndex:0]];
    logFileName     = [[NSString alloc] initWithFormat:@"%@/log.txt", [paths objectAtIndex:0]];
        //  livingFileName  = [[NSString alloc] initWithFormat:@"%@/living.txt", [paths objectAtIndex:0]];
    
    cmdFileName = [[NSString alloc] initWithFormat:@"%@/cmd.txt", [paths objectAtIndex:0]];
//    [paths release];
    return self;
}
/* ************************************************************************
 Setup free meomory
 ************************************************************************** */
- (void) dealloc
{
    if(msgBox)
    {
        [msgBox dismiss];
        msgBox = Nil;
    }
    
    [self deleteFile:requestFileName];
    
    [self deleteFile:resultFileName];
    
    [self deleteFile:statusFileName];
    
    [self deleteFile:logFileName];
    
    //[self deleteFile:cmdFileName];
    
        // [livingFileName release];

}

-(BOOL)acceptWrite
{
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground)
        return NO;
    return YES;
}

-(BOOL)deleteFile:(NSString *)path
{
    if([[NSFileManager defaultManager] fileExistsAtPath:path] == YES)
    {
        BOOL kq = NO;
        NSError *er = Nil;
        for(int i = 0;i < 5;i++)
        {
            //[error localizedDescription]
            [[NSFileManager defaultManager] removeItemAtPath:path error:&er];
            sleep(1);
            if([[NSFileManager defaultManager] fileExistsAtPath:path] == NO)
            {
                kq = YES;
                break;
            }
        }
        return kq;
    }
    else return YES;
}
/* ************************************************************************
    Setup the first environment to test phone
 ************************************************************************** */
- (void) setupEnvironment
{
   // [[UIApplication sharedApplication] setStatusBarHidden:AppShare.hidenStatusBar];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    
//    if([[UIScreen mainScreen] respondsToSelector:@selector(setBrightness:)])
//    {
//       // [[UIScreen mainScreen] setBrightness:1.0];
//    }
    
    if([[UIScreen mainScreen] respondsToSelector:@selector(setWantsSoftwareDimming:)])
    {
        [[UIScreen mainScreen] setWantsSoftwareDimming:YES];
    }
    
   // setDeviceVolume(1.0);
}

- (void) startKeepAliveMessage
{
//    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
//    
//    keepAliveAlert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    //[keepAliveAlert show];
//    
//    [keepAliveAlert dismissWithClickedButtonIndex:0 animated:NO];
//    [keepAliveAlert release];
//    keepAliveAlert = nil;
//    
//    keepAliveCount = 0;
//    isForceStopAlert = NO;
//    
//    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

/* ************************************************************************
    Start the LOOP to get CMD in LastName,
    the FisrtName must be "Request".
    If there is CMD, it starts command until finished it call next CMD
    else there is no CMD, if wait 5 seconds the recheck CMD, LOOP infinite
 ************************************************************************** */
- (void) startCommand
{
    
    
    if(AppShare.parentView.timeDurate >= 0)
    {
        AppShare.parentView.timeDurate++;
    }

    // Check and Cheat phone screen not permit to go asleep.
    if(keepAliveCount++ >= 50)
    {
        if(isForceStopAlert==NO)
        {
            [self startKeepAliveMessage];
        }
        else keepAliveCount = 0;
    }
    sec++;
        //[[NSString stringWithFormat:@"%d",sec] writeToFile:self.livingFileName atomically:YES encoding:NSUTF8StringEncoding error:Nil];
    // Check for next CMD
    if(!inInStartCommand)
    {
        inInStartCommand = YES;
        
        if([[NSFileManager defaultManager] fileExistsAtPath:requestFileName])
        {
            NSError *er;
            NSString *cmdStr = [NSString stringWithContentsOfFile:requestFileName encoding:NSUTF8StringEncoding error:&er];
            IDeviceLog(@"cmdStr : %@",cmdStr);
            if(cmdStr && ([cmdStr length] > 2))
            {
                cmdStrBK = [NSString stringWithFormat:@"%@",cmdStr];
                
                // Upperstring
                cmdStr = [cmdStr uppercaseString];
                // Save Backup
                previousStr = [NSString stringWithFormat:@"%@", cmdStr];
                
                cmdStr = [cmdStr stringByReplacingOccurrencesOfString:@"$" withString:@""];
                cmdStrBK = [cmdStrBK stringByReplacingOccurrencesOfString:@"$" withString:@""];
                cmdStrBK = [cmdStrBK stringByReplacingOccurrencesOfString:@"@#" withString:@""];
                NSArray *objs = [cmdStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@#"]];
                if(objs && ([objs count] >= 3))
                {
                    NSString *cmdName = [objs objectAtIndex:0];
                    NSString *cmdNote = [[objs objectAtIndex:2] uppercaseString];
                    
                    if(cmdName && ([cmdName length] >= 1) && ([cmdStr rangeOfString:previousStr].location == NSNotFound))
                    {
                        [[NSFileManager defaultManager] removeItemAtPath:requestFileName error:&er];
                        if([self deleteFile:requestFileName] == NO)
                        {
                            IDeviceLog(@"Not delete File");
                        }
                        
                        // Perform Test Action
                        [self performSelector:@selector(startCMDCall:param:) withObject:cmdName withObject:cmdNote];
                    }
                }
            }
        }
        inInStartCommand = NO;
    }
}

/* ************************************************************************
 When there a CMD detected in AddressBook,
 it calls this function to perform a test action with stsCMD and param
 ************************************************************************** */
- (void) startCMDCall:(NSString*)key param:(NSString*)param
{
    IDeviceLog(@"[%@] param [%@] executed.", key,param);
  
    acceptWriteInBackgroud = NO;
    if([key rangeOfString:@"IMMTEST"].location != NSNotFound)
    {

    }
    else if([key rangeOfString:@"WIFI"].location != NSNotFound)
    {
        // Test Wifi
        [self getAndCreateObject:@"WIFI" needCreated:YES needReleased:NO];
        AppShare.parentView.wifi.fmode = WIFI_MODE_WIFI;
//        [AppShare.viewController.wifi startAutoTest:key param:param];
    }
    
    else if([key rangeOfString:@"VIBRATION"].location != NSNotFound)
    {
        // Test Vibrate
        [self getAndCreateObject:@"VIBRATION" needCreated:YES needReleased:NO];
//        [AppShare.viewController.vibrate startAutoTest:key param:param];
    }
    else if([key rangeOfString:@"CALL"].location != NSNotFound)
    {
        // Test Call
        acceptWriteInBackgroud = YES;
        [self getAndCreateObject:@"CALL" needCreated:YES needReleased:NO];
//        [AppShare.viewController.call startAutoTest:key param:param];
    }
    else if([key rangeOfString:@"CAMERA"].location != NSNotFound)
    {
        // Test Camera

        [self getAndCreateObject:@"CAMERA" needCreated:YES needReleased:NO];
 //       [AppShare.viewController.camera startAutoTest:key param:[key stringByReplacingOccurrencesOfString:@"CAM" withString:@""]];
    }
    
    else if([key rangeOfString:@"CHECKPART"].location != NSNotFound)
    {
        // Test CheckPart
        [self getAndCreateObject:@"CHECKPART" needCreated:YES needReleased:NO];
 //       [AppShare.viewController.checkPart startAutoTest:key param:param];
    }
    else if([key rangeOfString:@"GPS"].location != NSNotFound)
    {
        // Test GPS
        [self getAndCreateObject:@"GPS" needCreated:YES needReleased:NO];
//        [AppShare.viewController.gps startAutoTest:key param:param];
    }
    
    else if([key rangeOfString:@"RUN"].location != NSNotFound || [key rangeOfString:@"MANUALTEST"].location != NSNotFound)
    {
         acceptWriteInBackgroud = YES;
        ManualTest = NO;
        isWriteRunResult = NO;
        AppShare.isHandTest = YES;// se cap nhap lai trong ham iDevice completedPreTestCall
        // Test Run
        if([key rangeOfString:@"MANUALTEST"].location != NSNotFound)
        {
            ManualTest = YES;
#ifdef AUTO_BRI_NESS
            //setDeviceVolume(1.0);//0.5
            [[UIScreen mainScreen] setBrightness:1.0];
#endif
        }
        if([key rangeOfString:@"FASTMODE"].location != NSNotFound)
        {
            IDeviceLog(@" Run : FASTMODE");
            AppShare.fastMode = YES;
        }
        else
        {
            AppShare.fastMode = NO;
        }
       
    
    }
    else if([key rangeOfString:@"RESET"].location != NSNotFound)
    {
        // Test Version
        setDeviceVolume(1.0);//0.5
#ifdef AUTO_BRI_NESS
        [[UIScreen mainScreen] setBrightness:1.0];
#endif
//        [iDevice completedTest:key isPass:YES desc:@"PASSED"];
    }
    else if([key rangeOfString:@"GROUPCHECK"].location != NSNotFound)
    {
//        [self checkGroupStart:param];
    }
    else if([key rangeOfString:@"RECORDBACK"].location != NSNotFound)
    {
        [self getAndCreateObject:@"RECORDBACK" needCreated:YES needReleased:NO];
//        [AppShare.viewController.recordBack startAutoTest:key param:param];

    }
    
    else if([key rangeOfString:@"TOUCHSCREEN"].location != NSNotFound)
    {
        [self getAndCreateObject:@"TOUCHSCREEN" needCreated:YES needReleased:NO];
//        [AppShare.viewController.touchScreen startAutoTest:key param:param];
        
    }
    else if([key rangeOfString:@"TOUCHID"].location != NSNotFound)
    {
        [self getAndCreateObject:@"TOUCHID" needCreated:YES needReleased:NO];
 //       [AppShare.viewController.touchID startAutoTest:key param:param];
        
    }
    
    
    else if([key rangeOfString:@"BTFUNC"].location != NSNotFound)
    {
        [self getAndCreateObject:@"BTFUNC" needCreated:YES needReleased:NO];
 //       [AppShare.viewController.buttonFunc startAutoTest:key param:param];
    }
    else if([key rangeOfString:@"BLUETOOTH"].location != NSNotFound)
    {
        IDeviceLog(@"key [%@] vao if", key);
        [self getAndCreateObject:@"BATTERY" needCreated:YES needReleased:NO];
//        [AppShare.viewController.bluetooth startAutoTest:key param:param];
    }
    else if([key rangeOfString:@"APPEARANCE"].location != NSNotFound)
    {
        IDeviceLog(@"key [%@] vao if", key);
        [self getAndCreateObject:@"APPEARANCE" needCreated:YES needReleased:NO];
  //      [AppShare.viewController.appearance startAutoTest:key param:param];
    }


}
/* ************************************************************************
 When App get command Groupcheck, it need all conmand to test
 This function start to anlysis those commands
 method uer: battery, Bluetooth, Jailbreak
 
 ************************************************************************** */
- (void) checkGroupStart:(NSString*)commands
{
    commands = [commands uppercaseString];
    isWriteGroupResult = YES;
    isBatteryCompleted = YES;
    isBluetoothCompleted = YES;
    isJailbreakCompleted = YES;
    
    isBattery = NO;
    isBluetooth = NO;
    isJailbreak = NO;
    
   
    if([commands rangeOfString:@"BLUETOOTH"].location != NSNotFound)
    {
        isBluetoothCompleted = NO;
        isBluetooth = YES;
    }
    if([commands rangeOfString:@"JAILBREAK"].location != NSNotFound)
    {
        isJailbreakCompleted = NO;
        isJailbreak = YES;
    }
    
    //KHONG DE VAO HAM IF O TREN TRANH TRUONG HOP METHOD WA NHANH SE GUI VE TRUOC
    
}
/* ************************************************************************
 When function finish will call this fuonction
 This function start to check group to finish
 ************************************************************************** */
- (void) checkGroupFinished:(NSString*)commands
{
    NSString *resultGroup = @"";
    if(isWriteGroupResult != YES)// DUNG DE TRANH TRUONG HOP GHI RESULT KHI KHONG PHAI CHAY GROUP 
        return;
    commands = [commands uppercaseString];
    if([commands rangeOfString:@"BATTERY"].location != NSNotFound)
    {
        isBatteryCompleted = YES;
    }
    if([commands rangeOfString:@"BLUETOOTH"].location != NSNotFound)
    {
        isBluetoothCompleted = YES;
    }
    if([commands rangeOfString:@"JAILBREAK"].location != NSNotFound)
    {
        isJailbreakCompleted = YES;
    }

}

- (void) onMessage:(NSNumber*)num
{

    if (timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
}
- (void) checkHeadphone
{
    IDeviceLog(@"checkHeadphone call");
    if(isHeadphonePlugged())
    {
        if (timer != nil)
        {
            [timer invalidate];
            timer = nil;
        }
        [msgBox onClickNoSound];
    }
}


- (NSString *)getParameter:(NSString*)datastr with:(NSString *)Name position:(int)pos 
{
    NSArray *objs = [datastr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
    NSString *datatemp = @"";
    for(int i=0; i< [objs count];i++)
    {
        if([[[objs objectAtIndex:i] uppercaseString] rangeOfString:[Name uppercaseString]].location != NSNotFound)
        {
            datatemp = [NSString stringWithFormat:@"%@",[objs objectAtIndex:i]];
            datatemp = [datatemp stringByReplacingOccurrencesOfString:@"@#" withString:@""];
            NSArray *objs1 = [datatemp componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
            if(objs1 && ([objs1 count] > pos && pos > 0))
            {
                IDeviceLog(@" getParameter %@",[objs1 objectAtIndex:pos]);
                return [objs1 objectAtIndex:pos];
            }
        }
    }
    
    return @"";
}

#define SHOW /*ABC*/
#define ELSE else

#define AUTORELEASEORCREATE(objStr, objName, objCore) \
if ([byName isEqualToString:objStr])\
{\
    if(needRelease)\
    {\
        if(AppShare.viewController.objName)\
        {\
            IDeviceLog(@"Release object name : %@", objStr);\
            [AppShare.viewController.objName release];\
            AppShare.viewController.objName = nil;\
        }\
    }\
    \
    if(needCreated)\
    {\
        if(!AppShare.viewController.objName)\
        {\
            IDeviceLog(@"Create object name : %@", objStr);\
            AppShare.viewController.objName = [[objCore alloc] init];\
        }\
    }\
    \
}\

- (void) getAndCreateObject:(NSString*)byName needCreated:(BOOL)needCreated needReleased:(BOOL)needRelease
{
    return;
    
//    SHOW AUTORELEASEORCREATE(@"WIFI", wifi, Wifi)
//    ELSE AUTORELEASEORCREATE(@"SIM_DETECTION", simDetection, SIMDetection)
//    ELSE AUTORELEASEORCREATE(@"VIBRATION", vibrate, Vibrate)
//    ELSE AUTORELEASEORCREATE(@"CALL", call, Call)
//    ELSE AUTORELEASEORCREATE(@"3G/4G", sim3G, SIM3G)
//    ELSE AUTORELEASEORCREATE(@"BATTERY", battery, Battery)
//    ELSE AUTORELEASEORCREATE(@"CHARGE", charge, Charge)
//    ELSE AUTORELEASEORCREATE(@"COMPASS", compass, Compass)
//    ELSE AUTORELEASEORCREATE(@"BLUETOOTH", bluetooth, Bluetooth)
//    ELSE AUTORELEASEORCREATE(@"RINGTONE", ringTone, RingTone)
//    ELSE AUTORELEASEORCREATE(@"RINGTONENAME", ringtoneName, RingtoneName)
//    ELSE AUTORELEASEORCREATE(@"DIGITIZER", digitizer, Digitizer)
//    ELSE AUTORELEASEORCREATE(@"DATETIME", dateTime, DateTime)
//    ELSE AUTORELEASEORCREATE(@"MICROPHONE", microphone, Microphone)
//    ELSE AUTORELEASEORCREATE(@"SPEAKER", play, Play)
//    ELSE AUTORELEASEORCREATE(@"EARPHONE", earphone, Earphone)
//    ELSE AUTORELEASEORCREATE(@"HEADPHONE", play, Play)
//    ELSE AUTORELEASEORCREATE(@"HEADPHONELEFT", play, Play)
//    ELSE AUTORELEASEORCREATE(@"HEADPHONERIGHT", play, Play)
//    ELSE AUTORELEASEORCREATE(@"MICROHEADPHONE", microphone, Microphone)
//    ELSE AUTORELEASEORCREATE(@"PLAY", play, Play)
//    ELSE AUTORELEASEORCREATE(@"VIDEORECORD", videoRecord, VideoRecord)
//    ELSE AUTORELEASEORCREATE(@"PROXIMITYSENSOR", sensor, Sensor)
//    ELSE AUTORELEASEORCREATE(@"FLASH1", flash, Flash)
//    ELSE AUTORELEASEORCREATE(@"FLASH2", flash, Flash)
//    ELSE AUTORELEASEORCREATE(@"USB", usb, USB)
//    ELSE AUTORELEASEORCREATE(@"JAILBREAK", jailbreak, Jailbreak)
//    ELSE AUTORELEASEORCREATE(@"CHECKPART", checkPart, CheckPart)
//    ELSE AUTORELEASEORCREATE(@"MOTIONSENSOR", motionSensor, MotionSensor)
//    ELSE AUTORELEASEORCREATE(@"GPS", gps, GPS)
//    ELSE AUTORELEASEORCREATE(@"LCD", lcd, LCD)
//    ELSE AUTORELEASEORCREATE(@"BUTTON", button, Button)
//    ELSE AUTORELEASEORCREATE(@"CAMERA", camera, Camera)
//    ELSE AUTORELEASEORCREATE(@"BT_EAR", buttonEar, ButtonEar)
//    ELSE AUTORELEASEORCREATE(@"RECORDBACK", recordBack, RecordBack)
//    ELSE AUTORELEASEORCREATE(@"ENGRAVING", engrave, Engrave)
//    ELSE AUTORELEASEORCREATE(@"COSMETIC", costmetic, Costmetic)
//    ELSE AUTORELEASEORCREATE(@"HPHONE", headphone, Headphone)
//    ELSE AUTORELEASEORCREATE(@"BROKEN", broken, Broken)
//    ELSE AUTORELEASEORCREATE(@"TOUCHSCREEN", touchScreen, TouchScreen)
//    ELSE AUTORELEASEORCREATE(@"TOUCHID", touchID, TouchID)
//    ELSE AUTORELEASEORCREATE(@"CAPTURE", captures, Capture)
//    ELSE AUTORELEASEORCREATE(@"DIMMING", dimming, Dimming)
//    ELSE AUTORELEASEORCREATE(@"MULTITOUCH", multiTouch, MultiTouch)
//    ELSE AUTORELEASEORCREATE(@"3DTOUCH", t3DTouch, T3DTouch)
//    ELSE AUTORELEASEORCREATE(@"COSGRADE", cosGrade, CosGrade)
//    ELSE AUTORELEASEORCREATE(@"LIGHTSENSOR", lightSensor, LightSensor)
//    ELSE AUTORELEASEORCREATE(@"POWERCHECK", powerView, PowerView)
//    ELSE AUTORELEASEORCREATE(@"COSFACE", cosFace, CosFace)
//    ELSE AUTORELEASEORCREATE(@"SMSSENDING", SMSSend, MessageTest)
//    ELSE AUTORELEASEORCREATE(@"BARCODE", barcode, Barcode)
//    ELSE AUTORELEASEORCREATE(@"HJACK", headphoneJack, HeadphoneJack)
//    ELSE AUTORELEASEORCREATE(@"WFSTREAM", wifiStream, WIFIStream)
//    ELSE AUTORELEASEORCREATE(@"CHECKOPENWF", wifiCheck , WIFICheck)
}

/* ************************************************************************
    The Test Function Completed, this one must be call this completedTest
    the completedTest acts as a Result writer and write into AddressBook,
    then it call the next CMD.
 ************************************************************************** */
- (void) completedTest:(NSString*)key isPass:(BOOL)isPassed desc:(NSString*)desc
{
    
}


- (void) checkandtestcheat:(NSString*)key
{
    return;
}

#define STARTCMD /**/
#define OTHERCMD else
#define NEXTCMD(A, B) \
if([cmpCmd isEqualToString:A])\
{\
    cmdTxt = B;\
}

static BOOL cma = NO;
- (void) completedCheatNextStep:(NSString*)cmpCmd
{
    IDeviceLog(@"======= completedCheatNextStep : %@", cmpCmd);
    return;
    NSString *cmdTxt = @"NULL";
    
    STARTCMD NEXTCMD(@"PROXIMITYSENSOR", @"VIBRATION")
    OTHERCMD NEXTCMD(@"VIBRATION", @"EARPHONE")
    OTHERCMD NEXTCMD(@"EARPHONE", @"HEADPHONE")
    OTHERCMD NEXTCMD(@"HEADPHONE", @"DIGITIZER")
    OTHERCMD NEXTCMD(@"DIGITIZER", @"LCD")
    OTHERCMD NEXTCMD(@"LCD", @"GPS")
    OTHERCMD NEXTCMD(@"GPS", @"MOTIONSENSOR")
    OTHERCMD NEXTCMD(@"MOTIONSENSOR", @"CAMERA")
    
    if((!cma) && [cmpCmd isEqualToString:@"CAMERA"])
    {
        cma = YES;
        STARTCMD NEXTCMD(@"CAMERA", @"CAM1")
    }
    
    STARTCMD NEXTCMD(@"CAM1", @"CAM2")
    OTHERCMD NEXTCMD(@"CAM2", @"CAM3")
    OTHERCMD NEXTCMD(@"CAM3", @"CAM4")
    OTHERCMD NEXTCMD(@"CAM4", @"CAM5")
    OTHERCMD NEXTCMD(@"CAM5", @"CAM6")
    OTHERCMD NEXTCMD(@"CAMERA", @"DATETIME")
    OTHERCMD NEXTCMD(@"DATETIME", @"SIM_DETECTION")
    OTHERCMD NEXTCMD(@"SIM_DETECTION", @"WIFI")
    OTHERCMD NEXTCMD(@"WIFI", @"COMPASS")
    OTHERCMD NEXTCMD(@"COMPASS", @"MICROPHONE")
    OTHERCMD NEXTCMD(@"MICROPHONE", @"SPEAKER")
    OTHERCMD NEXTCMD(@"SPEAKER", @"3G")
    OTHERCMD NEXTCMD(@"3G", @"FLASH1")
    OTHERCMD NEXTCMD(@"FLASH1", @"FLASH2")
    OTHERCMD NEXTCMD(@"FLASH2", @"VIDEORECORD")
    OTHERCMD NEXTCMD(@"VIDEORECORD", @"JAILBREAK")
    OTHERCMD NEXTCMD(@"JAILBREAK", @"BATTERY")
    OTHERCMD NEXTCMD(@"BATTERY", @"BLUETOOTH")
    OTHERCMD NEXTCMD(@"BLUETOOTH", @"CHECKPART")
    OTHERCMD NEXTCMD(@"CHECKPART", @"CALL")
    OTHERCMD NEXTCMD(@"CALL", @"RINGTONE")
    OTHERCMD NEXTCMD(@"RINGTONE", @"CHARGE")
    OTHERCMD NEXTCMD(@"CHARGE", @"RECORDBACK")
    OTHERCMD NEXTCMD(@"RECORDBACK", @"HPHONE")
    OTHERCMD NEXTCMD(@"HPHONE", @"COSTMETIC")
    OTHERCMD NEXTCMD(@"COSTMETIC", @"BROKEN")
    OTHERCMD NEXTCMD(@"BROKEN", @"TOUCHSCREEN")
    OTHERCMD NEXTCMD(@"TOUCHSCREEN", @"ENGRAVING")
    OTHERCMD NEXTCMD(@"ENGRAVING", @"TOUCHID")
    OTHERCMD NEXTCMD(@"TOUCHID", @"SMSSENDING")
    OTHERCMD NEXTCMD(@"SMSSENDING", @"BARCODE")
    OTHERCMD NEXTCMD(@"BARCODE", @"HJACK")
    OTHERCMD NEXTCMD(@"HJACK", @" ")
    
    [[NSString stringWithFormat:@"$%@@#", cmdTxt] writeToFile:iDevice.requestFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
