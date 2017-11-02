//
//  Telephone.h
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


extern CFStringRef CTSIMSupportCopyMobileSubscriberCountryCode(void*);
extern CFStringRef CTSIMSupportCopyMobileSubscriberNetworkCode(void*);
//extern CFStringRef CTSIMSupportCopyMobileSubscriberIdentity(void*);

//extern NSString* CTSIMSupportGetSIMStatus();
//extern int CTGetSignalStrength();
@class MainTestViewController;
@interface Telephone : NSObject
{
}

@property (nonatomic, strong) CTCall *call;
- (void) callWithnumber:(NSString*)number;
- (void) disconectCurrentCall;
- (void) answerCurrentCall;
- (void) disconectAllCall;
- (BOOL) isSIMReady;
- (BOOL) isSIMInserted;
- (NSString*) SIMStatus;

- (void) requestWithString:(NSString*)str;
- (int) waveLevel;
- (BOOL) radioAccess;
- (NSString*) carierName;
@property (nonatomic, strong) MainTestViewController *parentView;
@end


extern void CTCallAnswer(CTCall *call);
extern void CTCallAddressBlocked(CTCall *call);
extern int CTCallGetStatus(CTCall *call);
extern int CTCallDial(NSString *num);
extern int CTCallListDisconnectAll();
extern void CTCallDisconnect(CTCall *call);

extern int CTCallDialWithID(NSString *numberToDial,int ID);


extern int CTGetSignalStrength();
extern NSString *CTSettingCopyMyPhoneNumber();

extern CFNotificationCenterRef CTTelephonyCenterGetDefault(void);
extern void CTTelephonyCenterAddObserver(CFNotificationCenterRef center, const void *observer, CFNotificationCallback callBack, CFStringRef name, const void *object, CFNotificationSuspensionBehavior suspensionBehavior);

//extern id dial(id arg1 ,int arg2);





