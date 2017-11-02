//
//  MessageBox.m
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import "iDevice.h"
#import "AppDelegate.h"
#import "MessageBox.h"
#import "MainTestViewController.h"

#import "Utilities.h"

@implementation MessageBox
@synthesize lbl;
- (id) init
{
    self = [super init];
    timer = Nil;
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    width = screen.size.width; height = screen.size.height;
    if(width > height)
    {
        width = screen.size.height;
        height = screen.size.width;
    }
    vitriCount = -1;
   // NSLog(@"%s width:%d, height:%d",__FUNCTION__,width,height);
    view = [[UIView alloc] init];
    view.frame = CGRectMake( (width-300)/2, (height-350)/2, 300, 350); //300, 350);
    view.backgroundColor = [UIColor redColor];
    
    view.layer.borderWidth = 3;
    view.layer.cornerRadius = 10;
    
    setDataToDeleGate = NO;
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 294, 344)];
    image.hidden = YES;
    [view addSubview:image];
 

    
    
    caption = [[UILabel alloc] init];
    caption.frame = CGRectMake(0, 0, view.frame.size.width, TITLE_HIGHT);//35
    caption.backgroundColor = [UIColor colorWithRed:0xEF*1.0/0xFF green:0xEF*1.0/0xFF blue:0xF4*1.0/0xFF alpha:1];
    caption.textColor = [UIColor whiteColor];
    //caption.shadowColor = [UIColor grayColor];
    //caption.shadowOffset = CGSizeMake(1, 1);
    //caption.font = [UIFont boldSystemFontOfSize:30];
    caption.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    caption.textAlignment = NSTextAlignmentCenter;
    caption.numberOfLines = 0;
    
    [view addSubview:caption];
    
    
    float tile = width*1.0/320;
    
    content = [[UILabel alloc] init];
    content.frame = CGRectMake(10, 40, view.frame.size.width-20, view.frame.size.height-90);
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor whiteColor];
//    content.shadowColor = [UIColor grayColor];
//    content.shadowOffset = CGSizeMake(1, 1);
    content.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    content.textAlignment = NSTextAlignmentCenter;
    content.numberOfLines = 0;
    [view addSubview:content];
    
    
    view.layer.borderColor = [[UIColor blueColor] CGColor];

    imageViewAnimal = [[UIImageView alloc] initWithFrame:CGRectMake(width/2 -80*tile, height/2+30*tile, 160*tile, 160*tile)];
    imageViewAnimal.hidden = YES;
    [view addSubview:imageViewAnimal];
    
    imageViewActivity = [[UIImageView alloc] initWithFrame:CGRectMake(width/2 -40, height/4-40, 80*tile, 80*tile)];
    imageViewActivity.hidden = YES;
    [view addSubview:imageViewActivity];
    
    imageSmall = [[UIImageView alloc] initWithFrame:CGRectMake(width/2 - 25*tile, 74*tile +100, 50*tile, 50*tile)];
    imageSmall.hidden = YES;
    [view addSubview:imageSmall];
   
    
    ios = [AppShare.parentView getIOS];
    
    btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCancel.frame = CGRectMake(15, view.frame.size.height-65, view.frame.size.width-30, 50);
    [btnCancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    if(ios >= 7)
    {
        btnCancel.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        btnCancel.layer.borderColor = [[UIColor blueColor] CGColor];
        btnCancel.layer.borderWidth = 1;
        btnCancel.layer.cornerRadius = 10;
        [btnCancel.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
       
    }
    [btnCancel addTarget:self action:@selector(onclickCancel) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setHidden:YES];
    [view addSubview:btnCancel];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(15, view.frame.size.height-65, view.frame.size.width-30, 50);
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    if(ios >= 7)
    {
        btn.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        btn.layer.borderColor = [[UIColor blueColor] CGColor];
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 10;
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
       
    }
    [btn addTarget:self action:@selector(onclick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    
    segmenButton = Nil;

    labelTextboxTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, view.frame.size.width - 20, 30)];
    labelTextboxTitle.text = @"";
    labelTextboxTitle.hidden = YES;
    [view addSubview:labelTextboxTitle];
    
    txtTextbox = [[UITextField alloc] initWithFrame:CGRectMake(10, 90, view.frame.size.width - 20, 50)];
    txtTextbox.text = @"";
    txtTextbox.hidden = YES;
    txtTextbox.layer.borderColor = [UIColor blackColor].CGColor;
    txtTextbox.layer.borderWidth = 1;
    [txtTextbox addTarget:self action:@selector(textViewDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [view addSubview:txtTextbox];
    
    return self;
}
- (void) setBorderWidth:(float)width corner:(float)cornerRadius
{
    view.layer.borderWidth = width;
    view.layer.cornerRadius = cornerRadius;
}
- (void) setFrame:(CGRect) rect
{
    view.frame = rect;
    content.frame = CGRectMake(10, 60, view.frame.size.width-20, view.frame.size.height-90);
}
- (void) setBGImage:(UIImage *) img
{
    caption.textColor = [UIColor blackColor];
    content.textColor = [UIColor blackColor];
    image.image = img;
    image.hidden = NO;
}
//- (void) setBGImage:(UIImage *) img
//{
//    caption.textColor = [UIColor blackColor];
//    content.textColor = [UIColor blackColor];
//    image.image = img;
//    image.hidden = NO;
//}


- (void) dismiss
{
    [self releaseResource];
}
- (void) setBackground:(UIColor *) color
{
    if([content.text isEqualToString:@""] == NO)
        image.hidden = YES;
    view.backgroundColor = color;
}
- (void) onClickNoSound
{
    [self releaseResource];
    
    if(root && [root respondsToSelector:selector])
    {
        [root performSelector:selector withObject:[NSNumber numberWithInt:tagNum]];
    }
}

- (void) onclickWithTag:(NSNumber*)tag
{
    [self releaseResource];
    if(root && [root respondsToSelector:selector])
    {
        [root performSelector:selector withObject:tag];
    }
}

- (void) onclick
{
    NSLog(@"%s",__FUNCTION__);
#if defined(ERC) || defined(ENCO)
    if([[btn.titleLabel.text uppercaseString] rangeOfString:@"FAILED"].location != NSNotFound)
    {
        if(tapClick==0)
        {
            tapClick++;
            [self performSelector:@selector(resetTap) withObject:Nil afterDelay:0.3];
            return;
        }
    }
#endif
    if(setDataToDeleGate)
    {
        setDataToDeleGate = NO;
        labelTextboxTitle.hidden = YES;
        txtTextbox.hidden = YES;
        NSString *str = txtTextbox.text;
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];

        AppShare.MessageSaveData = [[NSString alloc] initWithFormat:@"%@",str];
        NSLog(@"%s AppShare.MessageSaveData  = txtTextbox.text %@",__FUNCTION__,AppShare.MessageSaveData);

    }

    [self releaseResource];
    
    if(root && [root respondsToSelector:selector])
    {
        [root performSelector:selector withObject:[NSNumber numberWithInt:tagNum]];
    }
}

- (void) onclickCancel
{
    
#if defined(ERC) || defined(ENCO)
    if([[btnCancel.titleLabel.text uppercaseString] rangeOfString:@"FAILED"].location != NSNotFound)
    {
        if(tapClick==0)
        {
            tapClick++;
            [self performSelector:@selector(resetTap) withObject:Nil afterDelay:0.3];
            return;
        }
    }
#endif
    if(setDataToDeleGate)
    {
        setDataToDeleGate = NO;
        labelTextboxTitle.hidden = YES;
        txtTextbox.hidden = YES;
        AppShare.MessageSaveData  = txtTextbox.text;
    }

    [self releaseResource];
    
    if(root && [root respondsToSelector:selector])
    {
        [root performSelector:selector withObject:[NSNumber numberWithInt:100+tagNum]];
    }
   
}

- (void) btClick:(id)sender
{
#if defined(ERC) || defined(ENCO)
    if(tapClick==0)
    {
        tapClick++;
        [self performSelector:@selector(resetTap) withObject:Nil afterDelay:0.3];
        return;
    }
#endif
    UIButton *bt = (UIButton *)sender;
    [self releaseResource];
    if(root && [root respondsToSelector:selector])
    {
        [root performSelector:selector withObject:[NSNumber numberWithInt:bt.tag]];
    }
}

- (void)resetTap
{
    tapClick = 0;
}

- (void) Blinking
{
    count++;
    count%=2;
    if(count == 1)
    {
        view.layer.borderColor = [[UIColor blueColor] CGColor];
        [self setBackground: [UIColor whiteColor]];
    }
    else
    {
        view.layer.borderColor = [[UIColor redColor] CGColor];
        [self setBackground: [UIColor yellowColor]];
    }
}
- (void) stopBlinkKing
{
    if (timer != Nil)
    {
        [timer invalidate];
        timer = Nil;
    }
}
- (void)releaseResource
{
     NSLog(@"%s",__FUNCTION__);
    @try
    {
        if (timer != Nil)
        {
             [timer invalidate];
            timer = Nil;
        }
        
        if (imageViewAnimal != Nil)
        {
            imageViewAnimal = Nil;
        }
        
        
        if (imageViewActivity != Nil)
        {
            imageViewActivity = Nil;
        }

        
        if (imageSmall != Nil)
        {
            imageSmall = Nil;
        }

        
        if (image != Nil)
        {
            image = Nil;
        }

        
        if(view && view.superview)
        {
//            [view removeFromSuperview];
            [view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        }

    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    
}

- (void) hidenLBL
{
    if(lbl)
    {
        lbl.hidden = YES;
    }
}

- (void) setCountFont:(UIFont*)font
{
    lbl.font = font;
}

- (void) setCountFrame:(CGRect) rect
{
    lbl.frame = rect;
}
- (void) createLBL:(NSString*)str
{
    if(!lbl)
    {
        lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(0, 80, view.frame.size.width, 35);
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor blackColor];
        lbl.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15];
        if(![str isEqualToString:@"0"])
            lbl.text = [NSString stringWithFormat:@"%@", str];
        if([str isEqualToString:@"FAILED"])
             lbl.textColor = [UIColor redColor];
        [view addSubview:lbl];
    }
    else
    {
        lbl.textColor = [UIColor blackColor];
        if([str isEqualToString:@"FAILED"])
            lbl.textColor = [UIColor redColor];
        lbl.text = [NSString stringWithFormat:@"%@", str];
    }
}
- (void)setSmallImage:(UIImage *)img withFrame:(CGRect) frame
{
    if(img)
    {
        imageSmall.image = img;
        imageSmall.hidden = NO;
        imageSmall.frame = frame;
    }
}

- (void)setSmallImage:(UIImage *)img
{
    if(img)
    {
        imageSmall.image = img;
        imageSmall.hidden = NO;
        CGRect rect = imagelogo.frame;
        float tile = width*1.0/320;
        imageSmall.frame = CGRectMake(width/2 - 30*tile, rect.origin.y+rect.size.height+50*tile, 60*tile, 60*tile);
        
        int top = imageSmall.frame.origin.y + imageSmall.frame.size.width;
        content.frame = CGRectMake(10, top, view.frame.size.width-20, view.frame.size.height-60 - top);//35
    }
}
- (void)setContentAligment:(NSTextAlignment) Alignment
{
    content.textAlignment = Alignment;
}
- (void)setContentToTop
{
    content.numberOfLines = 0;
   [content sizeToFit];
}
- (void)setContentCenterToPoint:(CGPoint)point
{
    content.center = point;
}
- (void)setContentFrame:(CGRect)rect
{
    content.frame = rect;
}

- (void)setContentFont:(UIFont*)font
{
    content.font = font;
}
- (void) setCaptionFont:(UIFont*)font
{
    caption.font = font;
}
- (void) setCaptionFrame:(CGRect)rect
{
    caption.frame = rect;
}
- (void) setCaptionBackground:(UIColor *)color
{
    caption.backgroundColor = color;
   
}
- (void) setbtnTest:(NSString *)test
{
    [btn setTitle:test forState:UIControlStateNormal];
    [btn setTintColor:[UIColor blackColor]];

}
- (void) setbtnFarme:(CGRect)rect
{
    btn.frame = rect;
    btn.layer.borderWidth =1;
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.cornerRadius = 10.0;
   
}
- (void) setbtnBackgroundColor:(UIColor *)color
{
    if(btn)
    {
        [btn setBackgroundImage:Nil forState:UIControlStateNormal];
        [btn setBackgroundImage:Nil forState:UIControlStateHighlighted];
        btn.backgroundColor = color;
    }
}
- (void) setbtCancelFarme:(CGRect)rect
{
    btnCancel.frame = rect;
    btnCancel.layer.borderWidth =1;
    btnCancel.layer.borderColor = [UIColor blueColor].CGColor;
    btnCancel.layer.cornerRadius = 10.0;
    
}
//-------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (void) updatePause
{
   
    UISegmentedControl *segmentedControl = (UISegmentedControl *)[view viewWithTag:5];
    if(!segmentedControl || count < 0 || vitriCount >= segmentedControl.numberOfSegments)
    {
        if(timer)
        {
            [timer invalidate];
            timer = Nil;
        }
        [self onclickWithTag:[NSNumber numberWithInt:tagEndOffTime]];
        return;
    }
    
    [segmentedControl setTitle:[NSString stringWithFormat:@"%@ %d",[buttonList objectAtIndex:vitriCount],count] forSegmentAtIndex:vitriCount];
    count --;
}
- (void)countWithItemSeg:(int)intdex countTime:(int)num endOffWithButtonNum:(int)tag
{
    vitriCount = intdex - 1;
    vitriCount = (vitriCount<0)?0:vitriCount;
    count = num;
    tagEndOffTime = tag + tagNum;
    if(timer)
    {
        [timer invalidate];
        timer = Nil;
    }
    if(timer == Nil)
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePause) userInfo:nil repeats:YES];

}
- (void) showContentSeg:(NSString *)msg title:(NSString *)title Button:(NSMutableArray*)buttons tag:(int)tag delegate:(id)delegate sel:(SEL)sel
{
    float tile = width*1.0/320;
    view.frame = CGRectMake( 0, 0, width, height);
    image.frame = CGRectMake(1, 2, width-2, height - 2);
    root = delegate;
    selector = sel;
    tagNum = tag;
    buttonList = [buttons copy];
    
//    caption.backgroundColor = [UIColor yellowColor];
//    content.backgroundColor =[UIColor blueColor];

    

    caption.frame = CGRectMake(10, 30, view.frame.size.width-20, TITLE_HIGHT);//35
    [self setBGImage:[UIImage imageNamed:@"MessageBG.png"]];

    caption.hidden = NO;
    
    if(segmenButton)
    {
        [segmenButton removeAllSegments];
        [segmenButton removeFromSuperview];
        segmenButton = Nil;
    }
    
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:buttons];
    segmentedControl.frame = CGRectMake(10, height - 60, width - 20, 50);
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.tintColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    if(AppShare.iOS < 7.0)
    {
//        segmentedControl.tintColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        segmentedControl.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
//        for (int i=0; i<[segmentedControl.subviews count]; i++)
//        {
//            UIView *view1 = [segmentedControl.subviews objectAtIndex:i];
////            CGRect rect = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height+5);
////            view.frame = rect;
//            view1.layer.borderWidth = 0;
//            view1.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0].CGColor;
//        }
        //    for (int i=0; i<[segmentedControl.subviews count]; i++)
        //    {
        //        if ([[segmentedControl.subviews objectAtIndex:i]isSelected]) {
        //            UIColor *tintcolor = [UIColor greenColor];
        //            [[segmentedControl.subviews objectAtIndex:i] setTintColor:tintcolor];
        //        } else {
        //            [[segmentedControl.subviews objectAtIndex:i] setTintColor:nil];
        //        }
        //    UIView *view = [segmentedControl.subviews objectAtIndex:i];
        //    view.layer.borderWidth = 1;
        //    view.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
        //    }

    }

    segmentedControl.layer.borderWidth = 0;
    segmentedControl.layer.cornerRadius = 12;
    segmentedControl.clipsToBounds = YES;
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    //    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"btBackground.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    [segmentedControl setDividerImage:[UIImage imageNamed:@"btBackgroundWhite.png"]  forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //segmentedControl.selectedSegmentIndex = 0;
    // we want attributed strings for this segmented control
    UIColor *textColor = [UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0];
    if(buttons.count > 3)
    {
        NSDictionary *textAttributes = @{ UITextAttributeTextColor:textColor, UITextAttributeFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16] };
        [segmentedControl setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        textAttributes = @{ UITextAttributeTextColor:textColor, UITextAttributeFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16] };
        [segmentedControl setTitleTextAttributes:textAttributes forState:UIControlStateHighlighted];
    }
    else
    {
        NSDictionary *textAttributes = @{ UITextAttributeTextColor:textColor, UITextAttributeFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20] };
        [segmentedControl setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        textAttributes = @{ UITextAttributeTextColor:textColor, UITextAttributeFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20] };
        [segmentedControl setTitleTextAttributes:textAttributes forState:UIControlStateHighlighted];

    }
    segmentedControl.tag = 5;
    [view addSubview:segmentedControl];
    
    caption.text = title;
    content.text = msg;

    [btn setHidden:YES];
    [btnCancel setHidden:YES];
    PlayBeep();
    
//    [AppShare.viewController.view addSubview:view];
    
}

- (void)segmentAction:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    int vt = segment.selectedSegmentIndex;
    NSLog(@"Button selectr: %d",vt);
    int tag = vt +  tagNum + 1;
    NSLog(@"tag = %d",tag);
    [self releaseResource];
    if(root && [root respondsToSelector:selector])
    {
        [root performSelector:selector withObject:[NSNumber numberWithInt:tag]];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
//    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    [txtTextbox resignFirstResponder];

}


//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}

- (BOOL)textViewDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)setTextboxValue:(NSString *)data
{
    if(txtTextbox)
        txtTextbox.text = data;
}
- (void) showWithTextbox:(NSString *)label textbox:(NSString*)textbox msg:(NSString *)msg title:(NSString *)title button:(NSString*)button cancel:(NSString*)cancel tag:(int)tag delegate:(id)delegate sel:(SEL)sel
{
    
    view.frame = CGRectMake(0, 0, width, height);
    view.backgroundColor = [UIColor whiteColor];
    root = delegate;
    selector = sel;
    tagNum = tag;
    [self resetTap];
    // cho BachUng
    caption.frame = CGRectMake(10, 10, view.frame.size.width-20, TITLE_HIGHT);//35

    if(timer == Nil)
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Blinking) userInfo:nil repeats:YES];

    
    CGRect r = CGRectMake(15, view.frame.size.height-65, view.frame.size.width-30, 50);
    if(button && ([button length] > 0))
    {
        setDataToDeleGate = YES;
        CGRect r1 = CGRectMake(view.frame.size.width/4, view.frame.size.height-65, view.frame.size.width/2, 50);
        caption.text = title;
        caption.textColor = [UIColor blackColor];
        labelTextboxTitle.hidden = NO;
        labelTextboxTitle.text = label;
        labelTextboxTitle.frame = CGRectMake(10, 60, view.frame.size.width - 20, 30);
        txtTextbox.hidden = NO;
        txtTextbox.frame = CGRectMake(10, 90, view.frame.size.width - 20, 50);
        txtTextbox.placeholder = [label stringByReplacingOccurrencesOfString:@":" withString:@""];
        txtTextbox.text = textbox;
        content.frame = CGRectMake(10, 140, view.frame.size.width-20, view.frame.size.height - 210);//35
        content.text = msg;
        content.textColor = [UIColor blackColor];
        
        btn.frame = r1;
        [btn setBackgroundImage:[UIImage imageNamed:@"btBackground.png"] forState:UIControlStateNormal];
        [btn setTitle:button forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [btn setHidden:NO];
#if defined(ERC) || defined(ENCO)
        if([[button uppercaseString] rangeOfString:@"FAILED"].location != NSNotFound)
        {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.layer.borderWidth = 0;
            btn.backgroundColor = [UIColor clearColor];
            [btn setBackgroundImage:[UIImage imageNamed:@"btBackgroundWhite.png"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }
#endif
        
        if(cancel && ([cancel length] > 0))
        {
            btn.frame = CGRectMake(r.origin.x-5, r.origin.y, r.size.width/2.0, r.size.height);
            btnCancel.frame = CGRectMake(r.size.width/2.0+15, r.origin.y, r.size.width/2.0, r.size.height);
            [btnCancel setTitle:[cancel uppercaseString] forState:UIControlStateNormal];
            [btnCancel setBackgroundImage:[UIImage imageNamed:@"btBackground.png"] forState:UIControlStateNormal];
            [btnCancel setHidden:NO];
            [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnCancel.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
#if defined(ERC) || defined(ENCO)
            if([[button uppercaseString] rangeOfString:@"FAILED"].location != NSNotFound)
            {
                [btnCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                btnCancel.layer.borderWidth = 0;
                [btnCancel setBackgroundImage:[UIImage imageNamed:@"btBackgroundWhite.png"] forState:UIControlStateNormal];
                [btnCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                btnCancel.backgroundColor = [UIColor clearColor];
            }
#endif
        }
        else
        {
            [btnCancel setHidden:YES];
        }
    }
    else
    {
        [btn setHidden:YES];
        [btnCancel setHidden:YES];
    }
    PlayBeep();
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [view addGestureRecognizer:singleFingerTap];

    
//    [AppShare.viewController.view addSubview:view];
    
}
#pragma mark -
/*
 Method: showWithContent:
 show view message with sub frame im maim frame.
 return : 
    click Button : return tabNum
    click Cancel : return 100 + tabNum
 
 */
- (void) showWithContent:(NSString *)msg title:(NSString *)title button:(NSString*)button cancel:(NSString*)cancel tag:(int)tag delegate:(id)delegate sel:(SEL)sel
{
    
    view.frame = CGRectMake( (width-300)/2, (height-350)/2, 300, 350);
    
    root = delegate;
    selector = sel;
    tagNum = tag;
    [self resetTap];

    // cho BachUng
    caption.frame = CGRectMake(10, 30, view.frame.size.width-20, TITLE_HIGHT);//35
    [self setBGImage:[UIImage imageNamed:@"MessageBG.png"]];
//    if(timer == Nil)
//        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Blinking) userInfo:nil repeats:YES];
//
    
    CGRect r = CGRectMake(15, view.frame.size.height-65, view.frame.size.width-30, 50);
    if(button && ([button length] > 0))
    {
        
        CGRect r1 = CGRectMake(view.frame.size.width/4, view.frame.size.height-65, view.frame.size.width/2, 50);
        caption.text = title;
        content.text = msg;
        btn.frame = r1;
        [btn setTitle:button forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btn.layer.backgroundColor = [UIColor whiteColor].CGColor;
        btn.layer.borderColor = [[UIColor blueColor] CGColor];
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 10;
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [btn setHidden:NO];
        
        if(cancel && ([cancel length] > 0))
        {
            btn.frame = CGRectMake(r.origin.x-5, r.origin.y, r.size.width/2.0, r.size.height);
            btnCancel.frame = CGRectMake(r.size.width/2.0+15, r.origin.y, r.size.width/2.0, r.size.height);
            [btnCancel setTitle:cancel forState:UIControlStateNormal];
            //[btnCancel setBackgroundImage:[UIImage imageNamed:@"btBackground.png"] forState:UIControlStateNormal];
            [btnCancel setHidden:NO];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            btn.layer.backgroundColor = [UIColor whiteColor].CGColor;
            btn.layer.borderColor = [[UIColor blueColor] CGColor];
            btn.layer.borderWidth = 1;
            btn.layer.cornerRadius = 10;;
            [btnCancel.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
        }
        else
        {
            [btnCancel setHidden:YES];
        }
    }
    else
    {
        [btn setHidden:YES];
        [btnCancel setHidden:YES];
    }
    PlayBeep();

//    [AppShare.viewController.view addSubview:view];
    
    
}

/*
 Method: showContentWith:
 show view message with sub frame im maim frame. with list title button: buttons
 return :
 click Button : return tabNum + 1 + vitri button
 
 */


- (void) showContentWith:(NSString *)msg title:(NSString *)title Button:(NSMutableArray*)buttons canceltag:(int)tag delegate:(id)delegate sel:(SEL)sel
{
    //view.frame = CGRectMake( ( width-300)/2, ( height-350)/2, 300, 350);
    view.frame = CGRectMake( 0, 0, width, height);
    image.frame = CGRectMake(1, 2, width-2, height - 2);
    // cho BachUng
    caption.frame = CGRectMake(10, 30, view.frame.size.width-20, TITLE_HIGHT);//35
    [self setBGImage:[UIImage imageNamed:@"MessageBG.png"]];


    CGRect r = CGRectMake(15, view.frame.size.height-65, view.frame.size.width-30, 50);
    int btNum = [buttons count];
    int anpha = 80;
    NSString *model = getPhoneModal(3);
    if([[model uppercaseString] rangeOfString:@"IPAD"].location == NSNotFound )
    {
        if(btNum > 4)
            anpha = 60;    
    }

    UIButton *bt;
    root = delegate;
    selector = sel;
    tagNum = tag;
    [self resetTap];
    
    caption.text = title;
    content.text = msg;
    content.frame = CGRectMake(10, 40, view.frame.size.width-20, view.frame.size.height-anpha*btNum);
    for (int i = 0; i< btNum; i++)
    {
        bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        bt.frame = CGRectMake(r.size.width/4+10,view.frame.size.height-anpha*btNum + i*anpha - 5, r.size.width/2, 50);

        bt.tag = i + tagNum + 1;
        [bt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        NSString *buttonStr = [NSString stringWithFormat:@"%@",[buttons objectAtIndex:i]];

#if defined(ERC) || defined(ENCO)
        [bt setBackgroundImage:[UIImage imageNamed:@"btBackgroundWhite.png"] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        if([[buttonStr uppercaseString] rangeOfString:@"FAILED"].location != NSNotFound)
            [bt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
#else
        if(ios >= 7)
        {
            bt.layer.backgroundColor = [[UIColor whiteColor] CGColor];
            bt.layer.borderColor = [[UIColor blueColor] CGColor];
            bt.layer.borderWidth = 1;
            bt.layer.cornerRadius = 10;
            [bt.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
            
        }
        [bt setBackgroundImage:[UIImage imageNamed:@"btBackground.png"] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
#endif
        [bt setTitle:buttonStr forState:UIControlStateNormal];
        [bt.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [bt addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:bt];
    }
    [btn setHidden:YES];
    [btnCancel setHidden:YES];
    PlayBeep();

    
//    [AppShare.viewController.view addSubview:view];
    
}
/*
 Method: showWithImage:
 show view message with sub frame im maim frame. with UIimage below title.
 return :
 click Button : return tabNum
 click cancel : return 100 + tagnum
 */

- (void) showWithImage:(UIImage *)img message:(NSString *)msg title:(NSString *)title button:(NSString*)button cancel:(NSString*)cancel tag:(int)tag delegate:(id)delegate sel:(SEL)sel
{
    
    view.frame = CGRectMake( (width-300)/2, (height-350)/2, 300, 350);
    
    root = delegate;
    selector = sel;
    tagNum = tag;
    [self resetTap];
    // cho BachUng
    caption.frame = CGRectMake(10, 30, view.frame.size.width-20, TITLE_HIGHT);//35
    [self setBGImage:[UIImage imageNamed:@"MessageBG.png"]];
    if(timer == Nil)
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Blinking) userInfo:nil repeats:YES];

    
    
    [self setSmallImage:img];
        
    CGRect r = CGRectMake(15, view.frame.size.height-65, view.frame.size.width-30, 50);
    if(button && ([button length] > 0))
    {
        
        CGRect r1 = CGRectMake(view.frame.size.width/4, view.frame.size.height-65, view.frame.size.width/2, 50);
        caption.text = title;
        content.text = msg;
        btn.frame = r1;
        btn.tag = tagNum + 1;
        [btn setBackgroundImage:[UIImage imageNamed:@"btBackground.png"] forState:UIControlStateNormal];
        [btn setTitle:button forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [btn setHidden:NO];
#if defined(ERC) || defined(ENCO)
        if([[button uppercaseString] rangeOfString:@"FAILED"].location != NSNotFound)
        {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.layer.borderWidth = 0;
            btn.backgroundColor = [UIColor clearColor];
            [btn setBackgroundImage:[UIImage imageNamed:@"btBackgroundWhite.png"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }
#endif
        [btn addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if(cancel && ([cancel length] > 0))
        {
            btn.frame = CGRectMake(r.origin.x-5, r.origin.y, r.size.width/2.0, r.size.height);
            btnCancel.frame = CGRectMake(r.size.width/2.0+15, r.origin.y, r.size.width/2.0, r.size.height);
            [btnCancel setTitle:cancel forState:UIControlStateNormal];
            [btnCancel setBackgroundImage:[UIImage imageNamed:@"btBackground.png"] forState:UIControlStateNormal];
            [btnCancel setHidden:NO];
            btnCancel.tag = tagNum + 2;
            [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnCancel.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
#if defined(ERC) || defined(ENCO)
            if([[button uppercaseString] rangeOfString:@"FAILED"].location != NSNotFound)
            {
                [btnCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                btnCancel.layer.borderWidth = 0;
                [btnCancel setBackgroundImage:[UIImage imageNamed:@"btBackgroundWhite.png"] forState:UIControlStateNormal];
                [btnCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                btnCancel.backgroundColor = [UIColor clearColor];
            }
#endif
            [btnCancel addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [btnCancel setHidden:YES];
        }
    }
    else
    {
        [btn setHidden:YES];
        [btnCancel setHidden:YES];
    }
    PlayBeep();
    
//    [AppShare.viewController.view addSubview:view];
    
    
}
/*
 Method: showNoneButton:
 show view message with sub frame im maim frame. none button select.
*/
- (void) showNoneButton:(NSString *)msg title:(NSString *)title
{
    view.frame = CGRectMake( ( width-300)/2, ( height-350)/2, 300, 350);
float tile = width*1.0/320;
    // cho BachUng
    caption.frame = CGRectMake(10, 30, view.frame.size.width-20, TITLE_HIGHT);//35
    [self setBGImage:[UIImage imageNamed:@"MessageBG.png"]];
//    if(timer == Nil)
//         timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Blinking) userInfo:nil repeats:YES];

    
        CGRect r1 = CGRectMake(view.frame.size.width/4, view.frame.size.height-65, view.frame.size.width/2, 50);
        caption.text = title;
        content.text = msg;
    
        btn.frame = r1;
        [btn setBackgroundImage:[UIImage imageNamed:@"btBackground.png"] forState:UIControlStateNormal];

        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];

        [btn setHidden:YES];
        
        [btnCancel setHidden:YES];
    
    PlayBeep();

//    [AppShare.viewController.view addSubview:view];
    
}

/*
 Method: showContentFull:
 show view message with Main frame . with UIimage below title. with button image buttonbg
 return :
 click Button : return tabNum
 */

- (void) showContentFull:(NSString *)msg title:(NSString *)title ButtonImg:(UIImage*)buttonbg btPress:(UIImage*)btPress tag:(int)tag delegate:(id)delegate sel:(SEL)sel
{
    root = delegate;
    selector = sel;
    tagNum = tag;
    view.frame = CGRectMake( 0, 0, width, height);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 0;
    view.layer.cornerRadius = 0;
    
    [self createLBL:@""];
    
    
    
    caption.frame = CGRectMake(10, 10, view.frame.size.width-20, TITLE_HIGHT);//35
    caption.textColor  = [UIColor blackColor];
    caption.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    caption.text = title;
    
    
    content.frame = CGRectMake(10, view.frame.size.height/2, view.frame.size.width-20, view.frame.size.height-110);
    content.text = msg;
    content.textColor = [UIColor blackColor];
    content.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
//    [content setNumberOfLines:0];
    [content sizeToFit];
    content.center = CGPointMake(view.frame.size.width/2,  content.frame.origin.y+content.frame.size.height/2);
    lbl.frame = CGRectMake(10, view.frame.size.height/2 - 60, view.frame.size.width-20, 35);
    
    if(buttonbg==Nil || btPress == Nil)
    {
        btn.hidden = YES;
    }
    else
    {
        btn.frame = CGRectMake(view.frame.size.width/2-40, view.frame.size.height-100,80, 90);
        [btn setBackgroundImage:buttonbg forState:UIControlStateNormal];
        [btn setBackgroundImage:btPress forState:UIControlStateHighlighted];
        btn.layer.borderWidth = 0;
        btn.layer.cornerRadius = 0;
        btn.tag = tagNum+1;
    }
    PlayBeep();
    
//    [AppShare.viewController.view addSubview:view];

}
/*
 Method: showContentFull:
 show view message with Main frame . with UIimage Animal below title. with image suport imagesdong
 return :
 click Button : return tabNum
 */
- (void) showContentTime:(int)Time message:(NSString *)msg title:(NSString *)title ImageList:(NSArray *)images ImageDong:(NSArray *)imagesdong tag:(int)tag delegate:(id)delegate sel:(SEL)sel
{
    
    [self showContentTime:Time title:title ImageList:images ImageDong:imagesdong tag:tag delegate:delegate sel:sel];
    content.text = msg;
    content.textColor = [UIColor blackColor];
    [content sizeToFit];
    content.center = CGPointMake(width/2,  (height-content.frame.size.height)/2);

}

- (void) showContentTime:(int)Time title:(NSString *)title ImageList:(NSArray *)images ImageDong:(NSArray *)imagesdong tag:(int)tag delegate:(id)delegate sel:(SEL)sel
{
    root = delegate;
    selector = sel;
    tagNum = tag;
    view.frame = CGRectMake( 0, 0, width, height);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 0;
    view.layer.cornerRadius = 0;
    
    [self createLBL:@""];
    
    
    
    caption.frame = CGRectMake(10, 10, view.frame.size.width-20, TITLE_HIGHT);//35
    caption.textColor  = [UIColor blackColor];
    caption.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    caption.text = title;
    
    
    
    if(images)// quay vong tron
    {
        [self createLBL:[NSString stringWithFormat:@"%d s",Time]];
        [imageViewActivity setBackgroundColor:[UIColor clearColor]];
        imageViewActivity.animationImages = images;
        imageViewActivity.animationDuration = Time;//*1.0/images.count;
        imageViewActivity.animationRepeatCount = 0;
        imageViewActivity.hidden = NO;
        [imageViewActivity startAnimating];
        lbl.frame = imageViewActivity .frame;
        lbl.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
    }
    btn.hidden = YES;
    
    if(imagesdong)// catoon
    {
        [imageViewAnimal setBackgroundColor:[UIColor clearColor]];
        imageViewAnimal.animationImages = imagesdong;
        imageViewAnimal.animationDuration = imagesdong.count*1.0/6;//*1.0/images.count;
        imageViewAnimal.animationRepeatCount = 0;
        imageViewAnimal.hidden = NO;
        [imageViewAnimal startAnimating];
        
    }
    
    
    PlayBeep();
    
//    [AppShare.viewController.view addSubview:view];
    
}
- (void) setImageForViewAnimal:(UIImage *)img
{
    if(imageViewAnimal==Nil) return;
    imageViewAnimal.hidden = NO;
    if(imageViewAnimal.isAnimating)
        [imageViewAnimal stopAnimating];
    imageViewAnimal.image = img;
}
- (void) setTimeViewProcessActivity:(float)time
{
    if(imageViewActivity)
    {
        [imageViewActivity stopAnimating];
        imageViewActivity.animationDuration = time;
        [imageViewActivity startAnimating];
    }
}

- (void) setTimeViewAnimal:(float)time
{
    if(imageViewAnimal)
    {
        [imageViewAnimal stopAnimating];
        imageViewAnimal.animationDuration = time;
        [imageViewAnimal startAnimating];
    }
}
- (void) setFarmeViewAnimal:(CGRect)rect
{
    if(imageViewAnimal)
    {
        imageViewAnimal.frame = rect;
    }
}

- (void) setFarmeViewProcessActivity:(CGRect)rect
{
    if(imageViewActivity)
    {
        imageViewActivity.frame = rect;
    }
    else NSLog(@"imageViewActivity nil");
}

- (void) addView:(UIView *)viewsub
{
    if(viewsub)
    {
         [view addSubview:viewsub];
    }
}
- (UIView *)viewWithTag:(int)tag
{
    return [view viewWithTag:tag];
}
/*
 Method: showContentFull:
 show view message with Main frame . with UIimage below title. with button image buttonbg
 return :
 click Button : return tabNum
 */

- (void) showContentWithControll:(NSString *)msg title:(UIImageView *)titleImgView Slogan:(UIImageView *)sloganImgView ButtonImg:(UIImage*)buttonbg btPress:(UIImage*)btPress tag:(int)tag delegate:(id)delegate sel:(SEL)sel
{
    root = delegate;
    selector = sel;
    tagNum = tag;
    view.frame = CGRectMake( 0, 0, width, height);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 0;
    view.layer.cornerRadius = 0;
    
    [self createLBL:@""];
    
    [self addView:titleImgView];
    [self addView:sloganImgView];
    
    
    caption.frame = CGRectMake(10, 10, view.frame.size.width-20, TITLE_HIGHT);//35
    caption.textColor  = [UIColor blackColor];
    caption.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    caption.text = @"";
    
    
    content.frame = CGRectMake(10, view.frame.size.height/2, view.frame.size.width-20, view.frame.size.height-110);
    content.text = msg;
    content.textColor = [UIColor blackColor];
    content.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    //    [content setNumberOfLines:0];
    [content sizeToFit];
    content.center = CGPointMake(view.frame.size.width/2,  content.frame.origin.y+content.frame.size.height/2);
    lbl.frame = CGRectMake(10, view.frame.size.height/2 - 60, view.frame.size.width-20, 35);
    
    if(buttonbg==Nil || btPress == Nil)
    {
        btn.hidden = YES;
    }
    else
    {
        btn.frame = CGRectMake(view.frame.size.width/2-40, view.frame.size.height-100,80, 90);
        [btn setBackgroundImage:buttonbg forState:UIControlStateNormal];
        [btn setBackgroundImage:btPress forState:UIControlStateHighlighted];
        btn.layer.borderWidth = 0;
        btn.layer.cornerRadius = 0;
        btn.tag = tagNum+1;
    }
    PlayBeep();
    
 //   [AppShare.viewController.view addSubview:view];
    
}
@end
