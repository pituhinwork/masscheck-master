//
//  Wireless.m
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import "iDevice.h"
#import "AppDelegate.h"
#import "Wireless.h"

#include <dlfcn.h>

//#define WIRELESSBUG
#if defined(WIRELESSBUG) || defined(DEBUG_ALL)
#   define WirelessLog(BachUng, ...) NSLog((@"%s[Line %d] " BachUng), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define WirelessLog(...)
#endif


#define WIRELESS_ZERO 0
#define WIRELESS_START 1
#define WIRELESS_ENDED 2

extern CFArrayRef CNCopySupportedInterfaces();
extern CFDictionaryRef CNCopyCurrentNetworkInfo(CFStringRef);

@implementation Wireless

static void Wifi_CallBack(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString* notifyName = (__bridge NSString*)name;
    
//    NSLog(@"[WIRELESS] Wifi_Callback,  intercepted %@, %@", notifyName, (NSDictionary*)userInfo);
    if ([notifyName isEqualToString:@"com.apple.system.config.network_change"])
    {
//        if(AppShare.viewController.wifiRadio)
//        {
//            [AppShare.viewController.wifiRadio performSelector:@selector(onWifiChangeNotify)];
//        }
    }
}

- (id) init
{
    self = [super init];
    
    void *handle = dlopen("/System/Library/SystemConfiguration/IPConfiguration.bundle/IPConfiguration", RTLD_LAZY | RTLD_GLOBAL);
    Apple80211Open = dlsym(handle, "Apple80211Open");
    Apple80211BindToInterface = dlsym(handle, "Apple80211BindToInterface");
    //Apple80211Close = dlsym(handle, "Apple80211Close");
    Apple80211Scan = dlsym(handle, "Apple80211Scan");
    Apple80211GetPower = dlsym(handle, "Apple80211GetPower");
    Apple80211SetPower = dlsym(handle, "Apple80211SetPower");
    Apple80211GetInfoCopy = dlsym(handle, "Apple80211GetInfoCopy");
    if(AppShare.iOS < 8)
    {
        if(Wifi_devhandle)
            Apple80211Open(&Wifi_devhandle);
//        Apple80211BindToInterface(Wifi_devhandle, CFSTR("en0"));
    }
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &Wifi_CallBack, CFSTR("com.apple.system.config.network_change"), NULL,CFNotificationSuspensionBehaviorDeliverImmediately);
    
    return self;
}

- (BOOL) deviceGoodStatus
{
//    if(AppShare.iOS < 8)
//    {
//        
//        if((Apple80211SetPower == NULL) || (Apple80211GetPower == NULL) || (Wifi_devhandle == NULL))
//        {
//            return NO;
//        }
//        else
//        {
//            Apple80211SetPower(Wifi_devhandle, (char)YES);
//            char a;
//            Apple80211GetPower(Wifi_devhandle, &a);
//            if(!a)
//            {
//                return NO;
//            }
//        }
//    }
    return YES;
}

/*
 
 Known CFDictionary keys for info
 
 All keys are CFStrings
 
 STATE - An integer CFNumber indicating the state of the device. Its value is 4 if the interface is associated
 SSID_STR - A CFString containing the network name the interface is currently associated with (may be absent if the interface is not associated)
 POWER - A CFArray that appears to contain one CFNumber (not sure what it means)
 BSSID - A CFString containing a colon-separated BSSID (MAC address) of the currently associated network (may be absent if the interface is not associated)
 TXPOWER - An integer CFNumber containing the current transmit power?
 POWERSAVE - An integer CFNumber indicating whether the device is currently in power saving mode?
 RSSI - A CFDictionary of information on the signal strength
 AUTH_TYPE - A CFDictionary of information on the authentication type?
 SSID - A CFData containing the currently associated SSID in an unknown format
 CHANNEL - A CFDictionary containing the channel and channel flags (the flags are currently unknown)
 RATE - An integer CFNumber containing the current rate of the connection (seems to be in megabits per second)
 
{
    "AUTH_TYPE" =     {
        "AUTH_LOWER" = 1;
        "AUTH_UPPER" = 8;
    };
    BSSID = "20:aa:4b:a:f3:37";
    CHANNEL =     {
        CHANNEL = 6;
        "CHANNEL_FLAGS" = 10;
    };
    "OP_MODE" = 1;
    POWER =     (
                 1
                 );
    POWERSAVE = 1;
    RATE = 54;
    RSSI =     {
        "RSSI_CTL_AGR" = "-52";
        "RSSI_UNIT" = "-1";
    };
    SSID = <524448>;
    "SSID_STR" = RDH;
    STATE = 4;
}
*/

- (NSDictionary*) getWifiInformation
{
    CFDictionaryRef inf;
    Apple80211GetInfoCopy(Wifi_devhandle, &inf);
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary*)inf];
    
    //NSLog(@"[WIRELESS] dic : %@", [dic description]);
    
    return dic;
}

/*
 
 SSID - A CFData that requests which ESSID (network name) should be scanned
 SSID_STR - A CFString version of the SSID
 SCAN_CHANNELS - A CFArray of CFDictionary objects, each containing CFStrings for "CHANNEL" and "CHANNEL_FLAGS"
 SCAN_MERGE (true if unspecified) - A CFBoolean that specifies whether the function should discard multiple BSSIDs for the same network name.
 SCAN_FLAGS (0 if unspecified)
 SCAN_RSSI_THRESHOLD
 SCAN_BSS_TYPE (3 if unspecified)
 SCAN_TYPE (1 if unspecified)
 SCAN_PHY_MODE (1 if unspecified)
 SCAN_DWELL_TIME (0 if unspecified)
 SCAN_REST_TIME (0 if unspecified)
 
 */

- (void) scanWifi
{
//    NSArray *keys = [NSArray arrayWithObjects:@"SCAN_RSSI_THRESHOLD", @"SSID_STR", nil];
//    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithInt:-100], @"RDH", nil];
//    
//    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
//    CFArrayRef found;
//    
//    int scanResult = Apple80211Scan(Wifi_devhandle, &found, (__bridge CFDictionaryRef*)params);
//    
////    NSDictionary *network;
////    
////    // get the first network found
////    network = [found objectAtIndex:0];
////    
////    int associateResult = Apple80211Associate(airportHandle, network,NULL);
////    
////    Apple80211Scan(Wifi_devhandle, &aRef, (CFDictionaryRef*)cRef);
//    
//    NSLog(@"[WIRELESS] scan : %d, %@", scanResult, [(__bridge NSArray*)found description]);
}

- (NSString*) accessPointName
{
    WirelessLog();

        CFArrayRef myArray = CNCopySupportedInterfaces();
        // Get the dictionary containing the captive network infomation
        WirelessLog(@"myArray: %@",myArray);
        if(myArray==Nil) return Nil;
        CFStringRef interfaceName = CFArrayGetValueAtIndex(myArray, 0);
        WirelessLog(@"nterfaceName: %@",interfaceName);
        CFDictionaryRef captiveNtwrkDict = CNCopyCurrentNetworkInfo(interfaceName);
        
        WirelessLog(@" Information of the network we're connected to: %@", captiveNtwrkDict);
        
    NSDictionary *dict = (__bridge  NSDictionary*) captiveNtwrkDict;
        NSString* ssid = [dict objectForKey:@"SSID"];
        return ssid;
}

- (BOOL) turn3G:(BOOL)isOn
{
    if(AppShare.iOS < 8)
    {
//        if(CTRegistrationSetCellularDataIsEnabled == NULL)
//        {
//            return NO;
//        }
//        else
//        {
//            CTRegistrationSetCellularDataIsEnabled(isOn);
//        }
    }
    return YES;
}

- (void) turnWifi:(BOOL)isOn
{
    if(AppShare.iOS<8)
        Apple80211SetPower(Wifi_devhandle, (char)isOn);
}

- (void) connectToNetwork
{
    
}

- (void) dealloc
{
}

@end
