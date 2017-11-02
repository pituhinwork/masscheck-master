//
//  GPS.m
//  testprod
//
//  Created by Toan Nguyen Van on 04/04/13.
//  Copyright (c) 2013 ccinteg. All rights reserved.
//

#import "AppDelegate.h"

#import "iDevice.h"
#import "GPS.h"

#import "Utilities.h"
#import "MainTestViewController.h"

#define GPS_NONE 0
#define GPS_START 1
#define GPS_GOTDATA 2
#define GPS_FINISHED 3


#define METERS_MILE 1609.344
#define METERS_FEET 3.28084


#import <stdio.h>
#import <unistd.h>
#import <dlfcn.h>

#include <sys/param.h>
#include <sys/sysctl.h>
#include <stdlib.h>

#define GPSDERBUG
#if defined(GPSDERBUG) || defined(DEBUG_ALL)
#   define GPSLog(BachUng, ...) NSLog((@"%s[Line %d] " BachUng), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define GPSLog(...)
#endif

@implementation GPS
@synthesize key;
@synthesize ID;
@synthesize isShowMap;
@synthesize lat;
@synthesize log;
@synthesize alt;

- (id) init
{
    self = [super init];
    key = @"GPS";
    status = GPS_NONE;
    ID = -1;
    isAskFromLinux = NO;
    isShowMap = NO;
    didShowMap = NO;// da sho map hay chua
    lcMgr = Nil;
    isPassed = NO;
    
    lat = -1;
    log = -1;
    alt = -1;
    
    ViewMap = Nil;;
    mapView = Nil;
    msgBox = Nil;
    
    callCount = 0;
    
    CGRect rect = AppShare.parentView.view.frame;
    if(ViewMap==Nil)
    {
        ViewMap = [[UIView alloc] initWithFrame:rect];
        ViewMap.backgroundColor = [UIColor blueColor];
        ViewMap.userInteractionEnabled = YES;
    }
    
    
    if(mapView==Nil)
    mapView = [[MKMapView alloc] initWithFrame:rect];
    mapView.showsUserLocation = YES;
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [ViewMap addSubview:mapView];
    //mapView.delegate = self;
    
//    float ios = [AppShare.viewController getIOS];
//
//    UIButton *btPassed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btPassed.frame = CGRectMake(rect.size.width/2 - 150 , rect.size.height - 50, 100, 50);
//    [btPassed setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    if(ios >= 7)
//    {
//        btPassed.layer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5].CGColor;
//        btPassed.layer.borderColor = [[UIColor blueColor] CGColor];
//        btPassed.layer.borderWidth = 1;
//        btPassed.layer.cornerRadius = 10;
//    }
//    [btPassed.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [btPassed setTitle:@"Passed" forState:UIControlStateNormal];
//    [btPassed addTarget:self action:@selector(onPassed:) forControlEvents:UIControlEventTouchUpInside];
//    [ViewMap addSubview:btPassed];
//    
//    UIButton *btFailed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btFailed.frame = CGRectMake(rect.size.width/2 + 50, rect.size.height - 50, 100, 50);
//    [btFailed setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    if(ios >= 7)
//    {
//        btFailed.layer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5].CGColor;
//        btFailed.layer.borderColor = [[UIColor redColor] CGColor];
//        btFailed.layer.borderWidth = 1;
//        btFailed.layer.cornerRadius = 10;
//    }
//    [btFailed.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [btFailed setTitle:@"Failed" forState:UIControlStateNormal];
//    [btFailed addTarget:self action:@selector(onFailed:) forControlEvents:UIControlEventTouchUpInside];
//    [ViewMap addSubview:btFailed];
    
    isNotTest = NO;
    return self;
}
- (void)releaseResouceMap
{
//    if(mapView && mapView.superview)
//        [mapView removeFromSuperview];
    if(ViewMap && ViewMap.superview)
        [ViewMap removeFromSuperview];
    if(lcMgr)
    {
        [lcMgr stopUpdatingLocation];
//        [lcMgr release];
//        lcMgr = nil;
    }

}

- (void)resetTap
{
    tapClick = 0;
}

- (void)onPassed:(id)sender
{
    gpsSemiFinished = YES;
    [self releaseResouceMap];
    [self successCheck:@""];
}
- (void)onFailed:(id)sender
{

    if(tapClick==0)
    {
        tapClick++;
        [self performSelector:@selector(resetTap) withObject:Nil afterDelay:0.3];
        return;
    }

    gpsSemiFinished = YES;
    [self releaseResouceMap];
    [self failedCheck:@"User check"];
}
- (void) dealloc
{
    if(lcMgr)
    {
        [lcMgr stopUpdatingLocation];
        lcMgr = nil;
    }
    if(mapView != Nil && mapView.superview)
    {
        [mapView removeFromSuperview];
        mapView = Nil;
    }
    if(ViewMap != Nil && ViewMap.superview)
    {
        
        [ViewMap removeFromSuperview];
        ViewMap = Nil;
    }
}

- (void) failedCheck:(NSString*)desc
{
    GPSLog();
    if(status != GPS_FINISHED)
    {
        GPSLog("status != GPS_FINISHED");
        gpsSemiFinished = YES;//failed cho write chi khi pass moi cho user check ban do
        if(isShowMap == NO)
            [self releaseResource];
        status = GPS_FINISHED;
        msg = [[NSString alloc] initWithFormat:@"%@", desc];
        isPassed = NO;
    }
    
    [self writeResultValue];
}

- (void) successCheck:(NSString*)desc
{
    GPSLog();
    if(status != GPS_FINISHED)
    {
        GPSLog("status != GPS_FINISHED");
        if(isShowMap == NO)
            [self releaseResource];
        status = GPS_FINISHED;
        msg = [[NSString alloc] initWithFormat:@"PASSED"];
        isPassed = YES;
        
    }
    
    [self writeResultValue];
}

/*
 latitude: 10.888129, longitude: 106.721525
 latitude: 10.888129, longitude: 106.721525
 latitude: 10.888129, longitude: 106.721525
 latitude: 10.888195, longitude: 106.721542
 latitude: 10.888192, longitude: 106.721538
 
 */

- (void) writeResultValue
{
    if(isAskFromLinux && status == GPS_FINISHED)
    {
        GPSLog(@"[GPS] Write Result Value %d, %@ SemiFinished:%@", isPassed, msg, gpsSemiFinished?@"YES":@"NO");
        if (gpsSemiFinished==YES)
        {
            
            [self.parentView updateResult:ID value:[NSString stringWithFormat:@" %@#%@#%@",key,isPassed?@"PASSED":@"FAILED",msg]];
            
        }
        else GPSLog(@"gpsSemiFinished %@, status:%d", gpsSemiFinished?@"YES":@"NO", status);
        [self releaseResource];
       
    }
    else
    {
         GPSLog(@"isAskFromLinux %@, status:%d", isAskFromLinux?@"YES":@"NO", status);
    }
}

- (void) releaseResource
{
    if(msgBox)
    {
        [msgBox dismiss];
        msgBox = Nil;
    }
    if (gpsSemiFinished)
    {
        if(lcMgr)
        {
            [lcMgr stopUpdatingLocation];
//            [lcMgr release];
//            lcMgr = nil;
        }
    }
    
}
/*set when end test GSP not passed*/
- (BOOL) isEnableLocation
{
    if([CLLocationManager locationServicesEnabled])
    {
        return YES;
    }
    return NO;
}
- (void) preTest
{
    GPSLog(@" preTest gps : seme=%d",isShowMap);
    
   // status = GPS_NONE;
    [self releaseResource];
    
    log = 0;
    lat = 0;
    alt = 0;
    olat = 0;
    olog = 0;
    oalt = 0;
    
    
    if([CLLocationManager locationServicesEnabled])
    {
        GPSLog(@"locationServicesEnabled");
        [self startTest];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Nil message:AppShare.TurnOnLocationServicesText delegate:self cancelButtonTitle:AppShare.SettingText otherButtonTitles:AppShare.CancelText, nil];
        [alert show];
        
    }
}

- (void)startTest
{
    status = GPS_START;
    lcMgr = [[CLLocationManager alloc] init];
    lcMgr.delegate = self;
    lcMgr.desiredAccuracy = kCLLocationAccuracyBest;
    lcMgr.distanceFilter = kCLDistanceFilterNone;//5;
    if ([lcMgr respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [lcMgr requestAlwaysAuthorization];
    }
    
    //        if ([lcMgr respondsToSelector:@selector(requestWhenInUseAuthorization)])
    //        {
    //            [lcMgr requestWhenInUseAuthorization];
    //        }
    
    
    [lcMgr startUpdatingLocation];
    locationManagerStartDate = [NSDate date];

}

- (void) onTimeOut:(NSNumber*)num
{
    if([num intValue] == callCount)
    {
        if(status != GPS_FINISHED)
        {
            [self failedCheck:@"Timeout"];
        }
    }
}


- (BOOL) isValidLocation:(CLLocation *)newLocation withOldLocation:(CLLocation *)oldLocation
{
    // Filter out nil locations
    if (!newLocation)
    {
        return NO;
    }
    
    // Filter out points by invalid accuracy
    if (newLocation.horizontalAccuracy < 0)
    {
        return NO;
    }
    
    // Filter out points that are out of order
    NSTimeInterval secondsSinceLastPoint = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
    
    if (secondsSinceLastPoint < 0)
    {
        return NO;
    }
    
    // Filter out points created before the manager was initialized
    NSTimeInterval secondsSinceManagerStarted = [newLocation.timestamp timeIntervalSinceDate:locationManagerStartDate];
    
    if (secondsSinceManagerStarted < 0)
    {
        return NO;
    }
    
    // The newLocation is good to use
    return YES;
}
- (void) recieveLocation
{
    GPSLog(@" --------------- status:%d == %d:GPS_START",status,GPS_START);
    if(status == GPS_START)
    {
        double x = lcMgr.location.coordinate.latitude;
        double y = lcMgr.location.coordinate.longitude;
        double a = lcMgr.location.altitude;
        GPSLog(@"x:%lf, y:%lf, a:%lf",x,y,a);
        if((fabs(x) > 0.01) && (fabs(y) > 0.01))
        {
            lat = x;
            log = y;
            alt = a;
            
           //
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(lcMgr.location.coordinate, 2*METERS_MILE, 2*METERS_MILE);
            [mapView setRegion:viewRegion animated:YES];
            GPSLog(@" --------------- isAskFromLinux: %@,isShowMap: %@",isAskFromLinux?@"YES":@"NO",isShowMap?@"YES":@"NO");
            if(isAskFromLinux)
            {
                if(isShowMap == YES)
                {
                    GPSLog(@" --------------- showMap");
                    [self showMap];
                }
                else [self successCheck:@""];
            }
        }
        else
            [lcMgr performSelector:@selector(startUpdatingLocation) withObject:Nil afterDelay:2];
        
    }
}

- (void)showMap
{
    status = GPS_GOTDATA;
    GPSLog(@" Show map: latitude:%lf, longtitude:%lf, altitude:%lf",lat,log,alt);
    if(msgBox)
    {
        [msgBox dismiss];
        msgBox = Nil;
    }
    didShowMap = YES;
      [self performSelector:@selector(onPassed:) withObject:Nil afterDelay:7];
    //[mapView setShowsUserLocation:YES];
 
    if(lcMgr)
    {
        [lcMgr stopUpdatingLocation];
    }
    
  
}
- (void)acceptGPS
{
    if(lcMgr==Nil)
        lcMgr = [[CLLocationManager alloc] init];
    if(lcMgr)
    {
        if ([lcMgr respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [lcMgr requestAlwaysAuthorization];
        }
        
        if ([lcMgr respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
        {
            [lcMgr setAllowsBackgroundLocationUpdates:YES];
        }
        
    }
}

// This function is started when Master Linux request
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param
{
    GPSLog(@" --------------- start to test: status=%d,isPassed:%@,isShowMap:%@",status,isPassed?@"YES":@"NO",isShowMap?@"YES":@"NO");
    tapClick = 0;
    didShowMap = NO;
    isAskFromLinux = YES;
    gpsSemiFinished = NO;
    isShowMap = YES;
    if (isShowMap == NO)
    {
        gpsSemiFinished = YES;
    }
    //else key = @"GPSSEMI";
    
    
    if(status == GPS_FINISHED)
    {
        if(isPassed == YES)
        {
            if(isShowMap == NO)
                [self writeResultValue];
            else
            {
               
                MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(lcMgr.location.coordinate, 2*METERS_MILE, 2*METERS_MILE);
                [mapView setRegion:viewRegion animated:YES];
                if(isAskFromLinux)
                {
                     [self showMap];
                }
            }
        }
        else
        {
            
           
            GPSLog(@"GPS retest failed -test try agan");
            if(isShowMap == NO)
            {
                callCount++;
                 [self performSelector:@selector(onTimeOut:) withObject:[NSNumber numberWithInt:callCount] afterDelay:35];
            }
            else
            {
                if(msgBox)
                {
                    [msgBox dismiss];
                    msgBox = Nil;
                }
                msgBox = [[MessageBox alloc] init];
                [msgBox showNoneButton:@"Waiting for process...." title:@"GPS"];
            }
            [self preTest]; //cho retest lai lan cuoi  nen GPS phai o gan cuoi
        }
    }
    else
    {
        GPSLog(@" --------------- status chua FINISHED: %d",status);
        if(isShowMap == NO)
        {
            callCount++;
            // [self preTest];
            [self performSelector:@selector(onTimeOut:) withObject:[NSNumber numberWithInt:callCount] afterDelay:35];
        }
        else
        {
            if(msgBox)
            {
                [msgBox dismiss];
                msgBox = Nil;
            }
            msgBox = [[MessageBox alloc] init];
            [msgBox showNoneButton:@"Waiting for process...." title:@"GPS"];
           // [self preTest];// retest lan nua

        }

        [self preTest];
        
    }
    
 
}
#pragma mark- UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0 && alertView.tag != 1)
    {
        
      
            
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)])
            {
                NSLog(@"coham");
               
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};//@{}
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"Prefs://root=LOCATION_SERVICES"] options:options completionHandler:Nil];
            }
            else
            {
                NSLog(@"koham");
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"Prefs:root=LOCATION_SERVICES"]];
            }

        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppShare.GPSTestText message:AppShare.NowTryAgainText delegate:self cancelButtonTitle:AppShare.STARTText otherButtonTitles:Nil, nil];
            alert.tag = 1;
            [alert show];
        
    }
    else
    {
        if([CLLocationManager locationServicesEnabled])
        {
            GPSLog(@"locationServicesEnabled");
            [self startTest];
        }
        else
        {
            gpsSemiFinished = YES;
            GPSLog(@"not Enabled status:%d, gpsSemiFinished:%@",status,gpsSemiFinished?@"YES":@"NO");
            isNotTest = YES;
            [self failedCheck:@"Location Service is not enabled"];
        }

    }
}

#pragma mark- Mapview Delegate

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    GPSLog();
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    GPSLog();
}
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error;
{
    GPSLog();
}
#pragma mark- CLLocation Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    GPSLog();
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    GPSLog();
    if(isAskFromLinux == YES)
    {
        if(didShowMap==NO)
            [self failedCheck:[NSString stringWithFormat:@"Location manager error: The operation could not be completed"]];
    }
    else
    {
        if([lcMgr respondsToSelector:@selector(requestAlwaysAuthorization)])
            [lcMgr requestAlwaysAuthorization];
        [lcMgr performSelector:@selector(startUpdatingLocation) withObject:Nil afterDelay:2];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
  
    if(status == GPS_START)
    {
        if([self isValidLocation:newLocation withOldLocation:oldLocation])
        {
            [self recieveLocation];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
     GPSLog();
    if(status != GPS_FINISHED)
        [self recieveLocation];
   
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return NO;
}


@end


