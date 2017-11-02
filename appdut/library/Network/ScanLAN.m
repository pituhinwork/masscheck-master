//
//  ScanLAN.m
//  LAN Scan
//
//  Created by Mongi Zaidi on 24 February 2014.
//  Copyright (c) 2014 Smart Touch. All rights reserved.
//

#import "AppDelegate.h"
#import "ScanLAN.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <netdb.h>
#import "SimplePingHelper.h"
#import <CFNetwork/CFNetwork.h>
@interface ScanLAN ()

@property NSString *localAddress;
@property NSString *baseAddress;
@property NSString *broadcastAddress;
@property NSInteger currentHostAddress;
@property NSTimer *timer;
@property NSString *netMask;
@property NSInteger baseAddressEnd;
@property NSInteger timerIterationNumber;
@property NSInteger SoMay;

@end

@implementation ScanLAN

- (id)initWithDelegate:(id<ScanLANDelegate>)delegate
{
   // AppLog(@"init scanner");
    self = [super init];
    if(self)
    {
		self.delegate = delegate;
    }
    
    self.SoMay = 0;
    return self;
}

- (void)startTest
{
    
    AppLog();
    FlagScan = YES;
    self.localAddress = [self localIPAddress];//get local address and netmask
    a=0; b=0; c=0; d=0;self.timerIterationNumber = 0;
    self.baseAddress = @"";
    NSArray *loc = [self.localAddress componentsSeparatedByString:@"."];
    NSArray *net = [self.netMask componentsSeparatedByString:@"."];
    if ([self isIpAddressValid:self.localAddress] && (loc.count == 4) && (net.count == 4))
    {
        for (int i = 0; i<4; i++)
        {
            int and = [[loc objectAtIndex:i] integerValue] & [[net objectAtIndex:i] integerValue];
            
            if (!self.baseAddress.length)
            {
                self.baseAddress = [NSString stringWithFormat:@"%d", and];
            }
            else
            {
                self.baseAddress = [NSString stringWithFormat:@"%@.%d", self.baseAddress, and];
                self.currentHostAddress = and;
                self.baseAddressEnd = and;
            }
        }
        
        // Strings to in_addr:
        struct in_addr localAddr;
        struct in_addr netmaskAddr;
        inet_aton([self.localAddress UTF8String], &localAddr);
        inet_aton([self.netMask UTF8String], &netmaskAddr);
        localAddr.s_addr |= ~(netmaskAddr.s_addr);
        self.broadcastAddress = [NSString stringWithUTF8String:inet_ntoa(localAddr)];
        
        // tinh lai so may trên duong mang
        AppLog(@"\nbaseAddress:%@, broadcastAddress:%@, localAddress:%@,netMask:%@",self.baseAddress,self.broadcastAddress,self.localAddress,self.netMask);
        NSArray *aAddress = [self.baseAddress componentsSeparatedByString:@"."];
        NSArray *aBroadcast = [self.broadcastAddress componentsSeparatedByString:@"."];
        //        NSArray *anetMask = [self.netMask componentsSeparatedByString:@"."];
        if (aAddress.count == 4 && aBroadcast.count == 4)
        {
            a = [[aBroadcast objectAtIndex:0] integerValue] - [[aAddress objectAtIndex:0] integerValue];
            b = [[aBroadcast objectAtIndex:1] integerValue] - [[aAddress objectAtIndex:1] integerValue];
            c = [[aBroadcast objectAtIndex:2] integerValue] - [[aAddress objectAtIndex:2] integerValue];
            d = [[aBroadcast objectAtIndex:3] integerValue] - [[aAddress objectAtIndex:3] integerValue];
            AppLog(@"a=%d, b=%d, c=%d, d=%d",a,b,c,d);
            self.SoMay = (((a*256 + b)*256 + c)*256) + d+1 -2;
            AppLog(@"So May:%d",self.SoMay);
        }
        I1=0;I2=0;I3=0;I4=0;
        NSArray *abaseAddress = [self.baseAddress componentsSeparatedByString:@"."];
        I1 = [[abaseAddress objectAtIndex:0] integerValue];
        I2 = [[abaseAddress objectAtIndex:1] integerValue];
        I3 = [[abaseAddress objectAtIndex:2] integerValue];
        I4 = [[abaseAddress objectAtIndex:3] integerValue];
        
        int i = 0;
        while(i<self.SoMay)
        {
            self.currentHostAddress++;
            
            if(self.currentHostAddress > 255)
            {
                self.currentHostAddress = 0;
                I3++;
                if(I3>255)
                {
                    I3 = 0;
                    I2++;
                    if(I2>255)
                    {
                        I2 = 0;
                        I1++;
                        if(I1>255)
                        {
                            break;
                        }
                    }
                }
            }
            I4 = self.currentHostAddress;
            
            
            NSString *address = [NSString stringWithFormat:@"%d.%d.%d.%d",I1,I2,I3,I4];
            if ([address isEqualToString:self.broadcastAddress])
            {
                break;
            }
            else
            {
                [SimplePingHelper ping:address target:Nil sel:Nil];
            }
            i++;
            //AppLog(@"%d %@",i,address);
        }
    }
}
- (void)startScan
{
    if(FlagScan) return;
    AppLog();
    FlagScan = YES;
    self.localAddress = [self localIPAddress];
    a=0; b=0; c=0; d=0;self.timerIterationNumber = 0;
    NSArray *loc = [self.localAddress componentsSeparatedByString:@"."];
    NSArray *net = [self.netMask componentsSeparatedByString:@"."];
    if ([self isIpAddressValid:self.localAddress] && (loc.count == 4) && (net.count == 4))
    {
        for (int i = 0; i<4; i++)
        {
            int and = [[loc objectAtIndex:i] integerValue] & [[net objectAtIndex:i] integerValue];
           
            if (!self.baseAddress.length)
            {
                self.baseAddress = [NSString stringWithFormat:@"%d", and];
            }
            else
            {
                self.baseAddress = [NSString stringWithFormat:@"%@.%d", self.baseAddress, and];
                self.currentHostAddress = and;
                self.baseAddressEnd = and;
            }
        }
        
        // Strings to in_addr:
        struct in_addr localAddr;
        struct in_addr netmaskAddr;
        inet_aton([self.localAddress UTF8String], &localAddr);
        inet_aton([self.netMask UTF8String], &netmaskAddr);
        localAddr.s_addr |= ~(netmaskAddr.s_addr);
        self.broadcastAddress = [NSString stringWithUTF8String:inet_ntoa(localAddr)];
        
        // tinh lai so may trên duong mang
        AppLog(@"\nbaseAddress:%@, broadcastAddress:%@, localAddress:%@,netMask:%@",self.baseAddress,self.broadcastAddress,self.localAddress,self.netMask);
        NSArray *aAddress = [self.baseAddress componentsSeparatedByString:@"."];
        NSArray *aBroadcast = [self.broadcastAddress componentsSeparatedByString:@"."];
//        NSArray *anetMask = [self.netMask componentsSeparatedByString:@"."];
        if (aAddress.count == 4 && aBroadcast.count == 4)
        {
            a = [[aBroadcast objectAtIndex:0] integerValue] - [[aAddress objectAtIndex:0] integerValue];
            b = [[aBroadcast objectAtIndex:1] integerValue] - [[aAddress objectAtIndex:1] integerValue];
            c = [[aBroadcast objectAtIndex:2] integerValue] - [[aAddress objectAtIndex:2] integerValue];
            d = [[aBroadcast objectAtIndex:3] integerValue] - [[aAddress objectAtIndex:3] integerValue];
            AppLog(@"a=%d, b=%d, c=%d, d=%d",a,b,c,d);
            self.SoMay = (((a*256 + b)*256 + c)*256) + d+1 -2;
            AppLog(@"So May:%d",self.SoMay);
        }
        I1=0;I2=0;I3=0;I4=0;
        NSArray *abaseAddress = [self.baseAddress componentsSeparatedByString:@"."];
        I1 = [[abaseAddress objectAtIndex:0] integerValue];
        I2 = [[abaseAddress objectAtIndex:1] integerValue];
        I3 = [[abaseAddress objectAtIndex:2] integerValue];
        I4 = [[abaseAddress objectAtIndex:3] integerValue];

        [self pingAddress];
    }
}

- (void)stopScan
{
    AppLog();
     FlagScan = NO;
}

- (void)pingAddress
{
    
    self.currentHostAddress++;
    
    if(self.currentHostAddress > 255)
    {
        self.currentHostAddress = 0;
        I3++;
        if(I3>255)
        {
            I3 = 0;
            I2++;
            if(I2>255)
            {
                I2 = 0;
                I1++;
                if(I1>255)
                {
                    [self.timer invalidate];
                    return;
                }
            }
        }
    }
    I4 = self.currentHostAddress;
    
    
    NSString *address = [NSString stringWithFormat:@"%d.%d.%d.%d",I1,I2,I3,I4];
    if ([address isEqualToString:self.broadcastAddress])
    {
        [self stopScan];
    }
    else
    {
        [self.delegate scanBegin:address];
        [SimplePingHelper ping:address target:self sel:@selector(pingResult:adress:)];
    }
   
}

- (void)pingResult:(NSNumber*)success adress:(NSString*)address
{
    self.timerIterationNumber++;
    if (success.boolValue)
    {
        
        address = [[[address stringByReplacingOccurrencesOfString:@".00" withString:@"."] stringByReplacingOccurrencesOfString:@".0" withString:@"."] stringByReplacingOccurrencesOfString:@".." withString:@".0."];
        AppLog(@"%@ SUCCESS",address);
        NSString *deviceName = [self getHostFromIPAddress:[[NSString stringWithFormat:@"%@%d", self.baseAddress, self.currentHostAddress] cStringUsingEncoding:NSASCIIStringEncoding]];
        
        [self.delegate scanLANDidFindNewAdrress:address havingHostName:deviceName];
    }
   
   
    //AppLog(@"address:%@ -> count: %d > %d",address,self.timerIterationNumber,self.SoMay);
    if (self.timerIterationNumber>=self.SoMay)
    {
        [self stopScan];
        [self.delegate scanLANDidFinishScanning];
    }
    else
    {
        if(FlagScan == YES)
            [self pingAddress];
    }
    
}

- (NSString *)getHostFromIPAddress:(const char*)ipAddress
{
    NSString *hostName = nil;
    int error;
    struct addrinfo *results = NULL;
    
    error = getaddrinfo(ipAddress, NULL, NULL, &results);
    if (error != 0)
    {
        //AppLog (@"Could not get any info for the address");
        return nil; // or exit(1);
    }
    
    for (struct addrinfo *r = results; r; r = r->ai_next)
    {
        char hostname[NI_MAXHOST] = {0};
        error = getnameinfo(r->ai_addr, r->ai_addrlen, hostname, sizeof hostname, NULL, 0 , 0);
        if (error != 0)
        {
            continue; // try next one
        }
        else
        {
         //   AppLog (@"Found hostname: %s", hostname);
            hostName = [NSString stringWithFormat:@"%s", hostname];
            break;
        }
        freeaddrinfo(results);
    }
    return hostName;
}

// Get IP Address
- (NSString *)getIPAddress
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
                //AppLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
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
                    self.netMask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    return address;
}

- (BOOL) isIpAddressValid:(NSString *)ipAddress
{
    struct in_addr pin;
    int success = inet_aton([ipAddress UTF8String],&pin);
    if (success == 1) return TRUE;
    return FALSE;
}

@end
