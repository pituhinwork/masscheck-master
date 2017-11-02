//
//  UICricle.h
//  IVERIFY
//
//  Created by BachUng on 6/23/17.
//  Copyright © 2017MaTran All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICricle : UIView
{
    CGFloat startAngle;
    CGFloat endAngle;
}
@property(nonatomic, assign)  int percent;
@property(nonatomic, assign)  int radius;
@property(nonatomic, assign)  int lineWidth;
@property(nonatomic, assign)  float fontsize;
@end
