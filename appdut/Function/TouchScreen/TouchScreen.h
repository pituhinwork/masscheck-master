//
//  TouchScreen.h
//  IVERIFY
//
//  Created by Lich Duyet on 8/27/14.
//  Copyright (c) 2014MaTran All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTestViewController;

@interface TouchScreen : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>
{
    int ID;
    int dong;
    int cot;
    int status;
    BOOL isPassed;
    BOOL orientionPass;
//    int numdoc;// hang doc va hang ngan : hien tai co 2 hang doc
//    NSTimer *time;
//    UIButton *CurrenButton;
    int dem;
    int curvt;
    int bien;
    
    float tile;
    
    UIImageView *imageView;
    CGContextRef context;
    UIImage *image;
    
    UIImageView *background;
    NSMutableArray *arrayRect;
    NSMutableArray *arrayFlag;
    
    
    UIScrollView *scrollView;
    UIPickerView *pickerInfor;
    NSMutableArray *dataDong;
    NSMutableArray *dataCot;
    UILabel *lbTimeShow;
    int timeout;
    
    UIImageView *imageViewAnimation;
    UIImageView *imageViewProcess;
    int countAnimation;
    
    int callCount;
}
@property (nonatomic, assign) int ID;
@property (nonatomic, assign) int dong;
@property (nonatomic, assign) int cot;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) MainTestViewController *parentView;
@property (nonatomic, strong) NSMutableArray *tableButton;
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param;


@end



