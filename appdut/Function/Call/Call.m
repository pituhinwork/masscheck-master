//
//  Call.m
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import "AppDelegate.h"

#import "iDevice.h"
#import "Call.h"
#import "Utilities.h"
#import "MainTestViewController.h"

#define CALL_ZERO 1
#define CALL_START 2
#define CALL_ASKRESULT 3
#define CALL_FINISHED 5

@implementation Call
@synthesize key;
@synthesize ID;
@synthesize checkwareYES;
@synthesize wareMin;
@synthesize wareMax;
@synthesize manual;



- (id) init
{
    self = [super init];
    key = @"Call";
    dataFileDetect=@"";
    wareCount = 0;
    ID = -1;
    tempObject = @"";
    flag = 0;
    status = CALL_ZERO;
    checkwareYES = NO;
    checkTimer = Nil;
    wareMin = 10000.0;
    wareMax = -10000.0;
    timeOpen = Nil;
    wlBackup = 0;
    numCall = 0;
    manual = NO;
    msgBox = Nil;
    NSString *model = [NSString stringWithFormat:@"%@",[UIDevice currentDevice].model];
    
    if([[model uppercaseString] rangeOfString:@"IPHONE"].location != NSNotFound)
    {
        checkWareTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkWareBegin) userInfo:nil repeats:YES];
    }
    return self;
}

- (void) releaseResouce
{
//    if(timeOpen!= Nil)
//    {
//        [timeOpen invalidate];
//        timeOpen = Nil;
//    }
    if(!AppShare.isFinished && AppShare.isShowNotification == YES)
    {
        [AppShare showNotical:@"Click me to open"];
    }
    if (checkTimer) {
        [checkTimer invalidate];
        checkTimer = Nil;
    }
    if(numcall)
    {
        numcall = nil;
    }
    if(checkWareTimer!= Nil)
    {
        [checkWareTimer invalidate];
        checkWareTimer = Nil;
    }
    if(msgBox)
    {
        [msgBox dismiss];
        msgBox = Nil;
    }
    
    AppShare.isShowNotification = NO;
}
- (void) failedCheck:(NSString*)desc
{
    if(status != CALL_FINISHED)
    {
        AppLog(@"%s",__FUNCTION__);
        status = CALL_FINISHED;
        [AppShare.parentView updateResult:ID value:[NSString stringWithFormat:@" %@#%@#%@",key,@"FAILED",desc]];
        [self releaseResouce];
    }
}

- (void) updateParent:(NSString*)desc {
    
    [self.parentView updateResult:ID value:desc];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkCallTimeOut:) object:[NSNumber numberWithInt:callCount]];
}

- (void) successCheck:(NSString*)desc
{
    if(status != CALL_FINISHED)
    {
        AppLog(@"%s",__FUNCTION__);
        
        status = CALL_FINISHED;
 //       [self performSelector:@selector(updateParent:) withObject:[NSString stringWithFormat:@" %@#%@#%@",key,@"PASSED",desc] afterDelay:1];
        [self.parentView updateResult:ID value:[NSString stringWithFormat:@" %@#%@#%@",key,@"PASSED",desc]];
//        [timer invalidate];
//        timer = Nil;
        [self releaseResouce];
    }
}
- (void) playerRun
{
    countTime++;
    if(AppShare.isActive)
    {
        countTime=0;
        [timer invalidate];
        timer = Nil;
        AppLog(@"[CALL] playerRun call number [%@]", numcall);
        [self startAutoTest:@"call" param:numcall];
        return;
    }
    if(countTime > 60)
    {
        countTime=0;
        [timer invalidate];
        timer = Nil;
        [self failedCheck:@"Timeout in background"];
        
    }
}

// This function is started when Master Linux request
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param
{
    
    param = [[param componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+#*()"] invertedSet]] componentsJoinedByString:@""];
    
    NSString *cmd=@"611";
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    AppLog(@"\nisoCountry:%@\nmobileCountry:%@",[carrier isoCountryCode],[carrier mobileCountryCode]);
    if([[[carrier isoCountryCode] uppercaseString] rangeOfString:@"VN"].location != NSNotFound)
        cmd = @"900";
    param = cmd;

    flag = 0;
    numcall = [[NSString alloc] initWithFormat:@"%@",param];
    AppLog(@"[CALL] startAutoTest call number [%@]", numcall);
    
 //   if(self.parentView.actionRetest == YES || status == CALL_FINISHED)
    {
        status = CALL_ZERO;
    }
    
    countTime = 0;
    if(AppShare.isActive == NO)
    {
        countTime = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playerRun) userInfo:nil repeats:YES];
        return;
    }
    
    if(status != CALL_ZERO) return;
    countRecieve = 0;
    status = CALL_START;
    callCount++;
    
    if (checkTimer) {
        [checkTimer invalidate];
        checkTimer = Nil;
    }
    checkTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkSuccess) userInfo:nil repeats:YES];
    // loai o ky tu EOF file
    
    NSString *model = getPhoneModal(3);
    if([[model uppercaseString] rangeOfString:@"IPAD"].location != NSNotFound )
    {
        [self failedCheck:[NSString stringWithFormat:@"Not support"]];
        return;
    }
    
    if([self.parentView.telephone radioAccess] == NO)
    {
        [self failedCheck:@"Radio Access failed"];
        return;
    }
    if(checkWareTimer!= Nil)
    {
        [checkWareTimer invalidate];
        checkWareTimer = Nil;
    }
    if((!param) || [param length] <= 0)
    {
        [self failedCheck:@"Null number"];
    }
    else
    {
        
        if(status != CALL_FINISHED)
        {
          
            [self performSelector:@selector(callStart:) withObject:param afterDelay:1];
            [self performSelector:@selector(checkCallTimeOut:) withObject:[NSNumber numberWithInt:callCount] afterDelay:30];
            
       
        }
        
    }
}

// check ware in five time enought to call action: Yes when ware lever > limit
- (BOOL) checkWareBegin
{
    
    return NO;
}

- (void) callStart:(NSString*)num
{
    AppLog(@"[Call] callStart:[%@]",num);
    canPassWheBusy = NO;
    status = CALL_ASKRESULT;
    [self.parentView.telephone callWithnumber:num];
    AppShare.isShowNotification = NO;
    timeOpen = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(showNotific) userInfo:nil repeats:YES];
}

- (void) stopShowNotific
{
    if(timeOpen != nil)
    {
        [timeOpen invalidate];
        timeOpen = Nil;
    }
}

- (void) showNotific
{
    AppLog(@"[Call] canPassWheBusy : %@, status=CALL_FINISHED:%@ ",canPassWheBusy?@"Yes":@"NO",status==CALL_FINISHED?@"YES":@"NO");
    if(status==CALL_FINISHED)
    {
        [AppShare showNotical:AppShare.EndCallAndCombackAppText];
    }
    if(AppShare.isActive == YES)
    {
        [self stopShowNotific];
    }
    
    
}


- (void) onMessage:(NSNumber*)num
{
    int tag = [num intValue];
    [self stopShowNotific];
    if(tag == 201)//failed
    {
        // Failed test
        AppLog(@" Failed 201");
        [self failedCheck:@"User check"];
    }
    else if(tag == 202)// pass
    {
        AppLog(@" Pass 202");
        [self successCheck:@"User check"];
    }
}

- (void) checkSuccess {
    if (flag == 1 || flag == 2) {
        flag = 0;
        [self successCheck:tempObject];
    }
    else if (flag == 3){
        flag = 0;
        [self failedCheck:tempObject];
    }
}

- (void) callNotify:(CTCall*)call status:(NSNumber*)stsNumber
{
    //    status == CALL_START
    if(status == CALL_ASKRESULT)
    {
        
        if(manual == YES)
        {
            AppLog(@"[CALL MANUAL] ============ %d", [stsNumber intValue]);
        }
        else  AppLog(@"[CALL] ============ %d", [stsNumber intValue]);
        
        
        if([stsNumber intValue] == 3)
        {
            flashCall = 3;
            
            canPassWheBusy = YES;
            [self performSelector:@selector(acceptPassBusy) withObject:Nil afterDelay:5];
        }
        
        
        if(flashCall==3 && [stsNumber intValue]==1)
        {
            [self showNotific];
            flag = 1;
            tempObject = @" ";
 //           checkTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkSuccess) userInfo:nil repeats:NO];
//            [self performSelector:@selector(successCheck:) withObject:@" " afterDelay:1];
        }
        if(flashCall==3 && [stsNumber intValue]==5)
        {
  //          [self successCheck:@"But Busy"];
            if (flag == 0) {
                flag = 2;
                tempObject = @"But Busy";
//               checkTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkSuccess) userInfo:nil repeats:NO];

            }
//                [self performSelector:@selector(successCheck:) withObject:@"But Busy" afterDelay:1];
        }
        if(flashCall != 3 && [stsNumber intValue]==5)
        {
            if (flag == 0) {
                flag = 2;
                tempObject = @"Call have problem.";
 //               checkTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkSuccess) userInfo:nil repeats:NO];
                
            }
//            [self performSelector:@selector(failedCheck:) withObject:@"Call have problem." afterDelay:1];
        }
    }
}
- (void) acceptPassBusy
{
    AppLog(@"%s",__FUNCTION__);
    canPassWheBusy = YES;
}
- (void) forceFinishedCallTest
{
    [self.parentView.telephone disconectAllCall];
}

- (void) checkCallTimeOut:(NSNumber*)num
{
    if([num intValue] == callCount)
    {
        if(status != CALL_FINISHED)
        {
            [self.parentView.telephone disconectAllCall];
            [self failedCheck:@"Timeout"];
        }
    }
}

@end
