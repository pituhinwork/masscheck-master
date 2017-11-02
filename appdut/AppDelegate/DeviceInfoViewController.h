//
//  DeviceInfoViewController.h
//  MassTrade
//
//  Created by Admin on 9/28/17.
//  Copyright © 2017 GDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckPart.h"

@interface DeviceInfoViewController : UIViewController
{
    NSMutableDictionary *dicInfor;
}
@property (strong, nonatomic) IBOutlet UILabel *phoneColor;
@property (strong, nonatomic) IBOutlet UILabel *phoneModel;
@property (strong, nonatomic) IBOutlet UILabel *serialNumber;
@property (strong, nonatomic) IBOutlet UILabel *phoneImei;
@property (strong, nonatomic) IBOutlet UILabel *mobileType;
@property (strong, nonatomic) IBOutlet UILabel *mobileModel;

@property (nonatomic, strong) NSString *modelDev;
@end
