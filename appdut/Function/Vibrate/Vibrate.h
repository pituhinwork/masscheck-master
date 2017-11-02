//
//  Vibrate.h
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MainTestViewController;
@interface Vibrate : NSObject<UIAlertViewDelegate>
{
    
    
    double x,y,z;
    double ox,oy,oz;
    
    NSTimer *loop1;
    NSTimer *loop2;
    
    int countX;
    int countY;
    int countZ;
    int ID;
    int status;
    
}

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) int ID;
- (void) successCheck:(NSString*)desc;
- (void) failedCheck:(NSString*)desc;
- (void) sendSuccess:(int)flag;
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param;
@property (nonatomic, strong) MainTestViewController *parentView;

// Addition functions
- (void) vibrate;
//- (void) updateMotionSensorData;
- (void) finishedUpdate;

@end
