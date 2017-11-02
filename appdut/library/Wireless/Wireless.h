//
//  Wireless.h
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import <Foundation/Foundation.h>

int (*Apple80211Open)(void*);
int (*Apple80211BindToInterface)(void*, CFStringRef);
//    int (*Apple80211Close)(void *);
//    int (*Apple80211Scan)(void *, CFArrayRef *, void *);
int (*Apple80211GetPower)(void*, char*);
int (*Apple80211SetPower)(void*, char);
void *Wifi_devhandle;
int (*Apple80211GetInfoCopy)(void*, CFDictionaryRef*);
//int Apple80211Scan(struct Apple80211 *handle, CFArrayRef *list, CFDictionaryRef *parameters);
int (*Apple80211Scan)(void*, CFArrayRef*, CFDictionaryRef*);

//extern int CTRegistrationSetCellularDataIsEnabled(BOOL);

@interface Wireless : NSObject
{
    
}

- (void) connectToNetwork;

- (NSString*) accessPointName;
- (BOOL) deviceGoodStatus;

- (BOOL) turn3G:(BOOL)isOn;
- (void) turnWifi:(BOOL)isOn;

- (NSDictionary*) getWifiInformation;
- (void) scanWifi;

@end
