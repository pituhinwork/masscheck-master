//
//  CheckPart.m
//  testprod
//
//  Created by Toan Nguyen Van on 03/29/13.
//  Copyright (c) 2013 ccinteg. All rights reserved.
//

#import "CheckPart.h"
#import "IOKitLib.h"

#import "AppDelegate.h"
#import "MainTestViewController.h"
#import "iDevice.h"
#import "Utilities.h"
#import "IDeviceExt.h" 
#import <MediaPlayer/MediaPlayer.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import <Social/SLRequest.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>

#import <mach/mach.h>
#import <mach/mach_host.h>


#include <objc/runtime.h>//list app




#define CHECKPART_STARTED 1
#define CHECKPART_RUNNING 2
#define CHECKPART_FINISHED 3

#define NI(i) [NSNumber numberWithInt:i]

#define CHECKPARTDEBUG
#if defined(CHECKPARTDEBUG) || defined(DEBUG_ALL)
#   define CheckPartLog(BachUng, ...) NSLog((@"%s[Line %d] " BachUng), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define CheckPartLog(...)
#endif


@implementation CheckPart
@synthesize key;
@synthesize finishGetInfo;

- (id) init
{
    self = [super init];
    key = @"CheckPart";
    deviceInfo = [[UDIDClass alloc] init];
    installProfile = NO;
    dicDataOnline = Nil;
    strFMI = Nil;
    strGUID = Nil;
    finishGetInfo = 0;
    
    float mode = [getPhoneModal(2) floatValue];
    CheckPartLog(@"modecheck:%f",mode);
    BOOL isIP5 = NO;
    if(mode == (float)5.1 || mode == (float)5.2)
        isIP5 = YES;
    dicColorName = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                    @"Space Gray",@"aeb1b8",
                    @"Space Gray",@"b9b7ba",
                    @"White Silver",@"dadcdb",
                    @"Gold",@"e1ccb7",
                    @"Rose Gold",@"e4c1b9",
                    @"Space Gray",@"b4b5b9",
                    @"Gold",@"e1ccb5",
    isIP5?@"White":@"Silver",@"d7d9d8",
                    @"Gold",@"d4c5b3",
                    @"White",@"f5f4f7",
                    @"Pink",@"fe767a",
                    @"Yellow",@"faf189",
                    @"Blue",@"46abe0",
                    @"Green",@"a1e877",
                    @"Black",@"99989b",
                    @"Black",@"1", //iphone7
                    @"Silver",@"2",//iphone7
                    @"Gold",@"3",//iphone7
                    @"Rose Gold",@"4",//iphone7
                    @"Jet Black",@"5",//iphone7
                    @"Red",@"6",//iphone7
                    nil];

    return self;
}

- (void) dealloc
{
    if(dicColorName)
    {
        dicColorName= Nil;
    }
    if(strGUID)
    {
        strGUID = Nil;
    }
    if(deviceInfo)
    {
        deviceInfo = Nil;
    }
    if (dicDataOnline)
    {
        dicDataOnline = Nil;
    }
}

- (void) checkPartTimeOut
{
    if(status != CHECKPART_FINISHED)
    {
        CheckPartLog(@"[CHECKPART] ===================== Time out");
        [self failedCheck:@"Time out"];
    }
}

- (void) successCheck:(NSString*)desc
{
    if(status != CHECKPART_FINISHED)
    {
        status = CHECKPART_FINISHED;
        [iDevice completedTest:key isPass:YES desc:desc];
    }
}

- (void) failedCheck:(NSString*)desc
{
    if(status != CHECKPART_FINISHED)
    {
        status = CHECKPART_FINISHED;
        [iDevice completedTest:key isPass:NO desc:desc];
    }
}

// This function is started when Master Linux request
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param
{
    status = CHECKPART_STARTED;
    [self performSelector:@selector(checkPartTimeOut) withObject:nil afterDelay:5];
    NSString *data = [self getInfo];
    [self successCheck:data];
}

- (NSString*) getInfo
{
    NSString *info = @"Unknown";
    
    info = [NSString stringWithFormat:@"Product Name:%@",[getPhoneModal(3) stringByReplacingOccurrencesOfString:@"," withString:@"."]];
    
    info = [NSString stringWithFormat:@"%@, GDS UID:%@",info,[self getGUID]];

    
    
//    info = [NSString stringWithFormat:@"%@, Product Type:%@",info,[getPhoneModal(0) stringByReplacingOccurrencesOfString:@"," withString:@"."]];
//    NSString *Capacity = [self getCapacity];
//    info = [NSString stringWithFormat:@"%@, Capacity:%@",info,Capacity];
//    int total = [Capacity intValue];
//    if(total > 0)
//    {
//        float percen = [self getFreeCapacity];
//        percen = percen*100.0/total;
//        info = [NSString stringWithFormat:@"%@, Free Capacity:%.0f%%",info,percen];
//    }
//    info = [NSString stringWithFormat:@"%@, IOS:%@",info,[self getIOS]];
//    info = [NSString stringWithFormat:@"%@, Serial No.:%@",info,[self deviceSerial]];
//    info = [NSString stringWithFormat:@"%@, Carrier:%@",info,[self getCarier]];
//    info = [NSString stringWithFormat:@"%@, Model:%@",info,[self getModelFull]];
//    info = [NSString stringWithFormat:@"%@, IMEI:%@",info,[self deviceIMEI]];
//    info = [NSString stringWithFormat:@"%@, FMI:%@",info,[self deviceFMI]];
//    info = [NSString stringWithFormat:@"%@, Brightness:%@",info,[self getBrightness]];
//    info = [NSString stringWithFormat:@"%@, Volume:%@",info,[self getVolume]];
//    info = [NSString stringWithFormat:@"%@, AirplaneMode:%@",info,[self isAirplaneMode]?@"ON":@"OFF"];
//    info = [NSString stringWithFormat:@"%@, Jailbreak:%@",info,[self checkJailbreaked]?@"ON":@"OFF"];
//    info = [NSString stringWithFormat:@"%@, CPU Usage:%.2f%%",info,[self cpu_usage]];
//   // info = [NSString stringWithFormat:@"%@, CPU Count:%d",info,[self numCPU]];
//    info = [NSString stringWithFormat:@"%@, RAM Usage:%@",info,[self RAM_memory]];
//   // info = [NSString stringWithFormat:@"%@, App:%@",info,[self getListApp]];
    CheckPartLog(@"info: %@",info);
   // [self listApp];
    return info;
}

//- (NSArray *)listApp
//{
//    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
//    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
//    NSArray *applist = [NSArray arrayWithArray:[workspace performSelector:@selector(allApplications)]];
//    return applist;
//}
//- (NSString *)getListApp
//{
//    NSString *str= @"";
//    int count = 0;
//    NSArray *list = [self listApp];
//    NSLog(@"apps: %@", list);
//    for(int i = 0;i< list.count; i++)
//    {
//        str = [NSString stringWithFormat:@"%@",[list objectAtIndex:i]];
//        if([[str lowercaseString] rangeOfString:@"com.apple"].location == NSNotFound)
//        {
//            count++;
//        }
//    }
//    
//    
//    str = [NSString stringWithFormat:@"Application sysetm(%d). Application install(%d)",list.count - count,count];
//    return str;
//}
- (float) getRamPercent
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        NSLog(@"Failed to fetch vm statistics");
    }
    
    /* Stats in bytes */
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    NSLog(@"RAM used: %u free: %u total: %u", mem_used, mem_free, mem_total);
    return roundf(mem_used*100.0/mem_total);
}

-(NSString *) RAM_memory
{
#if __LP64__
    return @"Not Support 64 bit";
#else
    
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        CheckPartLog(@"Failed to fetch vm statistics");
    }
    
    /* Stats in bytes */
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    
    int MB=1024*1024;
    float ramUse = mem_used*1.0/MB;
    float ramTotal = mem_total*1.0/MB;
    
    NSArray *na = [NSArray arrayWithObjects:NI(8),NI(16),NI(32),NI(64),NI(128),NI(256),NI(512),NI(1024),NI(2048),NI(4096),NI(8192),NI(16384),NI(32786),NI(65536),NI(131072), nil];
    
    for (NSNumber *a in na)
    {
        if([a floatValue] > ramTotal)
        {
            ramTotal = [a intValue];
            break;
        }
    }
    
    
    
    CheckPartLog(@"used: %uMB free: %uMB total: %uMB, ramTotalMax:%.0f", mem_used/MB, mem_free/MB, mem_total/MB,ramTotal);
    float pecent = (float)(ramUse*1.0/ramTotal)*100;
//    return [NSString stringWithFormat:@"%.2f%% (%.0fMB/%.0fMB)",pecent,ramUse, ramTotal];
     return [NSString stringWithFormat:@"%.2f%%",pecent];
#endif
}
- (int)numCPU
{
    size_t len;
    unsigned int ncpu;
    len = sizeof(ncpu);
    sysctlbyname ("hw.ncpu",&ncpu,&len,NULL,0);
    CheckPartLog("ncpu:%u\n", ncpu);
    return ncpu;
}

-(float) cpu_usage
{
#if __LP64__
    return 0.0;
#else

    kern_return_t           kr;
    task_info_data_t        tinfo;
    mach_msg_type_number_t  task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS)
    {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t     basic_info_th;
    uint32_t                stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS)
    {
        return -1;
    }
    
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS)
        {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE))
        {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
#endif
}
-(float) cpu_usage1
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
        // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < (int)thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

- (BOOL) checkJailbreaked
{
    BOOL isJailbreaked = NO;
    NSArray *ar = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"usr/libexec/cydia" error:nil];
    if((ar || [ar count] > 0) || [[NSFileManager defaultManager] fileExistsAtPath:@"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist"] ||
       [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist"]
       )
    {
        isJailbreaked = YES;
    }
    
    return isJailbreaked;
}

- (BOOL) isAirplaneMode
{
    UIDevice *device = [UIDevice currentDevice];
    SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
    if (![device respondsToSelector:selector]) {
        selector = NSSelectorFromString(@"_deviceInfoForKey:");
    }
    BOOL value = [[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"AirplaneMode"]] boolValue];
    return value;
}

- (NSString*) getVolume
{
    MPMusicPlayerController *iPod = [MPMusicPlayerController iPodMusicPlayer];
    int volume = iPod.volume*100;
    return [NSString stringWithFormat:@"%d%%",volume];
}
- (NSString*) getBrightness
{
    int lightNum = (int)([UIScreen mainScreen].brightness*100.0);
    return [NSString stringWithFormat:@"%d%%",lightNum];
}
- (NSString*) getCapacity
{
    uint64_t totalSpace = 0;
    
    NSError *error = nil;  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];  
     CheckPartLog(@"dictionary :\n%@", dictionary);
    if (dictionary)
    {  
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];  
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        
        float cap = ((totalSpace/1024.0)/1024.0)/1024.0;
        
        NSArray *na = [NSArray arrayWithObjects:NI(1),NI(2),NI(4),NI(8),NI(16),NI(32),NI(64),NI(128),NI(256),NI(512),NI(1024),NI(2048),NI(4096),NI(8192),NI(16384), nil];
        
        for (NSNumber *a in na)
        {
            if([a floatValue] > cap)
            {
                NSString *rsl = [NSString stringWithFormat:@"%d", [a intValue]];
                return rsl;
            }
        }
    }
    
    return @"Unknown";
}
- (float) getFreeCapacity
{
    uint64_t totalSpace = 0;
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    CheckPartLog(@" dictionary :\n%@", dictionary);
    if (dictionary)
    {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        
        float cap = ((totalSpace/1024.0)/1024.0)/1024.0;
        CheckPartLog(@" \ncapfree :%.2f", cap);
        //        NSString *rsl = [NSString stringWithFormat:@"%.2fGB", cap];
        //        return rsl;
        return cap;
    }
    
    return 0.0;
}

- (float)getStoragePecent
{
    __autoreleasing NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Storage Capacity of %.2f GB with %.1f GB Free memory available.", (totalSpace*1.0/(1024*1024*1024)), (totalFreeSpace*1.0/(1024*1024*1024)));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return roundf((totalSpace-totalFreeSpace)*100.0/totalSpace);
}


- (NSString*) getValue:(NSString *)iosearch
{
#if __LP64__
    return @"Not Support 64 bit";
#else

    mach_port_t masterPort;
    CFTypeID propID;
    unsigned int bufSize;

    kern_return_t kr = IOMasterPort(MACH_PORT_NULL, &masterPort);
    if (kr != noErr)
    {
        return NULL;
    }

    io_registry_entry_t entry = IORegistryGetRootEntry(masterPort);
    if (entry == MACH_PORT_NULL)
    {
        return NULL;
    }

    CFTypeRef prop = IORegistryEntrySearchCFProperty(entry, kIODeviceTreePlane, (__bridge CFStringRef)(iosearch), nil, kIORegistryIterateRecursively);
    if (prop == nil) return NULL;
    else propID = CFGetTypeID(prop);
    if (!propID == CFDataGetTypeID())
    {
        mach_port_deallocate(mach_task_self(), masterPort);
        return NULL;
    }

    CFDataRef propData = (CFDataRef)prop;
    if (!propData)
    {
        return NULL;
    }

    bufSize = CFDataGetLength(propData);
    if (!bufSize)
    {
        return NULL;
    }

    id p1 = [[NSString alloc] initWithBytes:CFDataGetBytePtr(propData) length:bufSize encoding:1];
    mach_port_deallocate(mach_task_self(), masterPort);

    return p1;
    return @"unknown";
#endif
}
/* ---------- getPhone Carrier -------
 <= return phone Carrier, if not inserted SIM, it returns "Unknown"
 */
- (NSString*) getCarier
{
    
    if(dicDataOnline)
    {
            //co thong tin tu web online
        if([dicDataOnline objectForKey:@"carrier"] && [[dicDataOnline objectForKey:@"carrier"] containsString:@"N/A"] == NO)
        {
            NSString *carrier = [NSString stringWithFormat:@"%@",[dicDataOnline objectForKey:@"carrier"]];
            CheckPartLog(@"carrier: %@",carrier);
            if(carrier.length>0)
                return carrier;
        }
    }

    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    NSString *cn = [[NSString stringWithFormat:@"%@", [carrier carrierName]] uppercaseString];
    
    if((!cn) || [cn length] < 1 || [cn rangeOfString:@"NULL"].location != NSNotFound)
    {
        CheckPartLog(@"[CheckPart] CARIER : UnKnown");
        return @"N/A";
    }
    else
    {
        CheckPartLog(@"[CheckPart] CARIER : %@",cn);
        return cn;
    }
}

- (NSString *)getDeviceIP
{
    NSString *address = @"Unknown";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);    // retrieve the current interfaces - returns 0 on success
    if (success == 0)
    {
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                NSString *temp = [NSString stringWithUTF8String:temp_addr->ifa_name];
                if([temp isEqualToString:@"en0"])
                {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);// Free memory
    return address;
}

- (NSString *) getSerialNumber
{
    NSString *serialNumber = @"Unknown";
    void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
    if (IOKit)
    {
        mach_port_t *kIOMasterPortDefault = dlsym(IOKit, "kIOMasterPortDefault");
        CFMutableDictionaryRef (*IOServiceMatching)(const char *name) = dlsym(IOKit, "IOServiceMatching");
        mach_port_t (*IOServiceGetMatchingService)(mach_port_t masterPort, CFDictionaryRef matching) = dlsym(IOKit, "IOServiceGetMatchingService");
        CFTypeRef (*IORegistryEntryCreateCFProperty)(mach_port_t entry, CFStringRef key, CFAllocatorRef allocator, uint32_t options) = dlsym(IOKit, "IORegistryEntryCreateCFProperty");
        kern_return_t (*IOObjectRelease)(mach_port_t object) = dlsym(IOKit, "IOObjectRelease");
        return @" ";
        if (kIOMasterPortDefault && IOServiceGetMatchingService && IORegistryEntryCreateCFProperty && IOObjectRelease)
        {
            mach_port_t platformExpertDevice = IOServiceGetMatchingService(*kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
            if (platformExpertDevice)
            {
                CFTypeRef platformSerialNumber = IORegistryEntryCreateCFProperty(platformExpertDevice, CFSTR("IOPlatformSerialNumber"), kCFAllocatorDefault, 0);
                if (CFGetTypeID(platformSerialNumber) == CFStringGetTypeID())
                {
                    serialNumber = [NSString stringWithString:(__bridge NSString*)platformSerialNumber];
                    CFRelease(platformSerialNumber);
                }
                IOObjectRelease(platformExpertDevice);
            }
        }
        dlclose(IOKit);
    }
    CheckPartLog(@"serialNumber:%@",serialNumber);
    return serialNumber;
}

- (NSString*)getSerialNumber1
{
#if __LP64__
    return @"Unknown";
#else
    CFTypeRef serialNumberAsCFString=nil;
    io_service_t platformExpert = IOServiceGetMatchingService( kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
    if (platformExpert)
    {
        serialNumberAsCFString = IORegistryEntryCreateCFProperty( platformExpert, CFSTR(kIOPlatformSerialNumberKey), kCFAllocatorDefault, 0);
    }
    IOObjectRelease(platformExpert);
    NSString *serial = [[NSString alloc] initWithFormat:@"%@",serialNumberAsCFString];
    CheckPartLog(@"serial : %@",serial);
    if(serial)
        return serial;
    else
        return @"";
#endif
}

- (NSString*)getIOS
{
    NSString *currentIOS = [UIDevice currentDevice].systemVersion;
    CheckPartLog(@"%s getIOS : %@",__FUNCTION__,currentIOS);
    return currentIOS;
}

- (NSString*)getModel
{
    NSString *model = [NSString stringWithFormat:@"%@",[UIDevice currentDevice].model];
    CheckPartLog(@"%s model : %@",__FUNCTION__,model);
    return model;
}
- (NSString*)getModelFull
{
    UIDevice *device = [UIDevice currentDevice];
    SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
    if (![device respondsToSelector:selector]) {
        selector = NSSelectorFromString(@"_deviceInfoForKey:");
    }
    if ([device respondsToSelector:selector])
    {
        return [NSString stringWithFormat:@"%@%@",[device performSelector:selector withObject:@"ModelNumber"],[device performSelector:selector withObject:@"RegionInfo"]];
    }
    return @"";
}
- (NSString*)getColor
{
        NSString *color1 = [NSString stringWithFormat:@"%@",[self getColorCode]];
        NSString *key1 = [color1 stringByReplacingOccurrencesOfString:@"#" withString:@""];
        CheckPartLog(@"color:%@, key:%@",color1,key1);
        if ([[dicColorName allKeys] containsObject:key1])
        {
            CheckPartLog(@"color:%@, key:%@ name:%@",color1,key1,[dicColorName objectForKey:key1]);
            return [NSString stringWithFormat:@"%@",[dicColorName objectForKey:key1]];
        }
        return color1;
}
- (NSString*)getColorCode
{
    UIDevice *device = [UIDevice currentDevice];
    SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
    if (![device respondsToSelector:selector]) {
        selector = NSSelectorFromString(@"_deviceInfoForKey:");
    }
    if ([device respondsToSelector:selector])
    {
            //return [NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"DeviceColor"]];
        
        NSString *color1 = [NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"DeviceEnclosureColor"]];
        return color1;
    }
    return @"";
}

- (NSString *) deviceSerial
{
    NSString *serial = [self getSerialNumber];
    CheckPartLog(@"serial: %@",serial);
    if([serial length]>10)
    {
        return serial;
    }
    else
    {
        serial = [self getSerialNumber1];
        CheckPartLog(@"serial1: %@",serial);
        if([serial length]>10)
        {
            return serial;
        }
        else
        {

            if(dicDataOnline)
            {
                //co thong tin tu web online
                serial = [NSString stringWithFormat:@"%@",[dicDataOnline objectForKey:@"serial_number"]];
                CheckPartLog(@"serial2: %@",serial);
                return serial;
            }
        }
    }
    return @"NA";
}
- (NSString *) deviceFMI
{
    if(AppShare.iOS < (float)8.0)
    {
        if(strFMI==Nil)
        {
            NSString *strURL = [NSString stringWithFormat: @"http://apple.BachUngdatatech.com/checkfmi.php/?sn=%@&product=%@",[self deviceSerial], [UIDevice currentDevice].model];
            CheckPartLog(@"strURL:->%@<-",strURL);
            NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
            NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
            CheckPartLog(@"->%@<-",strResult);

            if([[strResult uppercaseString] rangeOfString:@"OFF"].location != NSNotFound)
                strFMI = [[NSString alloc] initWithFormat:@"OFF"];
            else strFMI = [[NSString alloc] initWithFormat:@"ON"];

        }
        return strFMI;
    }
    if(dicDataOnline)
    {
        //co thong tin tu web online
        NSString *FMI = [NSString stringWithFormat:@"%@",[dicDataOnline objectForKey:@"fmip"]];
        return FMI;
    }
    return @"NA";
}
- (NSString *) deviceUniqueid
{
    if(dicDataOnline)
    {
        NSString *Uniqueid = [NSString stringWithFormat:@"%@",[dicDataOnline objectForKey:@"uniqueid"]];
        return Uniqueid;
    }
    return @"NA";
}
- (NSString *) deviceIMEI
{
    NSString *imei = [[UIDevice currentDevice] imei];
    
    if([imei length] > 2)
        return imei;
    if(dicDataOnline)
    {
        //co thong tin tu web online
        NSString *imei = [NSString stringWithFormat:@"%@",[dicDataOnline objectForKey:@"imei"]];
        return imei;
    }
    return @"NA";
}

-(NSString *)getAllInfo
{
   
    UIDevice *device = [UIDevice currentDevice];
    SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
    if (![device respondsToSelector:selector]) {
        selector = NSSelectorFromString(@"_deviceInfoForKey:");
    }
//    if ([device respondsToSelector:selector])
//    {
//        return [NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"WifiVendor"]];
//    }
//    return @"";
    
    
    
    /*
     ActiveWirelessTechnology
     AirplaneMode
     assistant
     BasebandCertId
     BasebandChipId
     BasebandPostponementStatus
     BasebandStatus
     BatteryCurrentCapacity
     BatteryIsCharging
     BluetoothAddress
     BoardId
     BootNonce
     BuildVersion
     CertificateProductionStatus
     CertificateSecurityMode
     ChipID
     CompassCalibrationDictionary
     CPUArchitecture
     DeviceClass
     DeviceColor
     DeviceEnclosureColor
     DeviceEnclosureRGBColor
     DeviceName
     DeviceRGBColor
     DeviceSupportsFaceTime
     DeviceVariant
     DeviceVariantGuess
     DiagData
     dictation
     DiskUsage
     EffectiveProductionStatus
     EffectiveProductionStatusAp
     EffectiveProductionStatusSEP
     EffectiveSecurityMode
     EffectiveSecurityModeAp
     EffectiveSecurityModeSEP
     FirmwarePreflightInfo
     FirmwareVersion
     FrontFacingCameraHFRCapability
     HardwarePlatform
     HasSEP
     HWModelStr
     Image4Supported
     InternalBuild
     InverseDeviceID
     ipad
     MixAndMatchPrevention
     MLBSerialNumber
     MobileSubscriberCountryCode
     MobileSubscriberNetworkCode
     ModelNumber
     PartitionType
     PasswordProtected
     ProductName
     ProductType
     ProductVersion
     ProximitySensorCalibrationDictionary
     RearFacingCameraHFRCapability
     RegionCode
     RegionInfo
     SDIOManufacturerTuple
     SDIOProductInfo
     SerialNumber
     SIMTrayStatus
     SoftwareBehavior
     SoftwareBundleVersion
     SupportedDeviceFamilies
     SupportedKeyboards
     telephony
     UniqueChipID        
     UniqueDeviceID        
     UserstrongedDeviceName        
     wifi        
     WifiVendor        
     
     
     */
    
    NSLog(@"%s start",__FUNCTION__);
//    UIDevice *device = [UIDevice currentDevice];
//    SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
    if (![device respondsToSelector:selector]) {
        selector = NSSelectorFromString(@"_deviceInfoForKey:");
    }
    if ([device respondsToSelector:selector])
    {
        NSLog(@"ActiveWirelessTechnology: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"ActiveWirelessTechnology"]]);
        NSLog(@"AirplaneMode: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"AirplaneMode"]]);
        
        
        NSLog(@"assistant: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"assistant"]]);
        
        NSLog(@"BasebandCertId: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"BasebandCertId"]]);
        
        NSLog(@"BasebandChipId: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"BasebandChipId"]]);
        
        NSLog(@"BasebandPostponementStatus: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"BasebandPostponementStatus"]]);
        
        NSLog(@"BasebandStatus: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"BasebandStatus"]]);
        
        NSLog(@"BatteryCurrentCapacity: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"BatteryCurrentCapacity"]]);
        
        NSLog(@"BatteryIsCharging: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"BatteryIsCharging"]]);
        
        NSLog(@"BluetoothAddress: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"BluetoothAddress"]]);
        
        NSLog(@"BoardId: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"BoardId"]]);
        
        NSLog(@"BootNonce: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"BootNonce"]]);
        
        NSLog(@"BuildVersion: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"BuildVersion"]]);
        
        NSLog(@"CertificateProductionStatus: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"CertificateProductionStatus"]]);
        
        NSLog(@"CertificateSecurityMode: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"CertificateSecurityMode"]]);
        
        NSLog(@"ChipID: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"ChipID"]]);
        
        NSLog(@"CompassCalibrationDictionary: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"CompassCalibrationDictionary"]]);
        
        NSLog(@"CPUArchitecture: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"CPUArchitecture"]]);
        
        NSLog(@"DeviceClass: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"DeviceClass"]]);
        
        NSLog(@"DeviceColor: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"DeviceColor"]]);
        
        NSLog(@"DeviceEnclosureColor: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"DeviceEnclosureColor"]]);
        
        NSLog(@"DeviceEnclosureRGBColor: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"DeviceEnclosureRGBColor"]]);
        
        NSLog(@"DeviceName: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"DeviceName"]]);
        
        NSLog(@"DeviceRGBColor: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"DeviceRGBColor"]]);
        
        NSLog(@"DeviceSupportsFaceTime: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"DeviceSupportsFaceTime"]]);
        
        NSLog(@"DeviceVariant: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"DeviceVariant"]]);
        
        NSLog(@"DeviceVariantGuess: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"DeviceVariantGuess"]]);
        
        NSLog(@"DiagData: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"DiagData"]]);
        
        NSLog(@"dictation: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"dictation"]]);
        
        NSLog(@"DiskUsage: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"DiskUsage"]]);
        
        NSLog(@"EffectiveProductionStatus: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"EffectiveProductionStatus"]]);
        
        NSLog(@"EffectiveProductionStatusAp: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"EffectiveProductionStatusAp"]]);
        
        NSLog(@"EffectiveProductionStatusSEP: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"EffectiveProductionStatusSEP"]]);
        
        NSLog(@"EffectiveSecurityMode: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"EffectiveSecurityMode"]]);
        
        NSLog(@"EffectiveSecurityModeAp: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"EffectiveSecurityModeAp"]]);
        
        NSLog(@"EffectiveSecurityModeSEP: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"EffectiveSecurityModeSEP"]]);
        
        NSLog(@"FirmwarePreflightInfo: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"FirmwarePreflightInfo"]]);
        
        NSLog(@"FirmwareVersion: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"FirmwareVersion"]]);
        
        NSLog(@"FrontFacingCameraHFRCapability: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"FrontFacingCameraHFRCapability"]]);
        
        NSLog(@"HardwarePlatform: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"HardwarePlatform"]]);
        
        NSLog(@"HasSEP: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"HasSEP"]]);
        
        NSLog(@"HWModelStr: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"HWModelStr"]]);
        
        NSLog(@"Image4Supported: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"Image4Supported"]]);
        
        NSLog(@"InternalBuild: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"InternalBuild"]]);
        
        NSLog(@"InverseDeviceID: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"InverseDeviceID"]]);
        
        NSLog(@"ipad: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"ipad"]]);
        
        NSLog(@"MixAndMatchPrevention: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"MixAndMatchPrevention"]]);
        
        NSLog(@"MLBSerialNumber: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"MLBSerialNumber"]]);
        
        NSLog(@"MobileSubscriberCountryCode: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"MobileSubscriberCountryCode"]]);
        
        NSLog(@"MobileSubscriberNetworkCode: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"MobileSubscriberNetworkCode"]]);
        
        NSLog(@"ModelNumber: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"ModelNumber"]]);
        
        NSLog(@"PartitionType: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"PartitionType"]]);
        
        NSLog(@"PasswordProtected: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"PasswordProtected"]]);
        
        NSLog(@"ProductName: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"ProductName"]]);
        
        NSLog(@"ProductType: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"ProductType"]]);
        
        NSLog(@"ProductVersion: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"ProductVersion"]]);
        
        NSLog(@"ProximitySensorCalibrationDictionary: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"ProximitySensorCalibrationDictionary"]]);
        
        NSLog(@"RearFacingCameraHFRCapability: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"RearFacingCameraHFRCapability"]]);
        
        NSLog(@"RegionCode: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"RegionCode"]]);
        
        NSLog(@"RegionInfo: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"RegionInfo"]]);
        
        NSLog(@"SDIOManufacturerTuple: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"SDIOManufacturerTuple"]]);
        
        NSLog(@"SDIOProductInfo: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"SDIOProductInfo"]]);
        
        NSLog(@"SerialNumber: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"SerialNumber"]]);
        
        NSLog(@"SIMTrayStatus: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"SIMTrayStatus"]]);
        
        NSLog(@"SoftwareBehavior: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"SoftwareBehavior"]]);
        
        NSLog(@"SoftwareBundleVersion: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"SoftwareBundleVersion"]]);
        
        NSLog(@"SupportedDeviceFamilies: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"SupportedDeviceFamilies"]]);
        
        NSLog(@"SupportedKeyboards: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"SupportedKeyboards"]]);
        
        NSLog(@"telephony: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"telephony"]]);
        
        NSLog(@"UniqueChipID: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"UniqueChipID"]]);
        
        NSLog(@"UniqueDeviceID: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"UniqueDeviceID"]]);
        
        NSLog(@"UserstrongedDeviceName: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"UserstrongedDeviceName"]]);
        
        NSLog(@"wifi: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"wifi"]]);
        
        NSLog(@"WifiVendor: %@",[NSString stringWithFormat:@"%@",[device performSelector:selector withObject:@"WifiVendor"]]);
        
    }
    NSLog(@"%s End",__FUNCTION__);
     return @"";
}
#pragma mark -
#pragma mark Get info device in web

//- (void)startGetInfo
//{
//    
//    NSString *str = [self getDID];
//    if(str==Nil)
//        [self performSelector:@selector(startGetInfo) withObject:Nil afterDelay:1];
//    else
//    {
//        CheckPartLog(@"iGUID ->%@<-",str);
//        [AppShare.viewController startRun];// chuyen tu getinfoOnliune wa day
//    }
//}
- (void) getInfoOnline
{
    isGetInforOfWeb = NO;
    NSString *idid = [self getDID];
    CheckPartLog(@"idid: ->%@<-",idid);
    idid = [idid stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self performSelector:@selector(detectInfoOnWeb) withObject:Nil afterDelay:2];
}




- (void)detectInfoOnWeb
{
    NSString *identify =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSUserDefaults *saveApp = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dicsave = [saveApp objectForKey:identify];
    NSLog(@"%s identify:%@ dic:%@",__FUNCTION__,identify,dicsave);
    if(dicsave==Nil || [dicsave objectForKey:@"carrier"]==Nil)////if(dicsave==Nil)
    {
        NSString *data = [self getInfoOnWeb];
        CheckPartLog(@"->%@<-",data);
        if(data.length < 10)// khong lay duoc thong tin
        {
            if(installProfile == NO)
            {
                installProfile = YES;
                [self intallProfile];
            }
            [self performSelector:@selector(detectInfoOnWeb) withObject:nil afterDelay:2];
        }
        else
        {
            NSDictionary *dic = [AppShare diccionaryFromJsonString:data];
            if(dic)
            {
                CheckPartLog(@"data\n%@\n",dic);
                AppLog(@"set Info OnWeb from checkpart1");
                isGetInforOfWeb = YES;
                [self setInfoOnWeb:dic forsave:YES];
//                [AppShare.parentView updateInfo];
                    // 01-08-2017 :tam khoa hien thong bao ben duoi, co cai thong bao nay se nhanh hon nhung anh thinh khong muon nen khoa lai
                    // [self performSelector:@selector(showNoticalWeb) withObject:nil afterDelay:1];
            }
            else
            {
                [self performSelector:@selector(detectInfoOnWeb) withObject:Nil afterDelay:2];
            }
        }
    }
    else
    {
        AppLog(@"set Info OnWeb from checkpart2 data tu save");
        
         [self setInfoOnWeb:dicsave forsave:YES];
        CheckPartLog(@"data\n%@\n",dicsave);
//        [AppShare.parentView updateInfo];
        [self performSelector:@selector(showNoticalWeb) withObject:nil afterDelay:1];
    }
}
- (void)setInfoOnWeb:(NSDictionary *)dic forsave:(BOOL)save
{
    
    
    dicDataOnline = [[NSMutableDictionary alloc] initWithDictionary:dic];
    if(save==YES)
    {
        NSUserDefaults *saveApp = [NSUserDefaults standardUserDefaults];
        NSString *identify = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];;
        CheckPartLog(@"identify:%@\n%@",identify,dicDataOnline);
        [saveApp setObject:dicDataOnline forKey:identify];
        [saveApp synchronize];
    }
    if(finishGetInfo==0)
    {
        finishGetInfo = 1;// da lay duoc info
    }
}

-(void)showNoticalWeb
{
     CheckPartLog();
    [AppShare showNotical:@"Click me to Open"];
    [AppShare performSelector:@selector(showNotical:) withObject:@"Click me to Open" afterDelay:4];
//    [AppShare showNotical:@"Click me to Open"];
//    if(AppShare.isActive==NO)
//    {
//            // [self performSelector:@selector(showNoticalWeb) withObject:nil afterDelay:4];
//    }
//    else
//    {
//        if(finishGetInfo==1)
//        {
//            finishGetInfo = 2;//da start test
//        }
//    }
}
- (NSString *) getGUID
{
    NSString *mac = [self convertMac];
    NSString *date = [self convertDate];
    if(mac==Nil)
        return mac;
    if(strGUID==Nil)
    {
        NSString *data = [NSString stringWithFormat:@"%@ %@ %@",mac,getPhoneModal(0),date];
        data = [self mahoa:data num:2];
        strGUID = [[NSString alloc] initWithFormat:@"%@",data];
    }
    return strGUID;
}
- (NSString*)convertDate
{
    NSDate *today = [NSDate date];
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:today];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:today];
    NSTimeInterval interval1 = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval1 sinceDate:today];
    AppLog(@"today: %@", destinationDate);
    
    NSTimeInterval interval = [destinationDate timeIntervalSince1970];
   // AppLog(@"intInterval %d", (int)interval);
    NSString *hexInterval = [NSString stringWithFormat:@"%08x", (int)interval];
    AppLog(@"hexInterval %@", hexInterval);
    unsigned intInterval;
    NSScanner *scanner = [NSScanner scannerWithString:hexInterval];
    [scanner scanHexInt:&intInterval];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    AppLog(@"date  %@", date);
    return hexInterval;
}

- (NSString *) convertMac
{
    return [deviceInfo convertMac];
}
- (NSString *)getDID
{
    if(dicDataOnline)
    {
        if ([dicDataOnline objectForKey:@"key"])
        {
        return [NSString stringWithFormat:@"%@",[dicDataOnline objectForKey:@"key"]];
        }
    }
    return [deviceInfo getIDID];
}

#pragma mark -
#pragma mark method use for app
- (NSString*)mahoa:(NSString*)data num:(int)num
{
    data = [data stringByReplacingOccurrencesOfString:@"," withString:@""];
    data = [data stringByReplacingOccurrencesOfString:@" " withString:@"GREY"];
    data = [data stringByReplacingOccurrencesOfString:@"-" withString:@""];
    // NSLog(@"lenght:%ld",data.length);
    data = [data uppercaseString];
    //NSLog(@"dataEnd:%@",data);
    NSString *str=  [self encrypt:(NSString*)data];
    //NSLog(@"datastr:%@",str);
    return str;
}


-(NSString *) encrypt:(NSString*)originalMessage
{
    int size = (int)[originalMessage length];
    unichar message[size];
    for (int i = 0; i < [originalMessage length]; i++){
        char character = [originalMessage characterAtIndex:i];
        message[i] = [self encryptChar : character];
    }
    return [[NSString alloc] initWithCharacters:message length:size];
}
#define DEVISOR 26
#define DEVISOR_NUMBER 10
#define LOWER_CASE_OFFSET 97
#define UPPER_CASE_OFFSET 65
#define NUMBER_OFFSET 48
#define DEFAULT_CIPHER_VALUE 1
-(unichar) encryptChar:(unichar) character {
    
    unichar shiftedChar = character + DEFAULT_CIPHER_VALUE;
    
    //Else if character is captital A..Z
    if ((character > 64)&&(character<91)){
        return ((shiftedChar-UPPER_CASE_OFFSET)%DEVISOR)+UPPER_CASE_OFFSET;
    }
    //Else if character is captital 0..9
    else if ((character > 47)&&(character<58)){
        return ((shiftedChar-NUMBER_OFFSET)%DEVISOR_NUMBER)+ NUMBER_OFFSET;
    }
    //Else do not encrypt character
    else {
        return character;
    }
}

/*
 intallProfile: link to web get sery , and FMI ....
 khi chua lay duoc se gui ve Null
 */
- (void)intallProfile
{
    installProfile = YES;
    AppShare.isShowNotification = NO;
    NSString *url = [NSString stringWithFormat:@"http://masstrade.io/udid?key=%@",[self getDID]];
    CheckPartLog(@"%@",url);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
   
}

- (void)detectInfoFromCliboard
{
    
    if(installProfile == YES && AppShare.isActive)
    {
        return;
    }
    NSString *data = [AppShare.parentView readFromClip];
    CheckPartLog(@"->%@<-",data);
    if([[data lowercaseString] rangeOfString:@"quycodoc"].location != NSNotFound)// khong lay duoc thong tin
    {
        if(installProfile == NO)
        {
            installProfile = YES;
            [self intallProfile];
        }
        [self performSelector:@selector(detectInfoFromCliboard) withObject:nil afterDelay:2];
    }
    else
    {
        CheckPartLog(@"convert data")
        NSDictionary *dic = [AppShare diccionaryFromJsonString:data];
        if(dic)
        {
            CheckPartLog(@"data\n%@\n",dic);
            
             [self setInfoOnWeb:dic forsave:YES];
//            [AppShare.viewController updateInfo];
            [self performSelector:@selector(showNoticalWeb) withObject:nil afterDelay:1];
            
        }
        else
        {
            [self performSelector:@selector(detectInfoFromCliboard) withObject:Nil afterDelay:2];
        }
    }
}


/*
 getinfoOnWeb: link to web get sery , and FMI ....
 khi chua lay duoc se gui ve Null, khi co data tra ve json
 */
- (NSString*)getInfoOnWeb
{
    NSString *strURL = [NSString stringWithFormat:@"http://masstrade.io/service/getserial?key=%@&model=%@",[self getDID],[[NSString alloc] initWithFormat:@"%@",[self getModelFull]]];
    CheckPartLog(@"%@",strURL);
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    CheckPartLog(@"->%@<-",strResult);
    return strResult;
}
@end
