//
//  Telephone.m
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import "iDevice.h"
#import "AppDelegate.h"
#import "Telephone.h"
#import "MainTestViewController.h"

#define TELEPHONEBUG
#if defined(TELEPHONEBUG) || defined(DEBUG_ALL)
#   define TelephoneLog(BachUng, ...) NSLog((@"%s[Line %d] " BachUng), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define TelephoneLog(...)
#endif


#define CALL_ZERO 0
#define CALL_START 1
#define CALL_ENDED 2

@implementation Telephone
@synthesize call;
//@synthesize callCenter;

static void CALL_CallBack(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
//    TelephoneLog(@"CALL_CallBack : %@, %@", (NSString*)name, [(NSDictionary *)userInfo description]);
    
    NSDictionary *callDic = (__bridge NSDictionary*)userInfo;
    NSString *eventName = (__bridge NSString *)name;
    
    if ([eventName isEqualToString:@"kCTCallStatusChangeNotification"])
    {
        CTCall *call = (CTCall *)[callDic objectForKey:@"kCTCall"];
        
        int status = -1;
        NSString *stVal = [callDic objectForKey:@"kCTCallStatus"];
        if(stVal)
        {
            status = [stVal intValue];
        }
        
        // Hook Function callback
        if(AppShare.parentView.call)
        {
            [AppShare.parentView.call performSelector:@selector(callNotify:status:) withObject:call withObject:[NSNumber numberWithInt:status]];
        }
        
    }
}

static void SIM_CallBack(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
//    TelephoneLog(@" SIM_CallBack : %@, %@", (NSString*)name, [(NSDictionary *)userInfo description]);
    
    NSDictionary *callDic = (__bridge NSDictionary*)userInfo;
    NSString *eventName = (__bridge NSString *)name;
    
    if([eventName isEqualToString:@"kCTSIMSupportSIMStatusChangeNotification"])
    {
        NSString *str = [callDic objectForKey:@"kCTSIMSupportSIMStatus"];
        
    }
}

static void REQUEST_CallBack(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    
    NSDictionary *callDic = (__bridge NSDictionary*)userInfo;
    NSString *eventName = (__bridge NSString *)name;
    
    if ([eventName isEqualToString:@"kCTUSSDSessionStringNotification"])
    {
    }
}

- (id) init
{
    self = [super init];
    
    CTTelephonyCenterAddObserver(CTTelephonyCenterGetDefault(), NULL, &SIM_CallBack, CFSTR("kCTSIMSupportSIMStatusChangeNotification"), NULL, CFNotificationSuspensionBehaviorHold);
    CTTelephonyCenterAddObserver(CTTelephonyCenterGetDefault(), NULL, &CALL_CallBack, CFSTR("kCTCallStatusChangeNotification"), NULL, CFNotificationSuspensionBehaviorHold);
    CTTelephonyCenterAddObserver(CTTelephonyCenterGetDefault(), NULL, &REQUEST_CallBack, CFSTR("kCTUSSDSessionStringNotification"), NULL, CFNotificationSuspensionBehaviorHold);
    AppShare = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //CFNotificationCenterRemoveObserver ( CFNotificationCenterGetLocalCenter(), NULL, NULL, NULL);
    return self;
}

- (void) callWithnumber:(NSString *)number
{
    NSString *num = @"Unknow";
    TelephoneLog(@"callWithnumber %@",number);
    if(number && ([number length] >= 1))
    {
        num = number;
    }

//    if(AppShare.iOS < 7)
//    {
//         TelephoneLog(@"call < 7");
//        CTCallDial(num);
//    }
//    else
//    {
        TelephoneLog(@"call >= 7");
//        CTCallDialWithID(num);
        
       // CTCallDial(num);
       // CTCallDialWithID(num,-1);

//        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",num]]];//thong bao truoc
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",num]]];// thong bao sau

//      
//    }
}

- (void) disconectAllCall
{
    TelephoneLog(@" disconectAllCall");
//    CTCallListDisconnectAll();
    

}

- (void) answerCurrentCall
{
    if(call)
    {
//        CTCallAnswer(call);
    }
}

- (void) disconectCurrentCall
{
    if(call)
    {
//        CTCallDisconnect(call);
    }
}

- (BOOL) isSIMReady
{
//    CFStringRef idc = CTSIMSupportCopyMobileSubscriberIdentity(NULL);
////    int sig = CTGetSignalStrength();
//    NSString *sId = [NSString stringWithFormat:@"%@", (NSString*)idc];
//    
//    
//    NSString *simStatus = CTSIMSupportGetSIMStatus();
////    TelephoneLog(@" sim status %@,sig = %d,[sId length] = %d", simStatus,sig,[sId length]);
//    if(AppShare.iOS >= 8.3)
//    {
//        if([simStatus rangeOfString:@"kCTSIMSupportSIMStatusReady"].location != NSNotFound &&[[self carierName] isEqualToString:@"Unknown"]==NO)
//        {
            return YES;
//        }
//    }
//    else
//    {    if(([simStatus rangeOfString:@"kCTSIMSupportSIMStatusReady"].location != NSNotFound) && (sig >= 5) && (sId && [sId length] > 0))
//        {
//            return YES;
//        }
//    }
//    return NO;
    
}
- (BOOL) radioAccess
{
    if(AppShare.iOS>=7)
    {
        CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
        if ([telephonyInfo respondsToSelector:@selector(currentRadioAccessTechnology)])
        {
            NSString *carrierNetwork = telephonyInfo.currentRadioAccessTechnology;
            if(!carrierNetwork)
            {
                //TelephoneLog(@"Radio failed");
                return NO;
            }
        }
    }
    else
    {
        return [self isSIMReady];
    }
    return YES;// if ios<7.0
}

- (int) waveLevel
{
//    int wl = CTGetSignalStrength();
    return 0;//wl;
}

- (NSString*) carierName
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    NSString *cn = [NSString stringWithFormat:@"%@", [carrier carrierName]];
    
    if((!cn) || [cn length] < 1)
    {
        return @"Unknown";
    }
    else
    {
        return cn;
    }
}

- (void) requestWithString:(NSString *)str
{
    if(AppShare.iOS < 7)
    {
        TelephoneLog(@" requestWithString os < 7");
    }
    else
    {
        TelephoneLog(@" requestWithString os >= 7");
    }
//    CTCallDial(str);
}

- (NSString*) SIMStatus
{
//    NSString *simStatus = CTSIMSupportGetSIMStatus();
//    simStatus = [simStatus stringByReplacingOccurrencesOfString:@"kCTSIMSupportSIMStatus" withString:@""];
    return @"";//simStatus;
}

- (BOOL) isSIMInserted
{
    NSString *simStatus = [self SIMStatus];
    
    TelephoneLog(@" SIM  Status : %@", simStatus);
    
    BOOL simReadOK = !([simStatus isEqualToString:@"NotInserted"] || [simStatus isEqualToString:@"NotReady"]);
    
    if(simReadOK)
    {
        return YES;
    }

    return NO;
}

- (void) dealloc
{
}

// kCTUSSDSessionStringNotification *102#
// kCTUSSDSessionStringNotification *101#

/*
 Request *101#
 2013-04-25 11:31:52.301 appDUT[2215:907] [CALL] CALL_callBack : kCTUSSDSessionStringNotification, {
    kCTUSSDSessionResponseRequested = 0;
    kCTUSSDSessionString = "Ban dang dung goi cuoc Tomato,ngay kich hoat 23/08/2012.TK goc 1 la 0 dong.";
    kCTUSSDSessionStringIsOutgoing = 1;
 }
 
 */

/*
 Recieve Message
 2013-04-25 11:20:42.964 appDUT[31871:707] [CALL] CALL_callBack : kCTMessageReceivedNotification, {
    kCTMessageIdKey = "-2147483637";
    kCTMessageTypeKey = 1;
 }
 */

/*
 Send Message Error
 2013-04-25 11:22:31.214 appDUT[31871:707] [CALL] CALL_callBack : kCTMessageSendErrorNotification, {
    kCTMessageIdKey = 823;
    kCTMessageSendErrorKey = 11;
    kCTMessageSendModemErrorKey = 96;
    kCTMessageTypeKey = 1;
 }
 */

/*
 Message Send Success
 2013-04-25 11:27:01.133 appDUT[2215:907] [CALL] CALL_callBack : kCTMessageSentNotification, {
    kCTMessageIdKey = 58879;
    kCTMessageTypeKey = 1;
 }
 */

@end
