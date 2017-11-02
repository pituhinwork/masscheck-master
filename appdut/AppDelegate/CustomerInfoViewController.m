//
//  CustomerInfoViewController.m
//  MassTrade
//
//  Created by Admin on 9/28/17.
//  Copyright © 2017 GDT. All rights reserved.
//

#import "CustomerInfoViewController.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "iDevice.h"
#import "Reachability.h"
#import "MainTestViewController.h"
#import "ValueScrollViewController.h"

@interface CustomerInfoViewController ()

@end

@implementation CustomerInfoViewController

@synthesize scrollView;
@synthesize gps;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppShare = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *temp1 = [NSString stringWithFormat:@"%@ GB",[AppShare.checkPart getCapacity]];
    NSString *temp2 = [[NSString alloc] initWithFormat:@"%@",[AppShare.checkPart getModelFull]];
    dicInfor = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                [[UIDevice currentDevice] name],@"name",
                getPhoneModal(4),@"productname",
                temp1 ,@"capacity",
                [AppShare.checkPart getColorCode],@"color",
                [AppShare.checkPart getCarier],@"carrier",
                temp2 ,@"model",
                [AppShare.checkPart deviceSerial],@"serial",
                [AppShare.checkPart deviceIMEI],@"imei",
                nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

}

- (void)keyboardWillShow: (NSNotification *) notif{
    //Keyboard becomes visible
    NSDictionary *userInfo = notif.userInfo;
    NSValue *keyboardInfo = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = keyboardInfo.CGRectValue.size;
    
    scrollView.frame = CGRectMake(scrollView.frame.origin.x,
                                  - keyboardSize.height,
                                  scrollView.frame.size.width,
                                  scrollView.frame.size.height);   //move up
}

- (void)keyboardDidHide: (NSNotification *) notif{
    //keyboard will hide
    NSDictionary *userInfo = notif.userInfo;
    NSValue *keyboardInfo = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = keyboardInfo.CGRectValue.size;
    
    scrollView.frame = CGRectMake(scrollView.frame.origin.x,
                                  0,
                                  scrollView.frame.size.width,
                                  scrollView.frame.size.height);   //move down
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (AppShare.dismissable == YES) {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

-(void)dismissKeyboard {
    [[self view] endEditing:TRUE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitButtonTapped:(id)sender {
    NSMutableArray *arrayFunc = [NSMutableArray array];
    for(int i = 0;i<AppShare.tableData.count;i++)
    {
        
        NSString *data = AppShare.tableData[i];
        NSArray *array = [data componentsSeparatedByString:@"#"];
        
        if(array.count>1)
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 array[0],@"funcname",
                                 array[1],@"result",
                                 array[2],@"note",
                                 nil];
            [arrayFunc addObject:dic];
        }
        else
        {
            if ([[data uppercaseString] containsString:@"APPEARANCE"]) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     data,@"funcname",
                                     @"FAILED",@"result",
                                     @"0,0,0",@"note",
                                     nil];
                [arrayFunc addObject:dic];
            }
            else {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     data,@"funcname",
                                     @"FAILED",@"result",
                                     @"",@"note",
                                     nil];
                [arrayFunc addObject:dic];
            }
        }
    }
    
    NSMutableDictionary *dicuserinfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        _usernameField.text,@"name",
                                        _phoneField.text,@"phone",
                                        _addressField.text,@"address",
                                        _licenseField.text,@"driver_license_number",
                                        nil];
    NSMutableDictionary *dicLcation = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       gps.log==-1?@"NA":[NSNumber numberWithDouble:gps.log],@"longitude",
                                       gps.lat==-1?@"NA":[NSNumber numberWithDouble:gps.lat],@"latitude",
                                       gps.alt==-1?@"NA":[NSNumber numberWithDouble:gps.alt],@"altitude",
                                       nil];
    
    NSMutableDictionary *dicResult = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      dicuserinfo,@"userinfo",
                                      dicInfor,@"deviceinfo",
                                      arrayFunc,@"data",
                                      dicLcation,@"location",
                                      [AppShare.checkPart getDID],@"uniqueid",
                                      nil];
    
    NSString *str = [AppShare jsonStringFromDictionary:dicResult];

    if([self checkConnectNetwork]==YES)
    {
        NSString *result = [self PostToServer:str link:@"http://masstrade.io/service/setdata"];
        
        NSDictionary *dicResult = [AppShare diccionaryFromJsonString:result];
        if(dicResult==Nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server" message:@"Result not valid, please try again" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:Nil, nil];
            [alert show];
            return;
            
        }
        
        
        if([dicResult objectForKey:@"result"] == Nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server" message:@"Result not valid, please try again" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:Nil, nil];
            [alert show];
            return;
        }
        
        
        
        str = [dicResult objectForKey:@"result"];
        if([[str lowercaseString] rangeOfString:@"failed"].location != NSNotFound)
        {
            if([dicResult objectForKey:@"error"]==Nil)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server" message:@"Result upload failed" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:Nil, nil];
                [alert show];
                
                return;
            }
            NSString *error = [NSString stringWithFormat:@"Error:%@",[dicResult objectForKey:@"error"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server" message:error delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:Nil, nil];
            [alert show];
            
            return;
            
        }
        
        ValueScrollViewController* testController = [self.storyboard instantiateViewControllerWithIdentifier:@"ValueScrollViewController"];
        testController.dic = dicResult;
        [self presentViewController:testController animated:YES completion:nil];
        

        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server" message:@"Device not connect internet." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:Nil, nil];
        [alert show];
        
        return;
    }
    
}

#pragma mark -
#pragma mark Upload file methods
- (BOOL) checkConnectNetwork
{
    Reachability *curReach = [Reachability reachabilityWithHostName: @"www.apple.com"];
    //     Reachability *curReach = [Reachability reachabilityWithHostName: @"https://www.google.com/"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            return NO;
        }
        case ReachableViaWiFi:
        {
            NSString *ssid = [AppShare.parentView.wireless accessPointName];
            
            
            if ((NSNull *) ssid == [NSNull null])
            {
                
            }
            else if ([ssid isEqual:[NSNull null]])
            {
                
            }
            else return YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            // 3G
            
            NSURL *url=[NSURL URLWithString:@"http://www.apple.com"];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"HEAD"];
            request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
            request.timeoutInterval = 5.0;
            NSHTTPURLResponse *response;
            NSError *err=Nil;
            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: &err];
            BOOL temp = ([response statusCode]==200)?YES:NO;
            
            return temp;
            
            //            return YES;
            break;
        }
    }
    
    return NO;
}

- (NSString*)PostToServer:(NSString*)postString link:(NSString*)link
{
    
    NSURL *aUrl = [NSURL URLWithString:link];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];//30
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error=Nil;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    if(!error)
    {
        return data;
    }
    else
    {
        return [NSString stringWithFormat:@"{\"error\": %@,\"result\":\"failed\"}",[error debugDescription]];
    }
    return @"";
    
}


- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
