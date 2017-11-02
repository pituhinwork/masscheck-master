//
//  MainTestViewController.m
//  MassTrade
//
//  Created by Admin on 9/28/17.
//  Copyright © 2017 GDT. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "MainTestViewController.h"
#import "Utilities.h"
#import "iDevice.h"
#import "AppDelegate.h"
#import "CustomerInfoViewController.h"
#import "TestListViewController.h"
#import "PassedViewController.h"
#import "FailedViewController.h"
#import "Reachability.h"
#import "DACircularProgressView.h"
#include <dlfcn.h>
//#import "Recorder.h"
#import "UICricle.h"

#import <Social/SLRequest.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>

#import "MessageBox.h"

//use for didReceiveMemoryWarning
#import <mach/mach.h>
#import <mach/mach_host.h>

#include <asl.h>


@interface MainTestViewController () <UIScrollViewDelegate, CBCentralManagerDelegate, RBDMuteSwitchDelegate>

@end

@implementation MainTestViewController

@synthesize telephone;
@synthesize wireless;
//@synthesize settingView;
//@synthesize questionView;

@synthesize wifi;
@synthesize vibrate;
@synthesize call;

@synthesize updateScreen;
@synthesize camera;
@synthesize checkPart;
@synthesize gps;
@synthesize recordBack;
@synthesize touchScreen;
@synthesize touchID;
@synthesize buttonFunc;
@synthesize bluetooth;
@synthesize appearance;

@synthesize acceptHomePress;
@synthesize actionRetest;
@synthesize aceptRetest;
@synthesize isRetest;
@synthesize finished;
@synthesize isAppRunning;
@synthesize damua;

@synthesize option1;
@synthesize option2;
@synthesize option3;
@synthesize currentStep;

@synthesize volumnUp;
@synthesize volumnDown;
@synthesize power;
@synthesize mute;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scrollView.delegate = self;
    
    option1 = 0;
    option2 = 0;
    option3 = 0;
    
    updateScreen = 0;
    mute = 1;
    power = 1;
    volumnUp = 1;
    volumnDown = 1;
    
    [_barImage1 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
    [_barImage2 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
    [_barImage3 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
    [_barImage4 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
    
    touchScreen = [[TouchScreen alloc] init];
    touchScreen.parentView = self;
    touchScreen.ID = 0;
    
    vibrationEnabled = 0;
    
    telephone       = [[Telephone alloc] init];
    wireless        = [[Wireless alloc] init];
    wifi            = [[Wifi alloc] init];
    vibrate         = [[Vibrate alloc] init];
    call            = [[Call alloc] init];
    camera          = [[Camera alloc] init];
    touchID         = [[TouchID alloc] init];
    checkPart       = [[CheckPart alloc] init];
    gps             = [[GPS alloc] init];
    recordBack      = [[RecordBack alloc] init];
    buttonFunc      = [[ButtonFunc alloc] init];
    bluetooth       = [[Bluetooth alloc] init];
    appearance      = [[Appearance alloc] init];
    
    actionRetest = NO;
    isRetest = NO;
    
    camera.ID = 4;
    camera.parentView = self;
    
    vibrate.parentView = self;
    vibrate.ID = 1;
    
    buttonFunc.parentView = self;
    buttonFunc.ID = 2;
    
    touchID.parentView = self;
    touchID.ID = 3;
    msgBox = Nil;
    
    recordBack.parentView = self;
    recordBack.ID = 5;
    
    wifi.parentView = self;
    wifi.ID = 6;
    

    
    bluetooth.parentView = self;
    bluetooth.ID = 7;
    
    gps.parentView = self;
    gps.ID = 8;
    
    call.parentView = self;
    call.ID = 9;
    call.manual = NO;
    
    appearance.parentView = self;
    appearance.ID = 10;
    [UIApplication sharedApplication].idleTimerDisabled = YES; // prevent sleep disable
    [touchScreen startAutoTest:@"TouchScreen" param:@";"];
    
    AppShare = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppShare.highligh = -1;
    AppShare.parentView = self;
    AppShare.checkListEnabled = NO;
    AppShare.checkListNum = 0;
    AppShare.canCheck = 1;
    
    IMMTimer = Nil;
    bluetoothTimer = Nil;
    buttonFuncTimer = Nil;
    if(AppShare.tableData == Nil)
        AppShare.tableData = [[NSMutableArray alloc] init];
    else [AppShare.tableData removeAllObjects];
    
    IMMTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(readRequest) userInfo:nil repeats:YES];
    
    currentStep = -1;
    [_phoneButtonImage setImage:[UIImage imageNamed:@"phone_volumeup"]];
    [_subTitleLabel setText:@"Press on Volume +"];

    _bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self
                                                             queue:nil
                                                           options:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0]
                                                                                               forKey:CBCentralManagerOptionShowPowerAlertKey]];
    
    [self checkCamera];
    [self performSelector:@selector(accessMicrophone) withObject:Nil afterDelay:1];
    [self performSelector:@selector(accessCamera) withObject:Nil afterDelay:1];
    
    [_loadingIndicator stopAnimating];
    
    if(checkLists == Nil)
        checkLists = [[NSMutableArray alloc] init];
    else [checkLists removeAllObjects];
    [checkLists addObject:@"TOUCHSCREEN"];
    [checkLists addObject:@"TOUCHID"];
    [checkLists addObject:@"CAMERA"];
    [checkLists addObject:@"VIBRATION"];
    [checkLists addObject:@"BTFUNC"];
    [checkLists addObject:@"RECORDBACK"];
    [checkLists addObject:@"WIFI"];
    [checkLists addObject:@"BLUETOOTH"];
    [checkLists addObject:@"GPS"];
    [checkLists addObject:@"CALL"];
    [checkLists addObject:@"APPEARANCE"];
    
//    self.timerView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 30.0f, 40.0f, 40.0f)];
//    self.timerView.roundedCorners = YES;
//    self.timerView.trackTintColor = [UIColor colorWithRed:29 green:179 blue:99 alpha:1];
//    self.timerView.progressTintColor = [UIColor colorWithRed:229 green:244 blue:236 alpha:1];
//    self.timerView.thicknessRatio = 1.0f;
//    self.timerView.clockwiseProgress = NO;
//    
//    [self.view addSubview:self.timerView];
//    [self.view bringSubviewToFront:self.timerView];
//    [NSTimer scheduledTimerWithTimeInterval:1 target:iDevice selector:@selector(startCommand) userInfo:nil repeats:YES];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // This delegate method will monitor for any changes in bluetooth state and respond accordingly

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (AppShare.dismissable == YES) {
        AppShare.dismissable = NO;
        if (IMMTimer != Nil)
        {
            [IMMTimer invalidate];
            IMMTimer = Nil;
        }
        if (bluetoothTimer != Nil)
        {
            [bluetoothTimer invalidate];
            bluetoothTimer = Nil;
        }
        if (buttonFuncTimer != Nil)
        {
            [buttonFuncTimer invalidate];
            buttonFuncTimer = Nil;
        }
//        if (telephone) {
//            [telephone release];
//            [call release];
//            [appearance release];
//            [touchID release];
//            [touchScreen release];
//            [bluetooth release];
//            [buttonFunc release];
//            [camera release];
//            [gps release];
//            [recordBack release];
//            [vibrate release];
//            [wifi release];
//        }
        
        
        option1 = 0;
        option2 = 0;
        option3 = 0;
        
        updateScreen = 0;
        mute = 1;
        power = 1;
        volumnUp = 1;
        volumnDown = 1;
        
        [_barImage1 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
        [_barImage2 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
        [_barImage3 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
        [_barImage4 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
        
        touchScreen = [[TouchScreen alloc] init];
        touchScreen.parentView = self;
        touchScreen.ID = 0;
        
        vibrationEnabled = 0;
        
        telephone       = [[Telephone alloc] init];
        wireless        = [[Wireless alloc] init];
        wifi            = [[Wifi alloc] init];
        vibrate         = [[Vibrate alloc] init];
        call            = [[Call alloc] init];
        camera          = [[Camera alloc] init];
        touchID         = [[TouchID alloc] init];
        checkPart       = [[CheckPart alloc] init];
        gps             = [[GPS alloc] init];
        recordBack      = [[RecordBack alloc] init];
        buttonFunc      = [[ButtonFunc alloc] init];
        bluetooth       = [[Bluetooth alloc] init];
        appearance      = [[Appearance alloc] init];
        
        actionRetest = NO;
        isRetest = NO;
        
        camera.ID = 4;
        camera.parentView = self;
        
        vibrate.parentView = self;
        vibrate.ID = 1;
        
        buttonFunc.parentView = self;
        buttonFunc.ID = 2;
        
        touchID.parentView = self;
        touchID.ID = 3;
        msgBox = Nil;
        
        recordBack.parentView = self;
        recordBack.ID = 5;
        
        wifi.parentView = self;
        wifi.ID = 6;
        
        
        
        bluetooth.parentView = self;
        bluetooth.ID = 7;
        
        gps.parentView = self;
        gps.ID = 8;
        
        call.parentView = self;
        call.ID = 9;
        call.manual = NO;
        
        appearance.parentView = self;
        appearance.ID = 10;
        
        [touchScreen startAutoTest:@"TouchScreen" param:@";"];
        AppShare = (AppDelegate *)[UIApplication sharedApplication].delegate;
        AppShare.parentView = self;

        AppShare.highligh = -1;
        AppShare.checkListEnabled = NO;
        AppShare.checkListNum = 0;
        AppShare.canCheck = 1;
        
        if (IMMTimer != Nil)
        {
            [IMMTimer invalidate];
            IMMTimer = Nil;
        }
        if (bluetoothTimer != Nil)
        {
            [bluetoothTimer invalidate];
            bluetoothTimer = Nil;
        }
        if (buttonFuncTimer != Nil)
        {
            [buttonFuncTimer invalidate];
            buttonFuncTimer = Nil;
        }
        if(AppShare.tableData == Nil)
            AppShare.tableData = [[NSMutableArray alloc] init];
        else [AppShare.tableData removeAllObjects];
        
        IMMTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(readRequest) userInfo:nil repeats:YES];
        
        currentStep = -1;
        [_phoneButtonImage setImage:[UIImage imageNamed:@"phone_volumeup"]];
        [_subTitleLabel setText:@"Press on Volume +"];
        
        _bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self
                                                                 queue:nil
                                                               options:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0]
                                                                                                   forKey:CBCentralManagerOptionShowPowerAlertKey]];
        
        [self checkCamera];
        [self performSelector:@selector(accessMicrophone) withObject:Nil afterDelay:1];
        [self performSelector:@selector(accessCamera) withObject:Nil afterDelay:1];
        
        [_loadingIndicator stopAnimating];
        
        if(checkLists == Nil)
            checkLists = [[NSMutableArray alloc] init];
        else [checkLists removeAllObjects];
        [checkLists addObject:@"TOUCHSCREEN"];
        [checkLists addObject:@"TOUCHID"];
        [checkLists addObject:@"CAMERA"];
        [checkLists addObject:@"VIBRATION"];
        [checkLists addObject:@"BTFUNC"];
        [checkLists addObject:@"RECORDBACK"];
        [checkLists addObject:@"WIFI"];
        [checkLists addObject:@"BLUETOOTH"];
        [checkLists addObject:@"GPS"];
        [checkLists addObject:@"CALL"];
        [checkLists addObject:@"APPEARANCE"];
        
        _pageControl.currentPage = 0;
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
        return;
    }
    if (AppShare.checkListEnabled == YES) {
        if (recordBack && _pageControl.currentPage != 0) {
            [recordBack releaseResouce];
            recordBack = [[RecordBack alloc] init];
            recordBack.ID = 5;
            recordBack.parentView = self;
        }
        currentStep = -1;
        switch (AppShare.checkListNum) {
            case 0:
            {
                // TouchScreen Test
                _pageControl.currentPage = 0;
                [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                [touchScreen startAutoTest:@"TouchScreen" param:@";"];
            }
                break;
            case 1:
                // Vibration Test
            {
                _pageControl.currentPage = 1;
                [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                [vibrate startAutoTest:@"VIBRATION" param:@";"];
            }
                break;
            case 2:
            {
                // BTFunc Test
                _pageControl.currentPage = 2;
                currentStep = 0;
                [_phoneButtonImage setImage:[UIImage imageNamed:@"phone_volumeup"]];
                [_subTitleLabel setText:@"Press on Volume +"];
                [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                [buttonFunc startAutoTest:@"BTFUNC" param:@";"];
                [_buttonTestAlert setHidden:YES];
                [self startButtonTimer];
            }
                break;
            case 3:
                // TouchID Test
            {
                _pageControl.currentPage = 0;
                [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
            }
                break;
            case 4:
                // Camera Test
            {
                _pageControl.currentPage = 0;
                [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                NSString *keys = @"CAMERA";
                [camera startAutoTest:@"CAMERA" param:[keys stringByReplacingOccurrencesOfString:@"CAM" withString:@""]];
            }
                break;
            case 5:
            {
                // RecordBack Test
                _pageControl.currentPage = 3;
                [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                [recordBack startAutoTest:@"RECORDBACK" param:@";"];
            }
                break;
            case 6:
                // Wifi Test
                {
                    _pageControl.currentPage = 4;
                    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                    Reachability *reachabilitys = [Reachability reachabilityWithHostname:@"google.com"];
                    NetworkStatus Netstatus = [reachabilitys currentReachabilityStatus];
    //                [reachability release];
                    if (Netstatus == ReachableViaWiFi) {
                        [wifi startAutoTest:@"WIFI" param:@";"];
                    }
                    else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable wi-fi to test." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:Nil, nil];
                        [alert show];
                    }
                    
                }
                break;
            case 7:
                // bluetooth Test
            {
                _pageControl.currentPage = 5;
                [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                if (_bluetoothManager.state == CBCentralManagerStatePoweredOff) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable Bluetooth to test." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:Nil, nil];
                    [alert show];
                }
                else {
                    [self performSelector:@selector(startBluetoothDetection) withObject:nil afterDelay:1];
                }
            }
                break;
            case 8:
                // GPS Test
            {
                _pageControl.currentPage = 6;
                [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                [_loadingIndicator startAnimating];
                [gps startAutoTest:@"GPS" param:@";"];
            }
                break;
            case 9:
                // Call Test
            {
                _pageControl.currentPage = 7;
                [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                [call startAutoTest:@"CALL" param:@";"];
            }
                break;
            case 10:
            {
                // Appearance Test
                _pageControl.currentPage = 8;
                [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                [appearance startAutoTest:@"APPEARANCE" param:@";"];
                [self performSelector:@selector(checkAppearance) withObject:nil afterDelay:1];
            }
                break;
            default:
                break;
        }
        [self changeTitleLabel];
    }
}

- (void) checkAppearance {
    if(option1==0&&option2==0&&option3==0)
        [appearance successCheck:[NSString stringWithFormat:@"0,0,0"]];
    else [appearance failedCheck:[NSString stringWithFormat:@"%d,%d,%d",option1,option2,option3]];
}

#pragma mark -
#pragma mark Methods Viewcontroller
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    acceptHomePress = NO;
    
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    acceptHomePress = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [camera recieveCameraWarning];
    [self report_memory];
}
- (IBAction)testButtonTapped:(id)sender {
    currentStep = -1;
    
    switch (_pageControl.currentPage) {
        case 0:
            [touchID startAutoTest:@"TOUCHID" param:@";"];
            break;
        case 2:
            currentStep = 0;
            [_phoneButtonImage setImage:[UIImage imageNamed:@"phone_volumeup"]];
            [_subTitleLabel setText:@"Press on Volume +"];
            [buttonFunc startAutoTest:@"BTFUNC" param:@";"];
            [_buttonTestAlert setHidden:YES];
            [self startButtonTimer];
            break;
        case 3:
            [recordBack releaseResouce];
            recordBack = [[RecordBack alloc] init];
            recordBack.ID = 5;
            recordBack.parentView = self;
            [recordBack startAutoTest:@"RECORDBACK" param:@";"];
            break;
        case 4:
            {
                Reachability *reachability = [Reachability reachabilityWithHostname:@"google.com"];
                NetworkStatus Netstatus = [reachability currentReachabilityStatus];
//                [reachability release];
                if (Netstatus == ReachableViaWiFi) {
                    [wifi startAutoTest:@"WIFI" param:@";"];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable wi-fi to test." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:Nil, nil];
                    [alert show];
                }
            }
            
            break;
        case 5:
            {
                if (_bluetoothManager.state == CBCentralManagerStatePoweredOff) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable Bluetooth to test." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:Nil, nil];
                    [alert show];
                }
                else {
                    [self performSelector:@selector(startBluetoothDetection) withObject:nil afterDelay:1];
                }
            }
            break;
        case 6:
            [_loadingIndicator startAnimating];
            [gps startAutoTest:@"GPS" param:@";"];
            break;
        case 8:
            [appearance startAutoTest:@"APPEARANCE" param:@";"];
            break;
        default:
            break;
    }
    if (_pageControl.currentPage == 8) {    
        if(option1==0&&option2==0&&option3==0)
            [appearance successCheck:[NSString stringWithFormat:@"0,0,0"]];
        else [appearance failedCheck:[NSString stringWithFormat:@"%d,%d,%d",option1,option2,option3]];
    }
}

- (void) startBluetoothDetection {
    NSString *stateSt = @"";
    switch(_bluetoothManager.state)
    {
        case CBCentralManagerStateResetting: stateSt = @"FAILED"; break;
        case CBCentralManagerStateUnsupported: stateSt = @"FAILED"; break;
        case CBCentralManagerStateUnauthorized: stateSt = @"FAILED"; break;
        case CBCentralManagerStatePoweredOff: stateSt = @"FAILED"; break;
        case CBCentralManagerStatePoweredOn: stateSt = @"PASSED"; break;
        default: stateSt = @"FAILED"; break;
    }
    [self updateResult:7 value:[NSString stringWithFormat:@" %@#%@#%@",@"Bluetooth",stateSt,@";"]];
}

- (IBAction)switchValueChanged:(id)sender {
    option1=(option1==1)?0:1;
}
- (IBAction)switchValue2Changed:(id)sender {
    option2=(option2==1)?0:1;
}
- (IBAction)switchValue3Changed:(id)sender {
    option3=(option3==1)?0:1;
}
- (IBAction)okButtonTapped:(id)sender {
    if (_pageControl.currentPage != 1) {
        [call startAutoTest:@"CALL" param:@";"];
    }
    else {
        [self.vibrate sendSuccess:1];
    }
}
- (IBAction)cancelButtonTapped:(id)sender {
    if (_pageControl.currentPage != 1) {
        [self updateResult:9 value:[NSString stringWithFormat:@" %@#%@#%@",@"Call",@"FAILED",@";"]];
    }
    else {
        [self.vibrate sendSuccess:0];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [aScrollView setContentOffset: CGPointMake(aScrollView.contentOffset.x, 0)];
    int flag = 0;

    _pageControl.currentPage = (_scrollView.contentOffset.x + CGRectGetWidth(_scrollView.frame) / 2) / CGRectGetWidth(_scrollView.frame);

    [self changeTitleLabel];
}

- (void) changeTitleLabel {
    switch (_pageControl.currentPage) {
        case 0:
            [_testLabel setText:@"Touch ID"];
            break;
        case 1:
            [_testLabel setText:@"Vibration"];
            break;
        case 2:
            [_testLabel setText:@"Buttons"];
            break;
        case 3:
            [_testLabel setText:@"Speaker & Mic"];
            break;
        case 4:
            [_testLabel setText:@"Wi-Fi"];
            break;
        case 5:
            [_testLabel setText:@"Bluetooth"];
            break;
        case 6:
            [_testLabel setText:@"GPS"];
            break;
        case 7:
            [_testLabel setText:@"Call"];
            break;
        case 8:
            [_testLabel setText:@"Appearance"];
            break;
        default:
            break;
    }
}

- (IBAction)skipButtonTapped:(id)sender {
    if (recordBack && _pageControl.currentPage != 0) {
        [recordBack releaseResouce];
        recordBack = [[RecordBack alloc] init];
        recordBack.ID = 5;
        recordBack.parentView = self;
    }
    if (_pageControl.currentPage == 8) {
        CustomerInfoViewController* testController = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerInfoViewController"];
        testController.gps = gps;
        [self presentViewController:testController animated:YES completion:nil];
        AppShare.canCheck = 0;
        return;
    }
    switch (_pageControl.currentPage) {
        case 1:
            updateScreen = 1;
            [self updateResult:1 value:[NSString stringWithFormat:@" %@#%@#%@",@"Vibration",@"FAILED",@";"]];
            break;
        case 2:
            updateScreen = 1;
            [self updateResult:2 value:[NSString stringWithFormat:@" %@#%@#%@",@"BTFunc",@"FAILED",@";"]];
            break;
        case 0:
            updateScreen = 1;
            [self updateResult:3 value:[NSString stringWithFormat:@" %@#%@#%@",@"TouchID",@"FAILED",@";"]];
            break;
        case 3:
            updateScreen = 1;
            [self updateResult:5 value:[NSString stringWithFormat:@" %@#%@#%@",@"RecordBack",@"FAILED",@";"]];
            break;
        case 4:
            updateScreen = 1;
            [self updateResult:6 value:[NSString stringWithFormat:@" %@#%@#%@",@"WIFI",@"FAILED",@";"]];
            break;
        case 5:
            updateScreen = 1;
            [self updateResult:7 value:[NSString stringWithFormat:@" %@#%@#%@",@"Bluetooth",@"FAILED",@";"]];
            break;
        case 6:
            updateScreen = 1;
            [self updateResult:8 value:[NSString stringWithFormat:@" %@#%@#%@",@"GPS",@"FAILED",@";"]];
            break;
        case 7:
            updateScreen = 1;
            [self updateResult:9 value:[NSString stringWithFormat:@" %@#%@#%@",@"Call",@"FAILED",@";"]];
            break;
        case 8:
            updateScreen = 1;
            [self updateResult:10 value:[NSString stringWithFormat:@" %@#%@#%@",@"APPEARANCE",@"FAILED",@";"]];
            break;
        default:
            break;
    }
    _pageControl.currentPage = _pageControl.currentPage + 1;
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
//    if (_pageControl.currentPage == 2) {
//        [self startButtonTimer];
//    }
    [self changeTitleLabel];

}

- (void) updateButtonCheck:(int)num flag:(int)flag
{
    
    if (num == currentStep) {
        [buttonFuncTimer invalidate];
        buttonFuncTimer = nil;
        switch (num) {
            case 0:
                volumnUp -= flag;
                if (volumnUp == 0) {
                    [_barImage1 setBackgroundColor:[UIColor colorWithRed:29 green:179 blue:99 alpha:1]];
                }
                else {
                    [_barImage1 setBackgroundColor:[UIColor colorWithRed:244 green:96 blue:54 alpha:1]];
                }
                break;
            case 1:
                volumnDown -= flag;
                if (volumnDown == 0) {
                    [_barImage2 setBackgroundColor:[UIColor colorWithRed:29 green:179 blue:99 alpha:1]];
                }
                else {
                    [_barImage2 setBackgroundColor:[UIColor colorWithRed:244 green:96 blue:54 alpha:1]];
                }
                break;
            case 2:
                mute -= flag;
                if (mute == 0) {
                    [_barImage3 setBackgroundColor:[UIColor colorWithRed:29 green:179 blue:99 alpha:1]];
                }
                else {
                    [_barImage3 setBackgroundColor:[UIColor colorWithRed:244 green:96 blue:54 alpha:1]];
                }
                break;
            case 3:
                power -= flag;
                if (power == 0) {
                    [_barImage4 setBackgroundColor:[UIColor colorWithRed:29 green:179 blue:99 alpha:1]];
                }
                else {
                    [_barImage4 setBackgroundColor:[UIColor colorWithRed:244 green:96 blue:54 alpha:1]];
                }
                break;
            default:
                break;
        }
        currentStep += 1;
        if (num == 3) {
            if(volumnUp==0&&volumnDown==0&&mute==0&&power==0)
            {
                [self.buttonFunc successCheck:@""];
            }
            else
            {
                NSString *data = @"";
                if(volumnUp ==1)
                {
                    if(data.length > 0)
                        data = [NSString stringWithFormat:@"%@, Volume Up:Failed",data];
                    else data = [NSString stringWithFormat:@"Volume Up:Failed"];
                }
                if(volumnDown==1)
                {
                    if(data.length > 0)
                        data = [NSString stringWithFormat:@"%@, Volume Down:Failed",data];
                    else data = [NSString stringWithFormat:@"Volume Down:Failed"];
                }
                
                if(mute==1)
                {
                    if(data.length > 0)
                        data = [NSString stringWithFormat:@"%@, Mute:Failed",data];
                    else data = [NSString stringWithFormat:@"Mute:Failed"];
                }
                
                if(power==1)
                {
                    if(data.length > 0)
                        data = [NSString stringWithFormat:@"%@, Power:Failed",data];
                    else data = [NSString stringWithFormat:@"Power:Failed"];
                }
                [self.buttonFunc failedCheck:data];
            }
            currentStep = -1;
            mute = 1;
            power = 1;
            volumnUp = 1;
            volumnDown = 1;
            [_barImage1 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
            [_barImage2 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
            [_barImage3 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
            [_barImage4 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
        }

        if (currentStep > 0) {
            [buttonFunc beginTest];
            [self startButtonTimer];
        }
        switch (currentStep) {
            case 0:
                [_phoneButtonImage setImage:[UIImage imageNamed:@"phone_volumeup"]];
                [_subTitleLabel setText:@"Press on Volume +"];
                break;
            case 1:
                [_phoneButtonImage setImage:[UIImage imageNamed:@"phone_volumeup"]];
                [_subTitleLabel setText:@"Press on Volume -"];
                break;
            case 2:
                [_phoneButtonImage setImage:[UIImage imageNamed:@"phone_volumeup"]];
                [_subTitleLabel setText:@"Press Ringer"];
                break;
            case 3:
                [_phoneButtonImage setImage:[UIImage imageNamed:@"phone_homepower"]];
                [_subTitleLabel setText:@"Press Home and Power button at the same time"];
                break;
            default:
                break;
        }
    }
}


- (void) timerHandler {
    [self updateButtonCheck:currentStep flag:0];
//    [self performSelector:@selector(updateButtonCheck:flag:) withObject:currentStep withObject:0];
}

- (void) startButtonTimer {
    if (buttonFuncTimer != Nil) {
        [buttonFuncTimer invalidate];
        buttonFuncTimer = Nil;
    }
    buttonFuncTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
}

- (IBAction)testListButtonTapped:(id)sender {
    TestListViewController* testController = [self.storyboard instantiateViewControllerWithIdentifier:@"TestListViewController"];
    [self presentViewController:testController animated:YES completion:nil];
}
- (IBAction)pageControlValueChanged:(id)sender {
//    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
}

#pragma mark -
#pragma mark methods mute switch
- (void)beginDetection
{
    [[RBDMuteSwitch sharedInstance] setDelegate:self];
    [[RBDMuteSwitch sharedInstance] detectMuteSwitch];
}
- (void)startTestRingerButton
{
    [self beginDetection];
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(beginDetection) userInfo:nil repeats:YES];
}
- (void)endTestRingerButton
{
    if(updateTimer)
    {
        [updateTimer invalidate];
        updateTimer = nil;
    }
    [[RBDMuteSwitch sharedInstance] setDelegate:nil];
    
}

#pragma mark -
#pragma mark MuteSwitch Delegate methods
- (void)isMuted:(BOOL)muted
{    
    [self.buttonFunc ringerButtonChange:muted];
    
}

#pragma mark -
#pragma mark run when start methods
- (void) accessMicrophone
{
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted)
     {
     }];
}
- (void)acceptGPS
{
    [gps acceptGPS];
}
- (void)accessCamera
{
    @try
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)])
        {
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            }];
        }
    }
    @catch (NSException *ex)
    {
    }
}

- (void)acceptMedia
{
    if(AppShare.iOS >= (float)8.0)
    {
        MPMediaLibraryAuthorizationStatus AuthoriStatus = [MPMediaLibrary authorizationStatus];
        if ([MPMediaLibrary respondsToSelector:@selector(requestAuthorization:)])
        {
            [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus authorizationStatus)
             {
             }];
        }
    }
}

- (void) checkCamera
{
    AppShare.isExistedMainCamera = isExistMainCamera();
    AppShare.isExistedFrontCamera = isExistFrontCamera();
}

-(void) report_memory {

}
- (float)getIOS
{
    NSString *currentIOS = [UIDevice currentDevice].systemVersion;
    return [currentIOS floatValue];
}

- (NSString*)getModel
{
    NSString *model = [NSString stringWithFormat:@"%@",[UIDevice currentDevice].model];
    return model;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)readRequest
{
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *requestFileName = [NSString stringWithFormat:@"%@/requestHitek.txt", [paths objectAtIndex:0]];
    if([[NSFileManager defaultManager] fileExistsAtPath:requestFileName])
    {
        NSError *er;
        NSString *cmdStr = [NSString stringWithContentsOfFile:requestFileName encoding:NSUTF8StringEncoding error:&er];
        
        if(cmdStr && ([cmdStr length] > 2))
        {
            NSString *cmdStrBK = [NSString stringWithFormat:@"%@",cmdStr];
            
            NSString *FileNamebk = [NSString stringWithFormat:@"%@requestBK.txt", NSTemporaryDirectory()];
            [cmdStrBK writeToFile:FileNamebk atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            //cmdStr = [cmdStr uppercaseString];
            NSString *previousStr = [NSString stringWithFormat:@"%@", cmdStr];
            cmdStr = [cmdStr stringByReplacingOccurrencesOfString:@"$" withString:@""];
            
            NSArray *objs = [cmdStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@#"]];
            // ViewControllerLog(@"[objs count]:%d",[objs count]);
            if(objs && ([objs count] >= 3))
            {
                NSString *cmdName = [objs objectAtIndex:0];cmdName = [cmdName uppercaseString];
                NSString *cmdNote = [objs objectAtIndex:2];
                //  ViewControllerLog(@"readRequest cmdname:%@,note:%@",cmdName,cmdNote);
                if(cmdName && ([cmdName length] >= 1) && ([cmdStr rangeOfString:previousStr].location == NSNotFound))
                {
                    if([cmdName rangeOfString:@"IMMTEST"].location != NSNotFound)
                    {
                        AppShare.accessRun = NO;
                        
                        AppShare.firstStop = NO; AppShare.isTestFail = NO;
                        // settingView.isShow = NO;// cho chay retest
                        
                        
                        [AppShare.tableData removeAllObjects];
                        
                        if (IMMTimer != nil)
                        {
                            [IMMTimer invalidate];
                            IMMTimer = nil;
                        }
                        
                        
                        [self createTableIzap:cmdNote];
                    }
                }
            }
        }
    } //else ViewControllerLog(@"file == no");
}

-(NSString *) readFromClip
{
    UIPasteboard *thePasteboard = [UIPasteboard generalPasteboard];
    NSString *pasteboardString = thePasteboard.string;
    //AppLog(@"%@", pasteboardString);
    return pasteboardString;
}

// moi phep test chay theo thu tu cua app sap san , lay request tu file
- (void) createTableIzap:(NSString *)command
{
    
    if(msgBox)
        [msgBox performSelector:@selector(onclick) withObject:nil afterDelay:1];
    //command = [command uppercaseString];
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    count = 0;
    finished = NO;
    NSArray *objs = [command componentsSeparatedByString:@";"];
    
    for(int i=0; i < [objs count]; i++)
    {
        NSString *str = [objs objectAtIndex:i];
        
        if(str.length > 1)
        {
            //ViewControllerLog(@"%@",str);
            if([[str uppercaseString] rangeOfString:@"WFSTREAM"].location != NSNotFound)
                [AppShare.tableData addObject:str];
            else [AppShare.tableData addObject:[str uppercaseString]];
            [AppShare.arrayRetest addObject:[NSNumber numberWithBool:NO]];
        }
    }
//      if(tableResult)
//        [tableResult reloadData];
//    flagRunTest = 0;// cho chay lai runtest
//    [self runTest];// create value default and id config and start
}

- (void)updateParent:(int)vt value:(NSString*)result
{
    tempVt = vt;
    tempString = result;
    [self performSelector:@selector(callFunction:) withObject:nil afterDelay:1];
}

- (void) callFunction {
    [self updateResult:tempVt value:tempString];
}

- (void)updateResult:(int)vt value:(NSString*)result
{
    [buttonFuncTimer invalidate];
    buttonFuncTimer = nil;
    currentStep = -1;
    
    switch (vt) {
        case 1:
            if ([[result uppercaseString] containsString:@"VIBRAT"]) {
            vibrate = [[Vibrate alloc] init];
            vibrate.ID = 1;
            vibrate.parentView = self;
            }
            break;

        case 5:
            [recordBack releaseResouce];
            recordBack = [[RecordBack alloc] init];
            recordBack.ID = 5;
            recordBack.parentView = self;
            break;
            
        default:
            break;
    }
   
    if(vt >= 0 && vt < AppShare.tableData.count && _pageControl.currentPage != 8)
    {
        if([[result uppercaseString] rangeOfString:@"FAILED"].location != NSNotFound)
        {
            FailedViewController* testController = [self.storyboard instantiateViewControllerWithIdentifier:@"FailedViewController"];
            [self presentViewController:testController animated:YES completion:nil];
        }
        else
        {
            PassedViewController* testController = [self.storyboard instantiateViewControllerWithIdentifier:@"PassedViewController"];
            [self presentViewController:testController animated:YES completion:nil];
        }
        
    }
    [_loadingIndicator stopAnimating];
    if(vt >= 0 && vt < AppShare.tableData.count)
    {
        
//        [self writeLog:result];
//        
        [AppShare.tableData replaceObjectAtIndex:vt withObject:[result uppercaseString]];

        if([[result uppercaseString] rangeOfString:@"FAILED"].location != NSNotFound)
        {
            AppShare.failedCount++;
        }
        else
        {
            AppShare.passedCount++;
        }
        if (AppShare.checkListEnabled == YES) {
            AppShare.checkListEnabled = NO;
            {
                int current = -1;
                int i = 0;
                int j = 0;
                int tempCount = checkLists.count;
                int flag = 0;
                for (i = 0; i < tempCount; i++) {
                    for (j = 0; j < tempCount; j++)
                    {
                        if ([[AppShare.tableData objectAtIndex:j] containsString:[checkLists objectAtIndex:i]]) {
                            if ([[AppShare.tableData objectAtIndex:j] containsString:@"PASSED"] || [[AppShare.tableData objectAtIndex:j] containsString:@"FAILED"]) {
                                flag = 1;
                            }
                            else {
                                flag = 0;
                            }
                            current = j;
                            break;
                        }
                    }
                    if (flag == 0) {
                        break;
                    }
                }
                if (i == tempCount) {
                    current = 10;
                }
                switch (current) {
                    case 0:
                    {
                        // TouchScreen Test
                        _pageControl.currentPage = 0;
                        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                    }
                        break;
                    case 1:
                    {
                        // Vibration Test
                        result = @"Camera";
                        _pageControl.currentPage = 1;
                        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                    }
                        break;
                    case 2:
                        // BTFunc Test
                    {
                        _pageControl.currentPage = 2;
                        result = @"Vibration";
                        currentStep = 0;
                        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                    }
                        break;
                    case 3:
                    {
                        // TouchID Test
                        _pageControl.currentPage = 0;
                        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                    }
                        break;
                    case 4:
                    {
                        // Camera Test
                        result = @"TouchID";
                        _pageControl.currentPage = 0;
                        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                    }
                        break;
                    case 5:
                        // RecordBack Test
                    {
                        _pageControl.currentPage = 3;
                        result = @"BTFunc";
                        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                    }
                        break;
                    case 6:
                        // Wifi Test
                    {
                        _pageControl.currentPage = 4;
                        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                        Reachability *reachability = [Reachability reachabilityWithHostname:@"google.com"];
                        NetworkStatus Netstatus = [reachability currentReachabilityStatus];
//                        [reachability release];
                        if (Netstatus == ReachableViaWiFi) {
                            [wifi startAutoTest:@"WIFI" param:@";"];
                        }
                        else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable wi-fi to test." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:Nil, nil];
                            [alert show];
                        }
                    }
                        break;
                    case 7:
                        // bluetooth Test
                    {
                        _pageControl.currentPage = 5;
                        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                        if (_bluetoothManager.state == CBCentralManagerStatePoweredOff) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable Bluetooth to test." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:Nil, nil];
                            [alert show];
                        }
                        else {
                            [self performSelector:@selector(startBluetoothDetection) withObject:nil afterDelay:2];
                        }
                    }
                        break;
                    case 8:
                        // GPS Test
                    {
                        _pageControl.currentPage = 6;
                        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                    }
                        break;
                    case 9:
                        // Call Test
                    {
                        _pageControl.currentPage = 7;
                        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                    }
                        break;
                    case 10:
                        // Appearance Test
                    {
                        _pageControl.currentPage = 8;
                        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        else if (vt != 0) {
            if (updateScreen == 0) {
                if (_pageControl.currentPage == 6) {
                    [_loadingIndicator stopAnimating];
                }
                if (_pageControl.currentPage != 0) {
                    _pageControl.currentPage += 1;
                }
                [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
            }
            else {
                updateScreen = 0;
            }
        }
        
    }//vt>=0
    
    [self finishTest:result position:vt];
    [self changeTitleLabel];
    
}

- (void)finishTest:(NSString*)str position:(int)pos
{
//    ViewControllerLog(@"finishTest : %d ------------------------------------------->",pos);
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    int vt = pos;
    vt++;

    if(vt < AppShare.tableData.count)
    {
        int x = _pageControl.currentPage;
        if ([str containsString:@"Camera"]) {
            _pageControl.currentPage = 1;
            [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
            [vibrate startAutoTest:@"VIBRATION" param:@";"];
        }
        else if (_pageControl.currentPage == 0 && [str containsString:@"TouchID"]) {
            NSString *key = @"CAMERA";
            _pageControl.currentPage = 0;
            [camera startAutoTest:@"CAMERA" param:[key stringByReplacingOccurrencesOfString:@"CAM" withString:@""]];
        }
        else if ([str containsString:@"Vibration"] && _pageControl.currentPage == 2) {
            currentStep = 0;
            [buttonFunc startAutoTest:@"BTFUNC" param:@";"];
            [_buttonTestAlert setHidden:YES];
            [self startButtonTimer];
        }
        else if ([str containsString:@"BTFunc"] && _pageControl.currentPage == 3) {
            [recordBack startAutoTest:@"RECORDBACK" param:@";"];
        }
        AppShare.highligh = vt;
    }
    else
    {
    }
    if (_pageControl.currentPage == 8 && vt == 11) {
        CustomerInfoViewController* testController = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerInfoViewController"];
        testController.gps = gps;
        [self presentViewController:testController animated:YES completion:nil];
        AppShare.canCheck = 0;
        return;
    }
    return;
    
}

- (void) callCheat
{
    //return;
    // chay truoc
    //-------------------------------------------------------------------------------------------------------------------------
    //[[UIScreen mainScreen] setBrightness:0.7];
    //    setDeviceVolume(1.0);
    //-------------------------------------------------------------------------------------------------------------------------
    
    NSString *model = [self getModel];

    
}
- (void) complete:(NSString*)str
{
    // ham nay chi dung cho nhung function co tinh canh tranh,WIFI,3G
}
- (void) test:(NSString*)str
{
    [[NSString stringWithFormat:@"%@", str] writeToFile:iDevice.requestFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
- (void) writeStatus:(NSString*)str
{
    [[NSString stringWithFormat:@"%@", str] writeToFile:iDevice.statusFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
- (void) writeLog:(NSString*)str
{
    [[NSString stringWithFormat:@"%@", str] writeToFile:iDevice.logFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
- (void) writeResult:(NSString*)str
{
    
    [[NSString stringWithFormat:@"%@", str] writeToFile:iDevice.resultFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void) alowAlert
{
    iDevice.isForceStopAlert = NO;
}

- (void)dealloc {
//    [_scrollView release];
//    [_pageControl release];
//    [_testLabel release];
//    [_loadingIndicator release];
//    [_buttonTestAlert release];
    if (IMMTimer != Nil)
    {
        [IMMTimer invalidate];
        IMMTimer = Nil;
    }
    if (bluetoothTimer != Nil)
    {
        [bluetoothTimer invalidate];
        bluetoothTimer = Nil;
    }
    if (buttonFuncTimer != Nil)
    {
        [buttonFuncTimer invalidate];
        buttonFuncTimer = Nil;
    }
//    if (telephone) {
//        [telephone release];
//        [call release];
//        [appearance release];
//        [touchID release];
//        [touchScreen release];
//        [bluetooth release];
//        [buttonFunc release];
//        [camera release];
//        [gps release];
//        [recordBack release];
//        [vibrate release];
//        [wifi release];
//    }
 //   [super dealloc];
}
@end
