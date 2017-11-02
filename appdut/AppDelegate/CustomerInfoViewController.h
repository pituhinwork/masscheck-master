//
//  CustomerInfoViewController.h
//  MassTrade
//
//  Created by Admin on 9/28/17.
//  Copyright © 2017 GDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPS.h"

@class GPS;
@interface CustomerInfoViewController : UIViewController
{
    NSMutableDictionary *dicInfor;
}

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *usernameField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *phoneField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *addressField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *licenseField;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) GPS *gps;
@end
