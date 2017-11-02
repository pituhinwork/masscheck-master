//
//  Engrave.m
//  IVERIFY
//
//  Created by Bach Ung on 9/12/14.
//  Copyright (c) 2014MaTran All rights reserved.
//
#import "Utilities.h"
#import "AppDelegate.h"
#import "TouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "MainTestViewController.h"

#import <poll.h>
#include <net/if.h>
#import <sys/un.h>


#define SOCKET_PATH "/var/run/lockdown/syslog.sock"



int unix_connect(char* path)
{
    struct sockaddr_un sun;
    int s;
    
    if ((s = socket(AF_UNIX, SOCK_STREAM, 0)) < 0)
        return (-1);
    (void)fcntl(s, F_SETFD, 1);
    
    memset(&sun, 0, sizeof(struct sockaddr_un));
    sun.sun_family = AF_UNIX;
    
    if (strlcpy(sun.sun_path, path, sizeof(sun.sun_path)) >= sizeof(sun.sun_path)) {
        close(s);
        errno = ENAMETOOLONG;
        return (-1);
    }
    if (connect(s, (struct sockaddr *)&sun, SUN_LEN(&sun)) < 0) {
        close(s);
        return (-1);
    }
    
    return (s);
}



@implementation TouchID
@synthesize key;
@synthesize ID;
@synthesize status;
@synthesize isPassed;
@synthesize isFinished;

- (id) init
{
    self = [super init];
    ID = -1;
    key = @"TouchID";
    msgBox = Nil;
    status = TOUCHID_NONE;
    isAskFromLinux = NO;
    isPassed = NO;
    isFinished = NO;
    isTestAgain = NO;
    callCount = 0;
    isAskSetupTouch = NO;
    return self;
}
- (void) dealloc
{
    if(msgBox)
    {
        [msgBox dismiss];
        msgBox = Nil;
    }
}
- (void) successCheck:(NSString*)desc
{
    if(status != TOUCHID_FINISHED)
    {
        
        NSLog(@"%s",__FUNCTION__);
        status = TOUCHID_FINISHED;
        isFinished = YES;
        isPassed = YES;
        
        //[AppShare showNotical:@"Click me to open"];
        
        [self.parentView updateResult:ID value:[NSString stringWithFormat:@" %@#%@#%@",key,@"PASSED",desc]];
        [self releaseResouce];
        
    }
}

- (void) failedCheck:(NSString*)desc
{
    if(status != TOUCHID_FINISHED)
    {
         NSLog(@"%s",__FUNCTION__);
        status = TOUCHID_FINISHED;
         isFinished = YES;
         isPassed = NO;
        //[AppShare showNotical:@"Click me to open"];
       
        [self.parentView updateResult:ID value:[NSString stringWithFormat:@" %@#%@#%@",key,@"FAILED",desc]];
        [self releaseResouce];
    }
}

- (void) releaseResouce
{
    AppShare.isShowNotification = NO;
    if(timer)
    {
        [timer invalidate];
        timer = Nil;
    }
    isAskSetupTouch = NO;
    
//    if ([myThread isExecuting])
//    {
//        [myThread cancel];
//    }
//    if(myThread)
//    {
//        [myThread release];
//        myThread = Nil;
//    }
    if(msgBox)
    {
        [msgBox dismiss];
        msgBox = Nil;
    }
}
- (void) onMessage:(NSNumber*)num
{
    int tag = [num intValue];
    NSLog(@"%s tag:%d",__FUNCTION__,tag);
//    switch (tag)
//    {
//        case 1:
            [self startAutoTest:@"TOUCHID" param:@"retest"];
//            break;
//        case 101: //Select failed,skip
//            [self failedCheck:@"Skip"];
//            break;
//        case 102:// Next
//            isTestAgain = YES;
//            [self preTest];
//            [self performSelector:@selector(showWaiting) withObject:Nil afterDelay:1];
//            //[self performSelector:@selector(testerCheck) withObject:Nil afterDelay:90];// khi het 90s chua add duoc fingering se hoi nguoi dung
//            break;
//        case 201: // user check failed
//            [self failedCheck:@"Failed by tester"];
//            break;
//        case 202: // user check Passed
//            [self successCheck:@"Passed by tester"];
//            break;
//        default:
//            break;
//    }
}

- (void) showWaiting
{
    if(msgBox)
    {
        [msgBox dismiss];
        msgBox = Nil;
    }
    msgBox = [[MessageBox alloc] init];

    [msgBox showNoneButton:@"Touch ID Test\nWaiting for process...." title:@""];

    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (BOOL) isStetupTouchID
{
    BOOL kq = NO;
    if(AppShare.iOS >= 8)
    {
        LAContext *context = [[LAContext alloc] init];
        NSError *error1 = nil;
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error1])
        {
            kq = YES;
        }
    }
    return kq;
}
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param
{
    
    if(self.parentView.actionRetest == YES)
    {
        status = TOUCHID_NONE;
         isPassed = NO;
        isFinished = NO;
    }
    

    NSString *partNum = getPhoneModal(2);
    NSString *model = [UIDevice currentDevice].model;
    BOOL validate = NO;
    if(([[model uppercaseString] rangeOfString:@"IPHONE"].location != NSNotFound && [partNum floatValue] > (float)6.0) ||
        ([[model uppercaseString] rangeOfString:@"IPAD"].location != NSNotFound && [partNum floatValue] > (float)5.2 ))
        validate = YES;

    AppShare.isShowNotification = NO;
    
    if(validate == NO)
    {
        [self failedCheck:@"Device not support"];
        return;
    }
    

    if(AppShare.iOS >= 8)
    {
        NSLog(@"%s Fingering test only fingering when it was settuped ",__FUNCTION__);
        LAContext *context = [[LAContext alloc] init];
        
        NSError *error1 = nil;
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error1])
        {
            if(isAskSetupTouch == YES)
            {
                [self performSelectorOnMainThread:@selector(successCheck:) withObject:@" " waitUntilDone:NO];
            }
            else
            {
                context.maxBiometryFailures = @1;
                context.localizedFallbackTitle = @" ";//@"Enter password";
                NSLog(@"%s LAPolicyDeviceOwnerAuthenticationWithBiometrics",__FUNCTION__);
                NSString *conten = [NSString stringWithFormat:@"%@",AppShare.PlaceYourFingerOnTheHomeButtonText];
                [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:conten reply:^(BOOL success, NSError *error)
                 {
                     NSLog(@"%s Fingering access",__FUNCTION__);
                     
                     if (error)
                     {
                         NSLog(@"%s Fingering error [%@]",__FUNCTION__,[error description]);
                         NSString *dataError = [NSString stringWithFormat:@"%@",[error description]];
                         NSLog(@"%s Fingering error [%@]",__FUNCTION__,dataError);
                         if([[dataError uppercaseString] rangeOfString:[@"CANCELED BY USER" uppercaseString]].location != NSNotFound)
                         {
                             [self performSelectorOnMainThread:@selector(failedCheck:) withObject:@"Canceled by user" waitUntilDone:NO];
                         }
                         else
                         {
                             [self performSelectorOnMainThread:@selector(successCheck:) withObject:@"There was a problem verifying your identity." waitUntilDone:NO];
                         }
                         
                     }
                     else
                     {
                         NSLog(@"%s Fingering else",__FUNCTION__);
                         if (success)
                         {
                             NSLog(@"%s Fingering else success",__FUNCTION__);;
                             [self performSelectorOnMainThread:@selector(successCheck:) withObject:@" " waitUntilDone:NO];
                         }
                         else
                         {
                             NSLog(@"%s You are not the device owner.",__FUNCTION__);
                             [self performSelectorOnMainThread:@selector(failedCheck:) withObject:@"You are not the device owner." waitUntilDone:NO];
                         }
                     }
                     
                     
                 }];
            }
        }
        else
        {
            if(isAskSetupTouch == NO)
            {
                isAskSetupTouch = YES;
                if(msgBox)
                {
                    msgBox = Nil;
                }
                
                
                msgBox = [[MessageBox alloc] init];
                NSString *conten = [NSString stringWithFormat:@"%@\n%@",AppShare.PleaseSetupTouchIDText,AppShare.ClickStartToBeginText];
                [msgBox showContentFull:conten title:AppShare.TouchIDTestText ButtonImg:[UIImage imageNamed:@"btStart.png"] btPress:[UIImage imageNamed:@"btStart.png"] tag:1 delegate:self sel:@selector(onMessage:)];
                int width = [UIScreen mainScreen].bounds.size.width;
                int height= [UIScreen mainScreen].bounds.size.height;
                [msgBox setbtnFarme:CGRectMake(10, height - 60*height*1.0/568, 300*width*1.0/320.0, 50*height*1.0/568)];
                [msgBox setbtnBackgroundColor:[UIColor whiteColor]];
                [msgBox setbtnTest:AppShare.StartText];
                [msgBox setCaptionBackground:[UIColor colorWithRed:0xEF*1.0/0xFF green:0xEF*1.0/0xFF blue:0xF4*1.0/0xFF alpha:1]];
                [msgBox setCaptionFrame: CGRectMake(0, 0, width, TITLE_HIGHT)];
                [msgBox setContentFrame:CGRectMake(0, TITLE_HIGHT, width, 300)];
                
            }
            else
            {
                NSLog(@"%s Your device cannot authenticate using TouchID.%@",__FUNCTION__,[error1 description]);
                [self performSelectorOnMainThread:@selector(failedCheck:) withObject:@"Your device cannot authenticate using TouchID" waitUntilDone:NO];
            }
            timer = Nil;
        }
    }
    else
    {
        isTestAgain = YES;// them vao de nguoi dung test : YES show message nguoi dung chon, NO: may chon
        //[self testerCheck];
        [self performSelectorOnMainThread:@selector(failedCheck:) withObject:@"Not Support" waitUntilDone:NO];
    }
    NSLog(@"%s End Fingering test",__FUNCTION__);
    
}
- (void) testerCheck
{
    NSLog(@"%s isTestAgain:%@",__FUNCTION__,isTestAgain?@"YES":@"NO");
    if(isTestAgain == YES)
    {
        // neu da thanh cong set pass
        if(isPassed == YES)
        {
            if(isPassed == YES)
            {
                [self successCheck:@" "];
                return;
            }
        }
//        [AppShare showNotical:@"Click me to open"];
        // hoi va danh cho nguoi test tu check
        if(msgBox)
        {
            [msgBox dismiss];
            msgBox = nil;
        }
        msgBox = [[MessageBox alloc] init];
        NSMutableArray * buttons = [[NSMutableArray alloc] init];
        [buttons addObject:@"Failed"];//fail,YES
        [buttons addObject:@"Passed"];// pass,NO
        

        [msgBox showContentWith:@"Touch ID is Passed?" title:@"" Button:buttons canceltag:200 delegate:self sel:@selector(onMessage:)];

    }
}
- (void) preTest
{
//    os 8.1.2 error thread
//    myThread = [[NSThread alloc] initWithTarget:self selector:@selector(checkfigerPrint)object:nil];
//    [myThread start];
    [self performSelectorInBackground:@selector(checkfigerPrint) withObject:Nil];
  
}
- (void) checkTimeOut:(NSNumber*)num
{
    if([num intValue] == callCount)
    {
        if(status != TOUCHID_FINISHED)
        {
            [self failedCheck:@"Timeout"];
        }
    }
}


- (void) checkfigerPrint
{
    int nfd = unix_connect(SOCKET_PATH);
     NSLog(@"%s",__FUNCTION__);
    // write "watch" command to socket to begin receiving messages
    write(nfd, "watch\n", 6);
    
    struct pollfd pfd[2];
    unsigned char buf[16384];
    int n = fileno(stdin);
    int plen = 16384;
    NSString *str = @"";
    pfd[0].fd = nfd;
    pfd[0].events = POLLIN;
    
    NSDate *datebegin = [NSDate date];
    NSDate *dateAddFinger = [NSDate date];
    char *escapedBuffer = NULL;
     NSLog(@"%s begin while",__FUNCTION__);
    while (pfd[0].fd != -1)
    {
         NSLog(@"\n\n%s while: fd %d",__FUNCTION__,pfd[0].fd);
        if ((n = poll(pfd, 1, -1)) < 0)
        {
            close(nfd);
            perror("polling error");
            NSLog(@"%s polling error",__FUNCTION__);
            break;
        }
        if(isFinished == YES)
        {
            close(nfd);
            break;
        }
        if (pfd[0].revents & POLLIN)
        {
            if ((n = read(nfd, buf, plen)) < 0)
            {
                perror("read error");
                NSLog(@"%s read error",__FUNCTION__);
                /* possibly not an error, just disconnection */
                break;
            }
            else if (n == 0)
            {
                shutdown(nfd, SHUT_RD);
                pfd[0].fd = -1;
                pfd[0].events = 0;
                 NSLog(@"%s n==0",__FUNCTION__);
            }
            else
            {
              //   NSLog(@"%s malloc",__FUNCTION__);
                 escapedBuffer = malloc(n + 1);
                memcpy(escapedBuffer, buf, n);
                escapedBuffer[n] = '\0';
                str = [NSString stringWithUTF8String:escapedBuffer];
                 NSLog(@"%s -->:%@",__FUNCTION__,str);
                if([[str uppercaseString] rangeOfString:[@" ART:" uppercaseString]].location != NSNotFound ||
                   [[str uppercaseString] rangeOfString:[@"_ART" uppercaseString]].location != NSNotFound)
                    
                {
                    str = [str stringByReplacingOccurrencesOfString:@"ART:" withString:@""];
                    str = [str stringByReplacingOccurrencesOfString:@"_ART:" withString:@""];
                    str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
                    NSLog(@"%s duyet1:%@",__FUNCTION__,str);
                    
                    NSArray *datatemp = [str componentsSeparatedByString:@" "];
                    if(datatemp.count > 3)
                    {
                        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
                        int year = [components year];
                    
                        NSString *dateTime = [NSString stringWithFormat:@"%d-%@-%@ %@",year ,[NSString stringWithFormat:@"%@",[datatemp objectAtIndex:0]],[NSString stringWithFormat:@"%@",[datatemp objectAtIndex:1]],[NSString stringWithFormat:@"%@",[datatemp objectAtIndex:2]]];

                        
                         NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
                        [DateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                        [DateFormatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
                        [DateFormatter setDateFormat:@"yyyy-MMM-dd HH:mm:ss"];
                       
                        NSLog(@"%s duyet2: dateTimeStr:%@",__FUNCTION__,dateTime);
                        dateAddFinger = [DateFormatter dateFromString:dateTime];
                        
                        NSLog(@"dateAddFinger date: %@",[DateFormatter stringFromDate:dateAddFinger]);
                        NSLog(@"date begin: %@",[DateFormatter stringFromDate:datebegin]);
   
                        if ([dateAddFinger timeIntervalSinceReferenceDate] > [datebegin timeIntervalSinceReferenceDate])
                        {
                            NSLog(@"Add Finger sau khi retest");
                            NSLog(@"Fingerprint accept successfull");
                            isPassed = YES;
                            close(nfd);
                            if(escapedBuffer)
                            {
                               //   NSLog(@"%s free1",__FUNCTION__);
                                free(escapedBuffer);
                                escapedBuffer = NULL;
                            }
                            [self performSelectorOnMainThread:@selector(successCheck:) withObject:@"" waitUntilDone:NO];
                            break;
                        }
                        else
                        {
                             NSLog(@"Add Finger truoc khi retest");
                        }
                    }
                }//if check ART
                if([str rangeOfString:@"IVERIFY"].location == NSNotFound)
                    NSLog(@"%s n=%d duyet3:%@",__FUNCTION__,n,str);
                if(escapedBuffer!=NULL)
                {
                    // NSLog(@"%s free2",__FUNCTION__);
                    
                    free(escapedBuffer);
                    sleep(1);
                    escapedBuffer = NULL;
                    
                }
            }// n > 0
        }//pfd[0].revents & POLLIN
    }// while
}


@end
