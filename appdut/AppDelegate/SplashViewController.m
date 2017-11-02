//
//  SplashViewController.m
//  MassTrade
//
//  Created by Admin on 9/28/17.
//  Copyright © 2017 GDT. All rights reserved.
//

#import "SplashViewController.h"
#import "DeviceInfoViewController.h"
#import "AppDelegate.h"
#import "iDevice.h"
#import "Utilities.h"
@interface SplashViewController () <UIScrollViewDelegate>

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView.delegate = self;
    // Do any additional setup after loading the view.
    AppShare = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppShare.highligh = -1;
    if(AppShare.tableData == Nil)
        AppShare.tableData = [[NSMutableArray alloc] init];
    else [AppShare.tableData removeAllObjects];
    [self RequestAmerican];
    IMMTimer = nil;
    IMMTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(readRequest) userInfo:nil repeats:NO];
}

//izap American
- (void) RequestAmerican
{
    
    //-------------------------------------------------------------------------------------
    // hien message cho click start hoac 2 phut sau tu chay
    
    NSString *str = @"$IMMTEST@#";
    NSString *partNum = getPhoneModal(2);
    NSString *model1 = [UIDevice currentDevice].model;
    
    
    str = [NSString stringWithFormat:@"%@Touchscreen;",str];
    str = [NSString stringWithFormat:@"%@Vibration;",str];
    str = [NSString stringWithFormat:@"%@BTFUNC;",str];
    if(([[model1 uppercaseString] rangeOfString:@"IPHONE"].location != NSNotFound && [partNum floatValue] > (float)6.0) ||
       ([[model1 uppercaseString] rangeOfString:@"IPAD"].location != NSNotFound && [partNum floatValue] > (float)5.2 ))
    {
        str = [NSString stringWithFormat:@"%@TouchID;",str];
    }
    str = [NSString stringWithFormat:@"%@CAMERA;",str];
    str = [NSString stringWithFormat:@"%@RecordBack;",str];
    str = [NSString stringWithFormat:@"%@WIFI;",str];
    str = [NSString stringWithFormat:@"%@Bluetooth;",str];
    str = [NSString stringWithFormat:@"%@GPS;",str];
    if([[model1 uppercaseString] rangeOfString:@"IPHONE"].location != NSNotFound)
    {
        str = [NSString stringWithFormat:@"%@Call;",str];
    }
    str = [NSString stringWithFormat:@"%@Appearance;",str];
    
    //-------------------------------------------------------------------------------------
    
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *requestFileName = [NSString stringWithFormat:@"%@/requestHitek.txt", [paths objectAtIndex:0]];
    [[NSString stringWithFormat:@"%@", str] writeToFile:requestFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}


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
                        
                        [self createTableIzap:cmdNote];
                    }
                }
            }
        }
    } //else ViewControllerLog(@"file == no");
}

// moi phep test chay theo thu tu cua app sap san , lay request tu file
- (void) createTableIzap:(NSString *)command
{
    
    //command = [command uppercaseString];
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    
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
            NSLog(@" %@",AppShare.tableData);
            [AppShare.arrayRetest addObject:[NSNumber numberWithBool:NO]];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [aScrollView setContentOffset: CGPointMake(aScrollView.contentOffset.x, 0)];
    _pageControl.currentPage = (_scrollView.contentOffset.x + CGRectGetWidth(_scrollView.frame) / 2) / CGRectGetWidth(_scrollView.frame);
}

- (IBAction)changePage:(id)sender {
    if (_pageControl.currentPage == 2) {
        IMMTimer = nil;
        DeviceInfoViewController* testController = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceInfoViewController"];
        [self presentViewController:testController animated:YES completion:nil];
        return;
    }
    _pageControl.currentPage = _pageControl.currentPage + 1;
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * _pageControl.currentPage, 0) animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
