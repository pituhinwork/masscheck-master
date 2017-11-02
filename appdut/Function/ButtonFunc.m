//
//  ButtonFunc.m
//  IVERIFY
//
//  Created by BachUng on 8/11/16.
//  Copyright © 2016MaTran All rights reserved.
//
#import "AppDelegate.h"
#import "ButtonFunc.h"
#import "Utilities.h"
#import "MainTestViewController.h"

#define BUTTONFUNC_NONE        0
#define BUTTONFUNC_START       1
#define BUTTONFUNC_FINISHED    2


    //#define BUTTONFUNCBUG
#if defined(BUTTONFUNCBUG) || defined(DEBUG_ALL)
#   define ButtonFuncLog(BachUng, ...) NSLog((@"%s[Line %d] " BachUng), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define ButtonFuncLog(...)
#endif



@interface ButtonFunc ()

@end

@implementation ButtonFunc

@synthesize ID;
@synthesize key;

@synthesize varHome;
@synthesize varPower;
@synthesize varMute;
@synthesize varVolup;
@synthesize varVolDown;

- (id)init
{
    self = [super init];
    ID= -1;
    key = @"BTFunc";
    timeleft = 30;
    is5C = NO;
    scrollviewConten = Nil;
    AudioSessionSetActive(true);// su dung volume
    status = BUTTONFUNC_NONE;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventHomePower:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
    return self;
}
- (void)dealloc
{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ButtonFuncLog();
    
    // Do any additional setup after loading the view.
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = rect;
    callCount = 0;
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:rect];
    scrollview.contentSize = CGSizeMake(rect.size.width, rect.size.height>560?rect.size.height:560);
    //scrollview.scrollEnabled = NO;
    float tlw= rect.size.width*1.0/320.0;
    
    
    
    
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, TITLE_HIGHT)];
    lbTitle.backgroundColor = [UIColor colorWithRed:0xEF*1.0/0xFF green:0xEF*1.0/0xFF blue:0xF4*1.0/0xFF alpha:1];
    lbTitle.text =AppShare.ButtonsTestText;
    lbTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    [scrollview addSubview:lbTitle];

    varHome = 1;
    varPower = 1;
    varMute = 1;
    varVolup = 1;
    varVolDown = 1;
    
    array = [[NSMutableArray alloc] init];
    int m = 1;
    if(isSupportMute())
    {
        [array addObject:[NSString stringWithFormat:@"%d. Flip Ring/Silent switch",m++]];
    }
    else
    {
        varMute = -2;
    }

    [array addObject:[NSString stringWithFormat:@"%d. Press Volume +",m++]];
    [array addObject:[NSString stringWithFormat:@"%d. Press Volume -",m++]];
    [array addObject:[NSString stringWithFormat:@"%d. Press Home Button",m++]];
    [array addObject:[NSString stringWithFormat:@"%d. Press Sleep/Wake button",m++]];
    
    
    UILabel *lbCountTime = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width - 60, rect.size.height - 60, 60, 60)];
    lbCountTime.tag = 10;
        //lbCountTime.center = CGPointMake(rect.size.width/2, rect.size.height/2);
    lbCountTime.textAlignment = NSTextAlignmentCenter;
    lbCountTime.textColor = [UIColor blackColor];
    [scrollview addSubview:lbCountTime];
    
    
    UIButton *btPassed;
    UILabel *lbTitleBT;
    UILabel *lbKhung;
    UILabel *lbNum;
    
    

    int dist = 70+80*tlw;
    int top = dist;
    int distance = 40*tlw;

   
        
    for(int i = 0; i<array.count;i++)
    {
        NSString *btName = [array objectAtIndex:i];
        if([[btName lowercaseString] rangeOfString:@"home"].location != NSNotFound)
        {
            UILabel *lbLine = [[UILabel alloc] initWithFrame:CGRectMake(50*tlw, top+19, rect.size.width - 100*tlw, 2)];
            lbLine.backgroundColor = [UIColor clearColor];
            lbLine.layer.borderWidth = 1;
            lbLine.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
            [scrollview addSubview:lbLine];
            top+=distance;
        }
       
        if([[btName lowercaseString] rangeOfString:@"Press Sleep"].location != NSNotFound)
        {
            UILabel *lbPlug = [[UILabel alloc] initWithFrame:CGRectMake(30*tlw, top, rect.size.width-100, 30)];
            lbPlug.backgroundColor = [UIColor clearColor];
            lbPlug.text = @"+";
            lbPlug.center = CGPointMake((rect.size.width-100)/2+30*tlw, top+distance/2);
            lbPlug.textAlignment = NSTextAlignmentCenter;
            [scrollview addSubview:lbPlug];
        }

        
        
        lbKhung = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width - 45, top-5, 20*tlw, 30*tlw)];
        lbKhung.backgroundColor = [UIColor clearColor];
        lbKhung.tag = i*10+2;
        lbKhung.layer.borderWidth = 2*tlw;
        lbKhung.layer.cornerRadius = 5;
        lbKhung.layer.borderColor = [UIColor redColor].CGColor;
        lbKhung.textAlignment = NSTextAlignmentCenter;
        [scrollview addSubview:lbKhung];
        

        
        lbTitleBT = [[UILabel alloc] initWithFrame:CGRectMake(30*tlw, top, rect.size.width-100, 25)];
        lbTitleBT.backgroundColor = [UIColor clearColor];
        lbTitleBT.textAlignment = NSTextAlignmentLeft;
        
        if([btName rangeOfString:@"Flip Ring"].location !=NSNotFound)
            lbTitleBT.text = AppShare.FlipRingSilentSwitchText;
        if([btName rangeOfString:@"Press Volume +"].location !=NSNotFound)
            lbTitleBT.text = AppShare.PressVolumeCongText;
        if([btName rangeOfString:@"Press Volume -"].location !=NSNotFound)
            lbTitleBT.text = AppShare.PressVolumeTruText;
        if([btName rangeOfString:@"Press Home"].location !=NSNotFound)
        {
            lbTitleBT.text = [NSString stringWithFormat:@"%@\n+",AppShare.PressHomeButtonText];
            lbTitleBT.numberOfLines = 0;
            lbTitleBT.frame = CGRectMake(30*tlw, top, rect.size.width-100, 50);
            lbTitleBT.textAlignment = NSTextAlignmentCenter;
             top+=distance;
        }
        if([btName rangeOfString:@"Press Sleep"].location !=NSNotFound)
        {
            lbTitleBT.text = AppShare.PressPowerButtonText;
            lbTitleBT.textAlignment = NSTextAlignmentCenter;
        }
        
        lbTitleBT.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
        [scrollview addSubview:lbTitleBT];
        
        btPassed = [UIButton buttonWithType:UIButtonTypeCustom];
        btPassed.frame = CGRectMake(rect.size.width-70, top, 50,50);
        btPassed.tag = i*10+1;
        [btPassed setBackgroundImage:[UIImage imageNamed:@"passed_gray.png"] forState:UIControlStateNormal];
        [scrollview addSubview:btPassed];
        btPassed.hidden = YES;
        top+=distance;
        //        }
    }
   
    scrollview.userInteractionEnabled = YES;
    NSLog(@"top:%d",top);
    NSLog(@"width:%f,height:%f",scrollview.contentSize.width,scrollview.contentSize.height);
    [self.view addSubview:scrollview];
}
- (void) Count
{
    if(status == BUTTONFUNC_FINISHED)
        return;
    NSLog(@"%s %d",__FUNCTION__,timeleft);
    timeleft --;
    if(timeleft<0)
    {
        
        timeleft = 0;
        return;
    }
    UILabel *lbCountTime  = (UILabel *)[self.view viewWithTag:10];
    lbCountTime.text = [NSString stringWithFormat:@"%ds",timeleft];
        
    [self performSelector:@selector(Count) withObject:Nil afterDelay:1];
}
- (void)eventHomePower:(NSNotification*)notify
{
    NSLog(@"%s %@",__FUNCTION__,notify);
    if(status == BUTTONFUNC_START)
    {
        [self receiveBackgroundByHome];
        [self receiveBackgroundByPower];
    }
}
- (void)resetTab
{
    tabCount = 0;
}
- (void)btNext:(NSNumber *)sender
{
    NSNumber *num = (NSNumber *)sender;
    if([num intValue] != callCount) return;
    callCount++;
    if(varVolup==0&&varVolDown==0&&varHome==0&&varPower==0&&(varMute==0||varMute==-2))
    {
        [self successCheck:@""];
    }
    else
    {
        NSString *data = @"";
        if(varVolup ==1)
        {
            if(data.length > 0)
                data = [NSString stringWithFormat:@"%@, Volume Up:Failed",data];
            else data = [NSString stringWithFormat:@"Volume Up:Failed"];
        }
        if(varVolDown==1)
        {
            if(data.length > 0)
                data = [NSString stringWithFormat:@"%@, Volume Down:Failed",data];
            else data = [NSString stringWithFormat:@"Volume Down:Failed"];
        }
        
        if(varHome==1)
        {
            if(data.length > 0)
                data = [NSString stringWithFormat:@"%@, Home:Failed",data];
            else data = [NSString stringWithFormat:@"Home:Failed"];
        }
        
        if(varPower==1)
        {
            if(data.length > 0)
                data = [NSString stringWithFormat:@"%@, Power:Failed",data];
            else data = [NSString stringWithFormat:@"Power:Failed"];
        }
        
        if(varMute==1)
        {
            if(data.length > 0)
                data = [NSString stringWithFormat:@"%@, Mute:Failed",data];
            else data = [NSString stringWithFormat:@"Mute:Failed"];
        }
        
        [self failedCheck:data];
    }
}
- (void) successCheck:(NSString*)desc
{
    if (status != BUTTONFUNC_FINISHED)
    {
        isPassed = YES;
        [self releaseResouce];
        [self.parentView updateResult:ID value:[NSString stringWithFormat:@" %@#%@#%@",key,@"PASSED",desc]];
    }
    
}
- (void) failedCheck:(NSString*)desc
{
    if (status != BUTTONFUNC_FINISHED)
    {
        isPassed = NO;
        [self releaseResouce];
        [self.parentView updateResult:ID value:[NSString stringWithFormat:@" %@#%@#%@",key,@"FAILED",desc]];
        
    }
}
- (void) releaseResouce
{
    [self endCheckRing];
    AppShare.isShowNotification = NO;
    if(self.view && self.view.superview)
    {
        [self.view removeFromSuperview];
    }
    
}
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param
{
    
     AppLog(@"status %d==%d BUTTONFUNC_FINISHED",status, BUTTONFUNC_FINISHED);
    if(status == BUTTONFUNC_FINISHED)
    {
        AppLog(@"reset for retest");
        status = BUTTONFUNC_NONE;
        isPassed = NO;
        varHome = 1;
        varPower = 1;
        varMute = 1;
        varVolup = 1;
        varVolDown = 1;
        countPress = 0;

        
        for(int i = 0; i<array.count;i++)
        {
             UILabel *lbKhung  = (UILabel *)[self.view viewWithTag:i*10+2];
            lbKhung.backgroundColor = [UIColor clearColor];
            lbKhung.layer.borderColor = [UIColor redColor].CGColor;
            lbKhung.text = @"";
        }
    }
    
    MPMusicPlayerController *iPod = [MPMusicPlayerController iPodMusicPlayer];
    iPod.volume = 0.5;
    preVol = iPod.volume;
   
     AudioSessionSetActive(true);
//    if(!self.view.superview)
//        [AppShare.viewController.view addSubview:self.view];
//    else
//        [AppShare.viewController.view bringSubviewToFront:self.view];
    
     
    status = BUTTONFUNC_START; // chuyen xuong startTestRing
    AppShare.isShowNotification = YES;
    [self performSelector:@selector(startTestRing) withObject:Nil afterDelay:2 ];
    
    [self performSelector:@selector(beginTest) withObject:Nil afterDelay:1 ];
    int TimeOut = 30;
    callCount++;
    [self performSelector:@selector(btNext:) withObject:[NSNumber numberWithInt:callCount] afterDelay:TimeOut];
    timeleft = TimeOut;
    [self performSelector:@selector(Count) withObject:Nil afterDelay:1];
    
}

- (void) checkTimeOut:(NSNumber*)num
{
    if([num intValue] == callCount)
    {
        if(status != BUTTONFUNC_FINISHED)
        {
            [self failedCheck:@"Timeout"];
        }
    }
}

-(void)beginTest
{
     status = BUTTONFUNC_START;
}

- (void)btClick:(id)sender
{
    UIButton *bt = (UIButton*)sender;
    int vt = bt.tag/10;
    int va = (bt.tag-1)%10;
    ButtonFuncLog(@"vt:%d va:%d,  bt.tag:%ld",vt,va, bt.tag);
    ButtonFuncLog(@"varVolup=%d varVolDown=%d varHome=%d varPower=%d varMute=%d",varVolup,varVolDown,varHome,varPower,varMute);
    NSString *btName = [array objectAtIndex:vt];
    ButtonFuncLog(@"%@",btName);
    
    if([[btName uppercaseString] rangeOfString:[@"Volume +" uppercaseString]].location!=NSNotFound)
        varVolup = va;
    if([[btName uppercaseString] rangeOfString:[@"Volume -" uppercaseString]].location!=NSNotFound)
        varVolDown = va;
    if([[btName uppercaseString] rangeOfString:[@"Home" uppercaseString]].location!=NSNotFound)
        varHome = va;
    if([[btName uppercaseString] rangeOfString:[@"Sleep" uppercaseString]].location!=NSNotFound)
        varPower = va;
    if([[btName uppercaseString] rangeOfString:[@"Ring/Silent" uppercaseString]].location!=NSNotFound)
        varMute = va;
    UILabel *lbKhung  = (UILabel *)[self.view viewWithTag:bt.tag+1];
    lbKhung.layer.borderColor = [UIColor colorWithRed:91.0/255 green:175.0/255 blue:95.0/255 alpha:1.0].CGColor;
    lbKhung.layer.backgroundColor = [UIColor whiteColor].CGColor;
    lbKhung.textColor = [UIColor colorWithRed:91.0/255 green:175.0/255 blue:95.0/255 alpha:1.0];
    lbKhung.text =  @"\u2713";//@"√";
    lbKhung.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:[UIFont systemFontSize]+10];
    //[UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    ButtonFuncLog(@"varVolup=%d varVolDown=%d varHome=%d varPower=%d varMute=%d",varVolup,varVolDown,varHome,varPower,varMute);
    if(varVolup!=1&&varVolDown!=1&&varHome!=1&&varPower!=1&&(varMute!=1))
    {
        [self successCheck:@""];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) receiveBackgroundByHome
{
    if(status == BUTTONFUNC_START)
    {
        [self.parentView updateButtonCheck:3 flag:1];
        status = BUTTONFUNC_START;
    }
}
- (void) receiveBackgroundByPower
{
    if(status == BUTTONFUNC_START)
    {
        [self.parentView updateButtonCheck:3 flag:1];
        status = BUTTONFUNC_START;
 //       [self.parentView updateButtonCheck:3 flag:1];
    }
}


- (void) volumeChanged:(float)num
{
    if(status == BUTTONFUNC_START)
    {
        
        if((num < preVol) || (num == preVol && num <= 0.1))
        {
            [self.parentView updateButtonCheck:1 flag:1];
        }
        if(num > preVol || ( num == preVol && num == 1.0))
        {
            [self.parentView updateButtonCheck:0 flag:1];
        }
        
       status = BUTTONFUNC_START;
    }
     preVol = num;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark mute switch


- (void) ringerButtonChange:(BOOL)ringer
{
    int limit = 2;
    if(status == BUTTONFUNC_START)
    {
        
        if(AppShare.isActive == NO)
        {
            [self resetRingTest];
            countPress = 0;
            
            return;
        }
        
        if(ringer==YES)
        {
            countPass ++;
            if(countPass>limit) countPass = limit;
            if(countFail!=limit) countFail = 0;// loai truong hop 1 lân
            
        }
        else
        {
            countFail ++;
            if(countFail>limit) countFail = limit;
            if(countPass!=limit) countPass = 0;// loai truong hop 1 lân
            
        }
        
        ButtonFuncLog(@"countFail:%d,countPass:%d",countFail,countPass);
        if(countFail == limit && countPass == limit)
        {
            countPress ++;
            if(ringer==YES)
                countFail = 0;
            else countPass = 0;
            if(countPress >= 1)
            {
                [self.parentView updateButtonCheck:2 flag:1];
                [self endCheckRing];
            }
            
        }
    }
}

-(void) resetRingTest
{
    if(status == BUTTONFUNC_START)
    {
        countFail = 0;
        countPass = 0;
        countPress = 0;
        ButtonFuncLog(@"resetRingTest : countPass =%d,countFail = %d, countPress=%d",countPass,countFail,countPress);
    }
}

- (void)startTestRing
{
   
    [self resetRingTest];
    [self.parentView startTestRingerButton];
}

- (void) endCheckRing
{
    [self.parentView endTestRingerButton];
    
}
@end
