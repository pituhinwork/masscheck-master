//
//  GPS.h
//  testprod
//
//  Created by Toan Nguyen Van on 04/04/13.
//  Copyright (c) 2013 ccinteg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MessageBox.h"

@class MainTestViewController;
@interface GPS : NSObject <CLLocationManagerDelegate,MKMapViewDelegate,UIAlertViewDelegate>
{
    int ID;
    int status;
    
    BOOL isPassed;
    NSString *msg;
    
    BOOL isAskFromLinux;
    BOOL acceprtFailed;
    
    CLLocationManager *lcMgr;
    double lat, log, alt;
    
    double olat, olog, oalt;
    
    UILabel *lblLocation;
    NSDate *locationManagerStartDate;
    
    //semi gps
    BOOL isShowMap;
    UIView *ViewMap;
    MKMapView *mapView;
     MessageBox *msgBox;
    int callCount;
    
    BOOL gpsSemiFinished;
    int tapClick;
    BOOL didShowMap;
    
    BOOL isNotTest;
}
@property (nonatomic, assign) double alt;
@property (nonatomic, assign) double log;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) int ID;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) BOOL isShowMap;
@property (nonatomic, strong) MainTestViewController *parentView;

- (void) successCheck:(NSString*)desc;
- (void) failedCheck:(NSString*)desc;
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param;

// Addition functions
- (void) preTest;
- (BOOL) isEnableLocation;
- (void) acceptGPS;
@end
