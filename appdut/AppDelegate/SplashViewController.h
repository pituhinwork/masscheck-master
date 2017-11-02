//
//  SplashViewController.h
//  MassTrade
//
//  Created by Admin on 9/28/17.
//  Copyright © 2017 GDT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController
{
    NSTimer *IMMTimer;
}

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *continueButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIPageControl *pageControl;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;

@end
