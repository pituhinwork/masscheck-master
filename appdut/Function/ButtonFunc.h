//
//  ButtonFunc.h
//  IVERIFY
//
//  Created by BachUng on 8/11/16.
//  Copyright © 2016MaTran All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class MainTestViewController;
@interface ButtonFunc : UIViewController
{
    int status;
    int ID;
    
    int varHome;
    int varPower;
    int varMute;
    int varVolup;
    int varVolDown;
    NSMutableArray *array;
    BOOL isPassed;
    int callCount;
    
    float preVol;
    
    int countFail;
    int countPass;
    int countPress;
    
    int tabCount;
    UIImageView *imageViewActivity;
    NSTimer *timer;
    int timeleft;
    UIScrollView *scrollviewConten;
    BOOL is5C;
}
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) int ID;

@property (nonatomic, assign) int varHome;
@property (nonatomic, assign) int varPower;
@property (nonatomic, assign) int varMute;
@property (nonatomic, assign) int varVolup;
@property (nonatomic, assign) int varVolDown;
@property (nonatomic, strong) MainTestViewController *parentView;


- (void) startAutoTest:(NSString*)rKey param:(NSString*)param;
- (void) receiveBackgroundByHome;
- (void) receiveBackgroundByPower;
- (void) beginTest;
- (void) ringerButtonChange:(BOOL)ringer;
- (void) volumeChanged:(float)num;
- (void) successCheck:(NSString*)desc;
- (void) failedCheck:(NSString*)desc;
- (void) resetRingTest;

@end
