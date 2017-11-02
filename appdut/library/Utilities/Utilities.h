//
//  Utilities.h
//  testprod
//
//  Created by Toan Nguyen Van on 1/5/13.
//  Copyright (c) 2013 ccinteg. All rights reserved.
//

#ifndef testprod_Utilities_h
#define testprod_Utilities_h

#import <stdio.h>
#import <unistd.h>
#import <dlfcn.h>

#include <sys/param.h>
#include <sys/sysctl.h>
#include <stdlib.h>

#define UTILITIES
#if defined(UTILITIES) || defined(DEBUG_ALL)
#   define UtilitiesLog(BachUng, ...) NSLog((@"%s[Line %d] " BachUng), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define UtilitiesLog(...)
#endif


#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreVideo/CoreVideo.h>
#import <QuartzCore/QuartzCore.h>

extern int SBSSpringBoardServerPort();
extern NSArray* SBSCopyApplicationDisplayIdentifiers(mach_port_t* port, BOOL runningApps,BOOL debuggable);
extern void* SBFrontmostApplicationDisplayIdentifier(mach_port_t* port,char * result);
extern void* SBDisplayIdentifierForPID(mach_port_t* port, int pid,char *rslt);
extern NSString * SBSCopyIconImagePathForDisplayIdentifier(NSString *identifier);
static void setDeviceVolume(float vol);

extern void GSEventSetBacklightLevel(float a);
static void setScreenBacklight(float level)
{
    GSEventSetBacklightLevel(level);
}

// Turn on Location service on Jailbreak phone
//static void turnLocationService(BOOL isOn)
//{
//    NSString *settingFile = @"/var/mobile/Library/Preferences/com.apple.locationd.plist";
//    if([[NSFileManager defaultManager] fileExistsAtPath:settingFile])
//    {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:settingFile];
//        
//        [dic setValue:[NSNumber numberWithBool:YES] forKey:@"LocationEnabled"];
//        [dic setValue:[NSNumber numberWithBool:isOn] forKey:@"LocationServicesEnabled"];
//        
//        [dic writeToFile:settingFile atomically:YES];
//        
//        notify_post("com.apple.locationd/Prefs");
//    }
//}
//static NSString* getValue(NSString *iosearch)
//{
//    mach_port_t masterPort;
//    CFTypeID propID;
//    unsigned int bufSize;
//    
//    kern_return_t kr = IOMasterPort(MACH_PORT_NULL, &masterPort);
//    if (kr != noErr)
//    {
//        return NULL;
//    }
//    
//    io_registry_entry_t entry = IORegistryGetRootEntry(masterPort);
//    if (entry == MACH_PORT_NULL)
//    {
//        return NULL;
//    }
//    
//    CFTypeRef prop = IORegistryEntrySearchCFProperty(entry, kIODeviceTreePlane, iosearch, nil, kIORegistryIterateRecursively);
//    if (prop == nil) return NULL;
//    else propID = CFGetTypeID(prop);
//    if (!propID == CFDataGetTypeID())
//    {
//        mach_port_deallocate(mach_task_self(), masterPort);
//        return NULL;
//    }
//    
//    CFDataRef propData = (CFDataRef)prop;
//    if (!propData)
//    {
//        return NULL;
//    }
//    
//    bufSize = CFDataGetLength(propData);
//    if (!bufSize)
//    {
//        return NULL;
//    }
//    
//    id p1 = [[NSString alloc] initWithBytes:CFDataGetBytePtr(propData) length:bufSize encoding:1];
//    mach_port_deallocate(mach_task_self(), masterPort);
//    
//    return p1;
//}
static NSString *getPhoneModal(int coded)
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    NSLog(@"getPhoneModal : %@", platform);
    
    if(coded == 1)
    {
        if ([platform isEqualToString:@"iPhone1,1"])    return @"1G"; // iPhone
        if ([platform isEqualToString:@"iPhone1,2"])    return @"3G";
        if ([platform isEqualToString:@"iPhone2,1"])    return @"3GS";
        if ([platform isEqualToString:@"iPhone3,1"])    return @"4"; // AT$T
        if ([platform isEqualToString:@"iPhone3,2"])    return @"4";
        if ([platform isEqualToString:@"iPhone3,3"])    return @"4"; // Verizon
        if ([platform isEqualToString:@"iPhone4,1"])    return @"4S";
        if ([platform isEqualToString:@"iPhone5,1"])    return @"5G";
        if ([platform isEqualToString:@"iPhone5,2"])    return @"5"; // (GSM+CDMA)
        if ([platform isEqualToString:@"iPhone5,3"])    return @"5c"; // (model A1456, A1532 | GSM)
        if ([platform isEqualToString:@"iPhone5,4"])    return @"5c"; // (model A1507, A1516, A1526 (China), A1529 | Global | GSM+CDMA)
        if ([platform isEqualToString:@"iPhone6,1"])    return @"5s"; // (model A1433, A1533 | GSM)
        if ([platform isEqualToString:@"iPhone6,2"])    return @"5s"; // (model A1457, A1518, A1528 (China), A1530 | Global | GSM+CDMA)
        if ([platform isEqualToString:@"iPhone7,1"])    return @"6 Plus"; // Plus (GSM+CDMA)
        if ([platform isEqualToString:@"iPhone7,2"])    return @"6"; // (GSM+CDMA)
        if ([platform isEqualToString:@"iPhone8,1"])    return @"6s";
        if ([platform isEqualToString:@"iPhone8,2"])    return @"6s Plus";
        if ([platform isEqualToString:@"iPhone8,4"])    return @"SE";
        if ([platform isEqualToString:@"iPhone9,1"])    return @"7 (A1660/A1779/A1780";
        if ([platform isEqualToString:@"iPhone9,2"])    return @"7 Plus (A1661/A1785/A1786)";
        if ([platform isEqualToString:@"iPhone9,3"])    return @"7 (A1778)";
        if ([platform isEqualToString:@"iPhone9,4"])    return @"7 Plus (A1784)";
        
        
        if ([platform isEqualToString:@"iPod1,1"])      return @"1G"; // iPod Touch x
        if ([platform isEqualToString:@"iPod2,1"])      return @"2G"; //x
        if ([platform isEqualToString:@"iPod3,1"])      return @"3G";//x
        if ([platform isEqualToString:@"iPod4,1"])      return @"4G";
        if ([platform isEqualToString:@"iPod5,1"])      return @"touch";
        if ([platform isEqualToString:@"iPod7,1"])      return @"touch";
        
        if ([platform isEqualToString:@"iPad1,1"])      return @"1G"; // iPad x
        if ([platform isEqualToString:@"iPad2,1"])      return @"2G"; // Wifi
        if ([platform isEqualToString:@"iPad2,2"])      return @"2G"; // GSM
        if ([platform isEqualToString:@"iPad2,3"])      return @"2G"; // CDMA
        if ([platform isEqualToString:@"iPad2,4"])      return @"2G";
        if ([platform isEqualToString:@"iPad3,1"])      return @"3G"; // Wifi
        if ([platform isEqualToString:@"iPad3,2"])      return @"3G"; // 4G
        if ([platform isEqualToString:@"iPad3,3"])      return @"3G"; // 4G
        if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4";// (WiFi)";
        if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4";//(GSM+CDMA)";
        if ([platform isEqualToString:@"iPad4,1"])      return @"Air";//WiFi) NOSIM";
        if ([platform isEqualToString:@"iPad4,2"])      return @"Air";// Cellular";
        if ([platform isEqualToString:@"iPad4,4"])      return @"Mini";// - (WiFi) NOSIM";
        if ([platform isEqualToString:@"iPad4,5"])      return @"Mini - Cellular";
        if ([platform isEqualToString:@"iPad4,7"])      return @"Mini - 3";// (WiFi) NOSIM";
        if ([platform isEqualToString:@"iPad4,8"])      return @"Mini - 3";
        if ([platform isEqualToString:@"iPad4,9"])      return @"Mini - 3";
        if ([platform isEqualToString:@"iPad5,3"])      return @"air 2";// NOSIM";
        if ([platform isEqualToString:@"iPad5,4"])      return @"air 2";
        if ([platform isEqualToString:@"iPad6,3"])      return @"Pro (9.7 inch)";// (Wi-Fi)";
        if ([platform isEqualToString:@"iPad6,4"])      return @"Pro (9.7 inch)";// (Wi-Fi+LTE)";
        if ([platform isEqualToString:@"iPad6,7"])      return @"Pro (12.9 inch)";//, Wi-Fi)";
        if ([platform isEqualToString:@"iPad6,8"])      return @"Pro (12.9 inch)";//, Wi-Fi+LTE)";
        
        
        if ([platform isEqualToString:@"i386"])         return @"Simulator x32";
        if ([platform isEqualToString:@"x86_64"])       return @"Simulator x64";
    }
    else if(coded == 2)
    {
        NSString *msg = [platform uppercaseString];
        msg = [msg stringByReplacingOccurrencesOfString:@"IPHONE" withString:@""];
        msg = [msg stringByReplacingOccurrencesOfString:@"IPAD" withString:@""];
        msg = [msg stringByReplacingOccurrencesOfString:@"IPOD" withString:@""];
        msg = [msg stringByReplacingOccurrencesOfString:@"," withString:@"."];
        return msg;
    }
    else if(coded == 3)
    {
        if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
        if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
        if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
        if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
        if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S (GSM+CDMA)";
        if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
        if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
        if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (model A1456, A1532 | GSM)";
        if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global | GSM+CDMA)";
        if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (model A1433, A1533 | GSM)";
        if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global | GSM+CDMA)";
        if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus (GSM+CDMA)";
        if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6 (GSM+CDMA)";
        if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s (GSM+CDMA)";
        if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus (GSM+CDMA)";
        if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
        if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (A1660/A1779/A1780";
        if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (A1661/A1785/A1786)";
        if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (A1778)";
        if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (A1784)";
        
        
        if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen) NOSIM";
        if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen) NOSIM";
        if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen) NOSIM";
        if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen) NOSIM";
        if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen) NOSIM";
        if ([platform isEqualToString:@"iPod7,1"])      return @"iPod touch (6 gen) NOSIM";
        
        
        if ([platform isEqualToString:@"iPad1,1"])      return @"iPad NOSIM";
        if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
        if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi) NOSIM";
        if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
        if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi) NOSIM";
        if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi) NOSIM";
        if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
        if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
        if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi) NOSIM";
        if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
        if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
        if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi) NOSIM";
        if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
        if ([platform isEqualToString:@"iPad4,1"])      return @"iPad (iPad Air) (WiFi) NOSIM";
        if ([platform isEqualToString:@"iPad4,2"])      return @"iPad (iPad Air) Cellular";
        if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini - (WiFi) NOSIM";
        if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini - Cellular";
        if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini - 3 (WiFi) NOSIM";
        if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini - 3";
        if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini - 3";
        if ([platform isEqualToString:@"iPad5,3"])      return @"iPad air 2 NOSIM";
        if ([platform isEqualToString:@"iPad5,4"])      return @"iPad air 2";
        if ([platform isEqualToString:@"iPad6,3"])      return @"iPad Pro (9.7 inch) (Wi-Fi)";
        if ([platform isEqualToString:@"iPad6,4"])      return @"iPad Pro (9.7 inch) (Wi-Fi+LTE)";
        if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro (12.9 inch, Wi-Fi)";
        if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro (12.9 inch, Wi-Fi+LTE)";
        
        
        
        if ([platform isEqualToString:@"i386"])         return @"Simulator";
        if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
        
    }
    else if(coded == 4)
    {
        if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
        if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
        if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
        if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
        if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S (GSM+CDMA)";
        if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
        if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
        if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
        if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
        if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
        if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
        if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
        if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6 ";
        if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s ";
        if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
        if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
        if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7 ";
        if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
        if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7 ";
        if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 ";
        
        
        if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen) ";
        if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen) ";
        if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen) ";
        if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen) ";
        if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen) ";
        if ([platform isEqualToString:@"iPod7,1"])      return @"iPod touch (6 gen) ";
        
        
        if ([platform isEqualToString:@"iPad1,1"])      return @"iPad ";
        if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
        if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
        if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
        if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
        if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
        if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
        if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini";
        if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
        if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3";
        if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
        if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
        if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 ";
        if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
        if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air Cellular";
        if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini - (WiFi)";
        if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini - Cellular";
        if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini - 3 (WiFi)";
        if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini - 3";
        if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini - 3";
        if ([platform isEqualToString:@"iPad5,3"])      return @"iPad air 2";
        if ([platform isEqualToString:@"iPad5,4"])      return @"iPad air 2";
        if ([platform isEqualToString:@"iPad6,3"])      return @"iPad Pro (9.7 inch) (Wi-Fi)";
        if ([platform isEqualToString:@"iPad6,4"])      return @"iPad Pro (9.7 inch) (Wi-Fi+LTE)";
        if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro (12.9 inch, Wi-Fi)";
        if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro (12.9 inch, Wi-Fi+LTE)";
        
        
        
        if ([platform isEqualToString:@"i386"])         return @"Simulator";
        if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
        
    }
    return platform;
}

static BOOL isSupportMute()
{
    NSString *model = getPhoneModal(0);
    if([[model uppercaseString] rangeOfString:@"IPHONE"].location!= NSNotFound)
        return YES;
    if([[model uppercaseString] rangeOfString:@"IPAD"].location!= NSNotFound)
    {
        NSString *num = getPhoneModal(2);
        float val = [num floatValue];
        if(val < (float)5.2)
            return YES;
    }
    return NO;
}

//static void set_brightness(float new_brightness)
//{
//    UInt32 display[1];
//    int numDisplays;
//    NSError *err;
//    err = CGGetActiveDisplayList(1, display, &numDisplays);
//    
//    if (err != CGDisplayNoErr)
//        printf("cannot get list of displays (error %d)\n",err);
//        for (CGDisplayCount i = 0; i < numDisplays; ++i)
//        {
//            CGDirectDisplayID dspy = display[i];
//            CFDictionaryRef originalMode = CGDisplayCurrentMode(dspy);
//            
//            if (originalMode == NULL)
//                continue;
//            io_service_t service = CGDisplayIOServicePort(dspy);
//            
//            float brightness;
//            err= IODisplayGetFloatParameter(service, kNilOptions, kDisplayBrightness,
//                                            &brightness);
//            if (err != kIOReturnSuccess)
//            {
//                fprintf(stderr,
//                        "failed to get brightness of display 0x%x (error %d)",
//                        (unsigned int)dspy, err);
//                continue;
//            }
//            
//            err = IODisplaySetFloatParameter(service, kNilOptions, kDisplayBrightness,
//                                             new_brightness);
//            if (err != kIOReturnSuccess)
//            {
//                UtilitiesLog(@"Failed to set brightness of display 0x%x (error %d)", (unsigned int)dspy, err);
//                continue;
//            }
//        }
//}

static AVAudioPlayer *newPlayer = Nil;
static void PlayBeep()
{
    AudioSessionInitialize (NULL, NULL, NULL, NULL);
    AudioSessionSetActive(true);
    
    // Allow playback even if Ring/Silent switch is on mute
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *fileURL = [NSURL fileURLWithPath:soundFilePath];
    
    if(newPlayer == nil)
    {
        UtilitiesLog(@" PlayBeep newPlayer = Nil");
        newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
    }
    else
    {
         UtilitiesLog(@" PlayBeep");
    }
        
    
    [newPlayer setVolume:0.5];
    [newPlayer play];

}

static void PlaySoundName(NSString *fileName, NSString *fileType)
{
    AudioSessionInitialize (NULL, NULL, NULL, NULL);
    AudioSessionSetActive(true);
    
    // Allow playback even if Ring/Silent switch is on mute
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    NSURL *fileURL = [NSURL fileURLWithPath:soundFilePath];
    
    if(newPlayer)
    {
        newPlayer = nil;
    }
    
    newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error: nil];
    [newPlayer setVolume:1.0];
    [newPlayer play];
}

/*
 (
     "<AVCaptureFigVideoDevice: 0x200b3680 [Back Camera][com.apple.avfoundation.avcapturedevice.built-in_video:0]>",
     "<AVCaptureFigVideoDevice: 0x1ed989f0 [Front Camera][com.apple.avfoundation.avcapturedevice.built-in_video:1]>",
     "<AVCaptureFigAudioDevice: 0x1edb07b0 [Headphones][com.apple.avfoundation.avcapturedevice.built-in_audio:0]>"
 )
 
 (
     "<AVCaptureFigVideoDevice: 0x208570c0 [Back Camera][com.apple.avfoundation.avcapturedevice.built-in_video:0]>",
     "<AVCaptureFigVideoDevice: 0x2084ad40 [Front Camera][com.apple.avfoundation.avcapturedevice.built-in_video:1]>",
     "<AVCaptureFigAudioDevice: 0x20859c60 [Microphone][com.apple.avfoundation.avcapturedevice.built-in_audio:0]>"
 )
 
 */

static bool isExistFrontCamera()
{
    BOOL isExistedFront = NO;
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
    {
        
        NSArray *arr = [AVCaptureDevice devices];
        NSString *str = [NSString stringWithFormat:@"%@", [arr description]];
        str = [str uppercaseString];
        
        UtilitiesLog(@"============ From :%@", str);
        
        if([str rangeOfString:@"FRONT CAMERA"].location != NSNotFound)
        {
            isExistedFront = YES;
        }
    }
    
    return isExistedFront;
}

static bool isExistMainCamera()
{
    BOOL isExistedMain = NO;
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
    {
        NSArray *arr = [AVCaptureDevice devices];
        NSString *str = [NSString stringWithFormat:@"%@", [arr description]];
        str = [str uppercaseString];
        
        UtilitiesLog(@"============Rear: %@", str);
        
        if([str rangeOfString:@"BACK CAMERA"].location != NSNotFound)
        {
            isExistedMain = YES;
            return isExistedMain;
        }
        
        // kiem tra neu khong ton tai camera front so only can 3g or device only one camera 
        if([str rangeOfString:@"FRONT CAMERA"].location == NSNotFound)
        {
            NSString *model = getPhoneModal(4);
            if([[model uppercaseString] rangeOfString:@"IPHONE"].location != NSNotFound)
            {
                if([str rangeOfString:@"CAMERA"].location != NSNotFound)
                {
                    isExistedMain = YES;
                    return isExistedMain;
                }
            }
        }
    }
    
    return isExistedMain;
}
static bool isExistCamera()
{
    BOOL isExistedMain = NO;
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
    {
        NSArray *arr = [AVCaptureDevice devices];
        NSString *str = [NSString stringWithFormat:@"%@", [arr description]];
        str = [str uppercaseString];
        
        UtilitiesLog(@"============Rear: %@", str);
        
        if([str rangeOfString:@"CAMERA"].location != NSNotFound)
        {
            isExistedMain = YES;
        }
    }
    
    return isExistedMain;
}

static bool isHeadphonePlugged()
{
    BOOL isUsedHeadphone = NO;
    
    OSStatus error = AudioSessionInitialize(NULL, NULL, NULL, NULL);
    if(error)
    {
        UtilitiesLog(@"Error %ld while initializing session", error);
    }
    
    UInt32 routeSize = sizeof (CFStringRef);
    CFStringRef routeRef;
    
    error = AudioSessionGetProperty (kAudioSessionProperty_AudioRoute, &routeSize, &routeRef);
    
//    NSString *route = [[[NSString alloc] initWithFormat:@"%@", (NSString*)routeRef] uppercaseString];
    NSString *route = (__bridge NSString*)routeRef;
     route = [route uppercaseString];
    /* Known values of route:
       "Headset"
       "Headphone"
       "Speaker"
       "SpeakerAndMicrophone"
       "HeadphonesAndMicrophone"
       "HeadsetInOut"
       "ReceiverAndMicrophone"
       "Lineout"
     */
    
    UtilitiesLog(@" Using %@", route);
    
    if(error)
    {
        UtilitiesLog(@" Error %ld while retrieving audio property", error);
    }
    else if(route == NULL)
    {
        UtilitiesLog(@"Silent switch is currently on");
    }
    else if(([route rangeOfString:@"HEADSET"].location != NSNotFound) || ([route rangeOfString:@"HEADPHONE"].location != NSNotFound))
    {
        isUsedHeadphone = YES;
    }
    if(routeRef != Nil)
        CFRelease(routeRef);
    return isUsedHeadphone;
}

static BOOL setFlashMode(BOOL isOn)
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device isTorchAvailable])
    {
        [device lockForConfiguration:nil];
        
        if(isOn)
        {
            [device setTorchMode:AVCaptureTorchModeOn];
        }
        else
        {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        
        [device unlockForConfiguration];
    }
    else
    {
        return NO;
    }
    
    return YES;
}

//static NSArray* getActiveApps()
//{
//    mach_port_t *p;
//    p = (mach_port_t *)SBSSpringBoardServerPort();
//    
//    //Get frontmost application
//    char frontmostAppS[256];
//    memset(frontmostAppS,sizeof(frontmostAppS),0);
//    SBFrontmostApplicationDisplayIdentifier(p,frontmostAppS);
//    NSString * frontmostApp=[NSString stringWithFormat:@"%s",frontmostAppS];
//    //UtilitiesLog(@"Frontmost app is %@",frontmostApp);
//    //get list of running apps from SpringBoard
//    NSArray *allApplications = SBSCopyApplicationDisplayIdentifiers(p,NO, NO);
//    
//    //Really returns ACTIVE applications(from multitasking bar)
//    UtilitiesLog(@"Active applications: %@", [allApplications description]);
//    
//    //get list of all apps from kernel
//    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
//    size_t miblen = 4;
//    
//    size_t size;
//    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
//    
//    struct kinfo_proc * process = NULL;
//    struct kinfo_proc * newprocess = NULL;
//    
//    do {
//        
//        size += size / 10;
//        newprocess = realloc(process, size);
//        
//        if (!newprocess)
//        {
//            if (process)
//            {
//                free(process);
//            }
//            
//            return nil;
//        }
//        
//        process = newprocess;
//        st = sysctl(mib, miblen, process, &size, NULL, 0);
//        
//    } while (st == -1 && errno == ENOMEM);
//    
//    if (st == 0)
//    {
//        
//        if (size % sizeof(struct kinfo_proc) == 0)
//        {
//            int nprocess = size / sizeof(struct kinfo_proc);
//            
//            if (nprocess)
//            {
//                
//                NSMutableArray * array = [[NSMutableArray alloc] init];
//                
//                for (int i = nprocess - 1; i >= 0; i--)
//                {
//                    
//                    int ruid=process[i].kp_eproc.e_pcred.p_ruid;
//                    //int uid=process[i].kp_eproc.e_ucred.cr_uid;
//                    //short int nice=process[i].kp_proc.p_nice;
//                    //short int u_prio=process[i].kp_proc.p_usrpri;
//                    short int prio=process[i].kp_proc.p_priority;
//                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
//                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
//                    
//                    
//                    BOOL systemProcess = YES;
//                    if (ruid==501)
//                    {
//                        systemProcess = NO;
//                    }
//                    
//                    char *appid[256];
//                    memset(appid, sizeof(appid), 0);
//                    int intID;
//                    intID = process[i].kp_proc.p_pid;
//                    SBDisplayIdentifierForPID(p, intID, appid);
//                    
//                    NSString * appId = [NSString stringWithFormat:@"%s", appid];
//                    
//                    if (systemProcess == NO)
//                    {
//                        if ([appId isEqualToString:@""])
//                        {
//                            //final check.if no appid this is not springboard app
//                            UtilitiesLog(@"(potentially system)Found process with PID:%@ name %@,isSystem:%d,Priority:%d", processID, processName, systemProcess, prio);
//                        }
//                        else
//                        {
//                            
//                            BOOL isFrontmost=NO;
//                            if ([frontmostApp isEqualToString:appId])
//                            {
//                                isFrontmost=YES;
//                            }
//                            NSNumber *isFrontmostN=[NSNumber numberWithBool:isFrontmost];
//                            NSDictionary * dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processID, processName, appId, isFrontmostN, nil]
//                                                                                forKeys:[NSArray arrayWithObjects:@"ProcessID", @"ProcessName", @"AppID", @"isFrontmost", nil]];
//                            
//                            UtilitiesLog(@"PID:%@, name: %@, AppID:%@,isFrontmost:%d", processID, processName, appId, isFrontmost);
//                            [array addObject:dict];
//                        }
//                    }
//                }
//                
//                free(process);
//                return array;
//            }
//        }
//    }
//    
//    return nil;
//}

static void saveImageToAlbum(UIImage *image, NSString *filename)
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filepath = [NSString stringWithFormat:@"%@/%@.png", [paths objectAtIndex:0], filename];
    
    UtilitiesLog(@"[UTIL] save Image to : %@", filepath);
    
    [UIImagePNGRepresentation(image) writeToFile:filepath atomically:YES];
    
//    ALAssetsLibrary *library = [[[ALAssetsLibrary alloc] init] autorelease];
//    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
//        if (error) {
//            // TODO: error handling
//        } else {
//            // TODO: success handling
//        }
//    }];
     
}

static int imageSaveCount = 0;

static void saveImageToAlbumWithCount(UIImage *image)
{
    saveImageToAlbum(image, [NSString stringWithFormat:@"cam_%02d", ++imageSaveCount]);
}

static float forceVolume = 0.0;
static void setDeviceVolume(float vol)
{
    if(fabs(forceVolume - vol) > 0.01)
    {
        forceVolume = vol;
        
        // Set system volume to maximum
//        float newVolumeLevel = vol;
//        Class avSystemControllerClass = NSClassFromString(@"AVSystemController");
//        id avSystemControllerInstance = [avSystemControllerClass performSelector:@selector(sharedAVSystemController)];
//        
//        NSString *soundCategory = @"Ringtone";
//        
//        NSInvocation *volumeInvocation = [NSInvocation invocationWithMethodSignature:
//                                          [avSystemControllerClass instanceMethodSignatureForSelector:
//                                           @selector(setVolumeTo:forCategory:)]];
//        [volumeInvocation setTarget:avSystemControllerInstance];
//        [volumeInvocation setSelector:@selector(setVolumeTo:forCategory:)];
//        [volumeInvocation setArgument:&newVolumeLevel atIndex:2];
//        [volumeInvocation setArgument:&soundCategory atIndex:3];
//        [volumeInvocation invoke];
//        
//        NSString *soundCategoryH = @"Headphone";
//        NSInvocation *volumeInvocationH = [NSInvocation invocationWithMethodSignature:
//                                          [avSystemControllerClass instanceMethodSignatureForSelector:
//                                           @selector(setVolumeTo:forCategory:)]];
//        [volumeInvocationH setTarget:avSystemControllerInstance];
//        [volumeInvocationH setSelector:@selector(setVolumeTo:forCategory:)];
//        [volumeInvocationH setArgument:&newVolumeLevel atIndex:2];
//        [volumeInvocationH setArgument:&soundCategoryH atIndex:3];
//        [volumeInvocationH invoke];
//        
//        NSString *soundCategoryP = @"Playback";
//        NSInvocation *volumeInvocationP = [NSInvocation invocationWithMethodSignature:
//                                           [avSystemControllerClass instanceMethodSignatureForSelector:
//                                            @selector(setVolumeTo:forCategory:)]];
//        [volumeInvocationP setTarget:avSystemControllerInstance];
//        [volumeInvocationP setSelector:@selector(setVolumeTo:forCategory:)];
//        [volumeInvocationP setArgument:&newVolumeLevel atIndex:2];
//        [volumeInvocationP setArgument:&soundCategoryP atIndex:3];
//        [volumeInvocationP invoke];
    }
}

/* **********************************************
 
    Check Phone is Airplane Mode
 */

static bool isAirPlaneMode()
{
    void *libHandle = dlopen("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_LAZY | RTLD_GLOBAL | RTLD_NOW);
    int (*AirplaneMode)() = dlsym(libHandle, "CTPowerGetAirplaneMode");
    int status = AirplaneMode();
    return !status;
}

/*=================================================
 Base64 Encode/Decode
 */

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

/* ----------- Base64 Encode -------------
 Create an String Base64 to send instead of non-Alpha letter
 @param objData : raw data to be encoded to Base64
 <= return NSString Base64 Encoded.
 */
NSString* encodeBase64WithData(NSData *objData)
{
    const unsigned char * objRawData = [objData bytes];
    char * objPointer;
    char * strResult;
    
    // Get the Raw Data length and ensure we actually have data
    int intLength = [objData length];
    if (intLength == 0) return nil;
    
    // Setup the String-based Result placeholder and pointer within that placeholder
    strResult = (char *)calloc((((intLength + 2) / 3) * 4) + 1, sizeof(char));
    objPointer = strResult;
    
    // Iterate through everything
    while (intLength > 2) // keep going until we have less than 24 bits
    {
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
        // we just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3;
    }
    
    // now deal with the tail end of things
    if (intLength != 0)
    {
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1)
        {
            *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        }
        else
        {
            *objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    
    // Terminate the string-based result
    *objPointer = '\0';
    
    // Return the results as an NSString object
    return [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
}

/* ----------- Base64 Decode -------------
 Decode the Base64 Data to NSData
 @param strBase64 : is the encode Base64 data
 <= return decode Base64 NSData
 */
NSData* decodeBase64WithString(NSString *strBase64)
{
    const char * objPointer = [strBase64 cStringUsingEncoding:NSASCIIStringEncoding];
    int intLength = strlen(objPointer);
    int intCurrent;
    int i = 0, j = 0, k;
    
    unsigned char * objResult;
    objResult = (unsigned char *)calloc(intLength, sizeof(unsigned char));
    
    // Run through the whole string, converting as we go
    while ( ((intCurrent = *objPointer++) != '\0') && (intLength-- > 0) )
    {
        if (intCurrent == '=')
        {
            if (*objPointer != '=' && ((i % 4) == 1))
            {// || (intLength > 0)) {
                // the padding character is invalid at this point -- so this entire string is invalid
                free(objResult);
                return nil;
            }
            continue;
        }
        
        intCurrent = _base64DecodingTable[intCurrent];
        if (intCurrent == -1)
        {
            // we're at a whitespace -- simply skip over
            continue;
        }
        else if (intCurrent == -2)
        {
            // we're at an invalid character
            free(objResult);
            return nil;
        }
        
        switch (i % 4)
        {
            case 0:
                objResult[j] = intCurrent << 2;
                break;
                
            case 1:
                objResult[j++] |= intCurrent >> 4;
                objResult[j] = (intCurrent & 0x0f) << 4;
                break;
                
            case 2:
                objResult[j++] |= intCurrent >>2;
                objResult[j] = (intCurrent & 0x03) << 6;
                break;
                
            case 3:
                objResult[j++] |= intCurrent;
                break;
        }
        i++;
    }
    
    // mop things up if we ended on a boundary
    k = j;
    if (intCurrent == '=')
    {
        switch (i % 4)
        {
            case 1:
                // Invalid state
                free(objResult);
                return nil;
                
            case 2:
                k++;
                // flow through
            case 3:
                objResult[k] = 0;
        }
    }
    
    // Cleanup and setup the return NSData
    NSData * objData = [[NSData alloc] initWithBytes:objResult length:j];
    free(objResult);
    return objData;
}

#endif
