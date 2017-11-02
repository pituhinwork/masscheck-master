//
//  Wifi.m
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import <CFNetwork/CFNetwork.h>
#import "Reachability.h"

#import "iDevice.h"
#import "Wifi.h"

#import "AppDelegate.h"
#import "MainTestViewController.h"

//#define WIFIDERBUG
#if defined(WIFIDERBUG) || defined(DEBUG_ALL)
#   define WIFILog(BachUng, ...) NSLog((@"%s[Line %d] " BachUng), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define WIFILog(...)
#endif


#define WIFI_NONE 0
#define WIFI_STARTED 1
//#define WIFI_ZERO 2
#define WIFI_FINISHED 3

@implementation Wifi
@synthesize key;
@synthesize ID;
@synthesize fmode;
@synthesize resultDesc;
@synthesize result;
@synthesize manual;
- (id) init
{
    self = [super init];
    key = @"WIFI";
    callRecieve = 0;
    ID = -1;
    resultDesc = @"Wi-Fi Connection";
    result = NO;
    isAskFromLinux = NO;
    status = WIFI_NONE;
    msgBox = Nil;
    manual = NO;
    kqOPEN = NO;
    kqConnectInternet = NO;
    kqconnectAcceptPoin = NO;
    msgBox = Nil;
    return self;
}

- (void) canStartWifiPreTest
{
    WIFILog(@"[WIFI] Pretest start =======");
    [self performSelector:@selector(startGetWifiValue)];
}

- (void) dealloc
{
}

- (void) failedCheck:(NSString*)desc
{
    if(status != WIFI_FINISHED)
    {
        WIFILog(@"%@",desc);
        status = WIFI_FINISHED;
        result = NO;
        resultDesc = [[NSString alloc] initWithFormat:@"%@",desc];

        [self writeResultValue];
        [self releaseResource];
    }
}

- (void) successCheck:(NSString*)desc
{
    if(status != WIFI_FINISHED)
    {
        WIFILog(@"%@",desc);
        status = WIFI_FINISHED;
        result = YES;
        resultDesc = [[NSString alloc] initWithFormat:@"%@",desc];

        [self writeResultValue];
        [self releaseResource];
    }

}

- (void) releaseResource
{
    WIFILog();
    if(wv)
    {
        if([wv isLoading])
        {
            [wv stopLoading];
        }
        
        wv = nil;
    }
    

    if(msgBox)
    {
        WIFILog(@"release msg");
        [msgBox dismiss];
        msgBox = nil;
    }
   
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}
- (void)writeResultValue
{
     WIFILog();
    if(isAskFromLinux == YES && status == WIFI_FINISHED)
    {
        WIFILog(@" ID:%d, Key:%@, desc:%@",ID,key,resultDesc);
        
        [self.parentView updateResult:ID value:[NSString stringWithFormat:@" %@#%@#%@",key,result?@"Passed":@"Failed",resultDesc]];

        [self.parentView.wireless turn3G:YES];
    }

}
- (int)checkConnect
{
    
    //    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    //    [reachability startNotifier];
    Reachability *reachability = [Reachability reachabilityWithHostname:@"google.com"];
    
    
    NetworkStatus Netstatus = [reachability currentReachabilityStatus];
    if(Netstatus == NotReachable)
    {
        return 0;//No internet
    }
    else if (Netstatus == ReachableViaWiFi)
    {
        return 1;//WiFi
    }
    else if (Netstatus == ReachableViaWWAN)
    {
        return 2;//3G
    }
    [reachability stopNotifier];
    return -1;
}

// This function is started when Master Linux request
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param
{
    isAskFromLinux = YES;
    if(self.parentView.actionRetest == YES && status == WIFI_FINISHED)
    {
        status = WIFI_NONE;
        result = NO;
    }

    WIFILog(@" result:%@ finished:%@",result?@"YES":@"NO", (status == WIFI_FINISHED)?@"PASSED":@"FAILED");
    if(result == NO)
    {
        
        
        if([self checkConnect]!=1)
        {
            WIFILog(@"2");
            msgBox = [[MessageBox alloc] init];
            
            WIFILog(@"3");
            NSString *content =  [NSString stringWithFormat:@"%@",AppShare.ConnectWiFiToNetworkAndClickStart];
            NSString *title = AppShare.WiFiTestText;
            [msgBox showWithContent:content title:title button:AppShare.STARTText cancel:Nil tag:1 delegate:self sel:@selector(onMessage:)];
            [msgBox setCaptionBackground:[UIColor clearColor]];
            
            timeleft = 120;
            [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            WIFILog(@"4");
        }
        else
        {
             [self preTest];
        }
    }
    else
    {
        [self writeResultValue];
    }
}
//- (void) dissmissMessage
//{
//    if(msgBox)
//    {
//        [msgBox performSelector:@selector(onclickWithTag:) withObject:[NSNumber numberWithInt:1] afterDelay:timeleft];
////        [msgBox release];
////        msgBox = Nil;
//    }
//}
- (void) onMessage:(NSNumber*)num
{
     WIFILog();
    status = WIFI_NONE;
    int tag = [num integerValue];
    switch (tag) {
        case 101:
            [self failedCheck:@"Manual"];
            break;
        case 102:
            [self successCheck:@"Manual"];
            break;
        default:
            if([self checkConnect]==1)
            {
                [self preTest];
            }
            else
            {
                [self failedCheck:@"Not connect via WI-FI"];
            }
           break;
    }
}

- (void) countTime
{
    if(timeleft > 0)
    {
        timeleft --;
         WIFILog(@"%d",timeleft);
        if(msgBox)
            [msgBox createLBL:[NSString stringWithFormat:@"%d s",timeleft]];
    }
    else
    {
        [timer invalidate];
        timer = nil;
//        if(msgBox)
//        {
//            WIFILog(@"release msg");
//            [msgBox onclickWithTag:[NSNumber numberWithInt:1]];
////            [msgBox dismiss];
////            [msgBox release];
//            msgBox = Nil;
//        }
        //[self preTest];
        [self performSelectorOnMainThread:@selector(preTest) withObject:nil waitUntilDone:NO];
    }
   
}


- (void) preTest
{
    
    if(manual==YES)
        return;
    
    WIFILog(@"============== turn3G off");
    [self.parentView.wireless turn3G:NO];
//    if(status == WIFI_NONE)
//    {
//        WIFILog();
//        count = 0;
//        status = WIFI_STARTED;
//        callRecieve++;
//        isConnectedAP = NO;
//        gotActive = NO;
//        countAP = 0;
//        kqOPEN = NO;
//        kqConnectInternet = NO;
//        kqconnectAcceptPoin = NO;
//        [self startGetWifiValue];
//    }
//    else
//    {

        WIFILog();
        count = 0;
        status = WIFI_STARTED;
        callRecieve++;
        isConnectedAP = NO;
        gotActive = NO;
        countAP = 0;
        kqOPEN = NO;
        kqConnectInternet = NO;
        kqconnectAcceptPoin = NO;
        [self startGetWifiValue];
//    }
}



- (void) startGetWifiValue
{
    WIFILog();
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus Netstatus = [reachability currentReachabilityStatus];
    if(Netstatus == NotReachable)
    {
        WIFILog(@"Not internet");
        [self failedCheck:@"Wi-Fi was not connected to any access point"];
    }
    else if (Netstatus == ReachableViaWiFi)
    {
        WIFILog(@"connect with WIFI");
        kqconnectAcceptPoin = YES;
        if([self.parentView.wireless deviceGoodStatus]==NO)
        {
            [self failedCheck:@"Wi-Fi device's broken"];
        }
        else
        {
            // Turn off 3G
            
            NSString *ssid = [self.parentView.wireless accessPointName];
            kqOPEN = YES;
            if ((NSNull *) ssid == [NSNull null])
            {
                 WIFILog(@"Wi-Fi was not detect access point");
                [self failedCheck:@"Wi-Fi was not detect access point"];
            }
            if ([ssid isEqual:[NSNull null]])
            {
                WIFILog(@"Wi-Fi was not detect access point.");
                [self failedCheck:@"Wi-Fi was not detect access point"];
            }
          //  WIFILog(@"============== SSDI: %@", ssid);

            WIFILog(@"connect web");
            kqconnectAcceptPoin = YES;
            wv = [[UIWebView alloc] init];
            [wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com"]]];
            [self performSelector:@selector(checkAfterDelay) withObject:nil afterDelay:1];
            callRecieve++;
            [self performSelector:@selector(checkTimeOut:) withObject:[NSNumber numberWithInt:callRecieve] afterDelay:35];

        }
    }
    else if (Netstatus == ReachableViaWWAN)
    {
        //3G
        [self failedCheck:@"Not connect with Wi-Fi"];
    }
}

- (void) checkTimeOut:(NSNumber*)num
{
    if([num intValue] == callRecieve)
    {
        if((status != WIFI_FINISHED) && (!gotActive))
        {
            [self failedCheck:@"Timeout"];
        }
    }
}

- (void) checkAfterDelay
{
    if(status != WIFI_FINISHED)
    {
        double b = [[NSDate date] timeIntervalSince1970];
        BOOL nwStatusViaWifi = [Reachability getConnectivityViaWiFiNetwork];
        double c = [[NSDate date] timeIntervalSince1970];
        
        if(((c-b) >= 15.0) && (!nwStatusViaWifi))
        {
            [self failedCheck:@"Router was not connected to internet"];
        }
        else
        {
            
            if(nwStatusViaWifi)
            {
                gotActive = YES;
                
                int bytes = 0;
                NSString *type = @"http://www.apple.com";
              
                timeConnec = [[NSDate date] timeIntervalSince1970];
                NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?stuffData=%lf", type, [[NSDate date] timeIntervalSince1970]]]];

                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if(error || (!data) || (data && [data length] <= bytes))
                    {
                        if(error) WIFILog(@"data.lenght:%ld,error:%@",[data length],[error description]);

                        [self failedCheck:@"Router was not connected to internet"];
                        
                    }
                    else
                    {
                        //                        [self successCheck:[NSString stringWithFormat:@"Connected to %@", type]];
                        kqConnectInternet = YES;
                        [self successCheck:[NSString stringWithFormat:@"PASSED"]];
                    }
                }];
            }
            else
            {
                if(status != WIFI_FINISHED)
                {
                    if(++count >= 2)
                    {
                        [self failedCheck:@"Router was not connected to internet"];
                    }
                    else
                    {
                        [self performSelector:@selector(checkAfterDelay) withObject:nil afterDelay:1];
                    }
                }
            }
        }
    }
}

@end
