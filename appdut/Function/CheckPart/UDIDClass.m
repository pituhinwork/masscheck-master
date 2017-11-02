//
//  UDIDClass.m
//  IVERIFY
//
//  Created by BachUng on 9/21/15.
//  Copyright © 2015MaTran All rights reserved.
//
#import "UDIDClass.h"
#define IFT_ETHER 0x6
#import <ifaddrs.h>
#include <sys/socket.h>
#import <arpa/inet.h>

//#include <sys/sysctl.h>
//#include <net/if.h>
#include <net/if_dl.h>

#import "IDeviceExt.h"

#import "ExArp.h"
#import "SimplePingHelper.h"
#import "NSString+MD5Addition.h"


@implementation UDIDClass

- (id) init
{
    
    IDIDDeviceString = Nil;
    mac = Nil;
    [self pingLocal];
    return self;
}

- (void) dealloc
{
}


- (void) pingLocal
{
    NSString *ipdevice = [self localIPAddress];
//    NSLog(@"%s IPaddress: %@",__FUNCTION__,[self getIPAddress]);
    NSLog(@"%s IPLocalAddress: %@",__FUNCTION__,ipdevice);
    [SimplePingHelper ping:ipdevice target:self sel:@selector(pingResult:adress:)];
}

- (void)pingResult:(NSNumber*)success adress:(NSString*)address
{
    NSString *macaddress = [ExArp ip2mac:(char*)[address UTF8String]];
    NSLog(@"%s macaddress:%@",__FUNCTION__,macaddress);
    if(macaddress == nil)
        macaddress = [[UIDevice currentDevice] serialnumber];
//    if(macaddress.length < 7)
//        macaddress = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//
    mac = [[NSString alloc] initWithString:macaddress];

    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    
    NSLog(@"%s address:%@ mac: %@ sery: %@",__FUNCTION__,address,macaddress,[[UIDevice currentDevice] serialnumber]);

    IDIDDeviceString = [[NSString alloc] initWithFormat:@"%@",[stringToHash stringFromMD5]];
}

- (NSString *)getMac
{
    return mac;
}

- (NSString *)getIDID
{
    return [[[[UIDevice currentDevice] identifierForVendor] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}
- (NSString *)convertMac
{
    if(mac)
    {
        NSArray* foo = [mac componentsSeparatedByString: @":"];
        if(foo.count > 2)
        {
            NSString* macaddress = @"";
            NSString *str = @"";
            for(int i = 0;i<foo.count;i++)
            {
                str=[foo objectAtIndex:i];
                macaddress = [NSString stringWithFormat:@"%@%@",macaddress,str.length>1?str:[NSString stringWithFormat:@"0%@",str]];
            }
            return macaddress;
        }
    }
    return mac;
}


- (NSString*) getIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces))
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6)
            {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"])
                {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                }
                else if([name isEqualToString:@"pdp_ip0"])
                {
                    // Interface is the cell connection on the iPhone
                    cellAddress = addr;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}


- (NSString *) localIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    
    if (success == 0)
    {
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            // check if interface is en0 which is the wifi connection on the iPhone
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                NSString *temp = [NSString stringWithUTF8String:temp_addr->ifa_name];
                if([temp isEqualToString:@"en0"])
                {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    //self.netMask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    return address;
}
// router info
//- (NSDictionary *)fetchSSIDInfo
//{
//    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
//    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
//
//    NSDictionary *SSIDInfo;
//    for (NSString *interfaceName in interfaceNames) {
//        SSIDInfo = CFBridgingRelease(
//                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
//        NSLog(@"%s: %@   %@", __func__, interfaceName, SSIDInfo);
//
//        BOOL isNotEmpty = (SSIDInfo.count > 0);
//        if (isNotEmpty) {
//            break;
//        }
//    }
//    return SSIDInfo;
//}



@end
