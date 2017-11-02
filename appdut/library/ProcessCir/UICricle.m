//
//  UICricle.m
//  IVERIFY
//
//  Created by BachUng on 6/23/17.
//  Copyright © 2017MaTran All rights reserved.
//

#import "UICricle.h"

@implementation UICricle
@synthesize percent;
@synthesize radius;
@synthesize lineWidth;
@synthesize fontsize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
            // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
            // Determine our start and stop angles for the arc (in radians)
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
        radius = frame.size.width*1.0/2;
        lineWidth = radius/10;
        radius -= lineWidth;
        percent = 15;
        float tl = frame.size.width/100.0;
        fontsize = (float)42.5*tl;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
        // Display our percentage as a string
    NSString* textContent = [NSString stringWithFormat:@"%d", self.percent];
    
    UIBezierPath* bezierPathBG = [UIBezierPath bezierPath];// Create our arc, with the correct angles
    [bezierPathBG addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:radius
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (100 / 100.0) + startAngle
                       clockwise:YES];
    
        // Set the display for the path, and stroke it
    bezierPathBG.lineWidth = lineWidth;
    [[UIColor colorWithRed:180*1.0/255 green:190*1.0/255 blue:200*1.0/255 alpha:1.0] setStroke];
    [bezierPathBG stroke];

    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
        // Create our arc, with the correct angles
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:radius
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (percent / 100.0) + startAngle
                       clockwise:YES];
    
        // Set the display for the path, and stroke it
    bezierPath.lineWidth = lineWidth;
    [[UIColor blueColor] setStroke];
    [bezierPath stroke];
    
        // Text Drawing
    float tl = rect.size.width/100.0;
    CGRect textRect = CGRectMake((rect.size.width / 2.0) - 80*tl/2.0, (rect.size.height / 2.0) - 45*tl/2.0, 80*tl, 45*tl);
        //CGRect textRect = rect;
    [[UIColor blackColor] setFill];
    
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    
    if(ver_float >=(float) 7.0)
    {
        UIFont *font = [UIFont fontWithName:@"Courier" size:fontsize];
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{ NSFontAttributeName: font,
                                      NSParagraphStyleAttributeName: paragraphStyle };
        [textContent drawInRect:textRect withAttributes:attributes];
    }
    else
    {
        [textContent drawInRect: textRect withFont: [UIFont systemFontOfSize:fontsize] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
    }
    
}
@end
