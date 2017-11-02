//
//  Appearance.h
//  MassTrade
//
//  Created by BachUng on 7/31/17.
//  Copyright © 2017MaTran All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTestViewController;
@interface Appearance : UIViewController
{
    int ID;
    int status;
    
    int option1,option2,option3;
    
}
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) int ID;
@property (nonatomic, strong) MainTestViewController *parentView;
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param;
- (void) successCheck:(NSString*)desc;
- (void) failedCheck:(NSString*)desc;
@end
