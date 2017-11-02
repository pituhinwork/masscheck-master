//
//  TouchScreen.m
//  IVERIFY
//
//  Created by Lich Duyet on 8/27/14.
//  Copyright (c) 2014MaTran All rights reserved.
//

#import "TouchScreen.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "MainTestViewController.h"

#define TOUCHSCREEN_NONE 0
#define TOUCHSCREEN_CONFIC 1
#define TOUCHSCREEN_START 2
#define TOUCHSCREEN_FINISHED 3


@interface TouchScreen ()

@end

@implementation TouchScreen
@synthesize ID;
@synthesize key;
@synthesize dong;
@synthesize cot;
@synthesize msg;
@synthesize tableButton;
@synthesize parentView;

- (id)init
{
    self= [super init];
    ID = -1;
    key = @"TouchScreen";
    status = TOUCHSCREEN_NONE;
    arrayRect = Nil;
    arrayFlag = Nil;
    orientionPass = NO;
    curvt = 0;bien = 4;
    dong = 4;
    cot = 2;
    lbTimeShow = Nil;
    scrollView = Nil;
    tableButton = Nil;
    AppShare = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return self;
}
- (void) dealloc
{
    if(tableButton)
    {
  //      [tableButton release];
        tableButton = Nil;
    }
    
    if(imageView)
    {
  //      [imageView release];
        imageView = nil;
    }
    
    AppLog(@"========= 1");
    if (lbTimeShow)
    {
   //     [lbTimeShow release];
        lbTimeShow = Nil;
    }
//    if(arrayRect != Nil)
//        [arrayRect release];
//    if(arrayFlag != Nil)
//        [arrayFlag release];
//    if(dataDong)
//       [dataDong release];
//    if(dataCot)
//        [dataCot release];
//    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppLog();
//    [self.view setMultipleTouchEnabled:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setUserInteractionEnabled:YES];
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.view.frame = rect;
    tile = rect.size.width*1.0/320;
    imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.userInteractionEnabled = NO;
    [self.view addSubview:imageView];

    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    if(rect.size.width < 768)
        label.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    else label.font = [UIFont fontWithName:@"Roboto-Light" size:40];
    label.text = AppShare.DragToFillTheWholeDisplayText;
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
//    [label release];
    
    
    lbTimeShow = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width - 60, rect.size.height - 60, 60, 60)];
    lbTimeShow.backgroundColor = [UIColor clearColor];
    lbTimeShow.textAlignment = NSTextAlignmentCenter;
    lbTimeShow.textColor = [UIColor blackColor];
    [self.view addSubview:lbTimeShow];
    
    
    [self addvitri];
    [self initResource];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom method

- (void) addvitri
{
    AppLog();
    int top = 110,left=0,width=80,heigh=70;
    CGRect r;
    
    if(!arrayRect)
        arrayRect  = [[NSMutableArray alloc] init];
    else [arrayRect removeAllObjects];
    
    
    AppLog(@"%s dong:%d, cot:%d",__FUNCTION__,dong,cot);
    
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    int with_du=0,heigh_du=0,hdu=0,wdu=0,widthTemp=0,heighTemp=0;
    int n=2, m=4;
    AppLog(@"dong:%d, cot:%d",dong,cot);
    if(dong > 0 && cot > 0)
    {
        n = cot;
        m = dong;
    }
    width=rect.size.width;
    heigh=rect.size.height;
    heigh_du = heigh % m;
    with_du = width % n;
    widthTemp=rect.size.width/n;
    heighTemp=rect.size.height/m;
    
    int counti = 0, countj = 0;
    top = 0;left = 0;
    for(int i=0; i<n; i++)
    {
        for(int j=0; j<m; j++)
        {
            hdu = 0; wdu= 0;
            counti = with_du, countj = heigh_du;
            if(i < with_du)
            {
                wdu = 1;
                counti = i;
            }
            if(j < heigh_du)
            {
                hdu = 1;
                countj = j;
            }
            width = widthTemp + wdu;
            heigh = heighTemp + hdu;
            
            r = CGRectMake(left+i*widthTemp + counti, top+j*heighTemp + countj, width, heigh);
            //             r = CGRectMake(left+i*width, top+j*heigh, width, heigh);
            [arrayRect addObject:[NSValue valueWithCGRect:r]];
            
            
            
        }
    }
    
    AppLog(@"rect.size.width:%.0f, rect.size.heigh:%.0f",rect.size.width,rect.size.height);
    AppLog(@"with_du:%d, heigh_du:%d",with_du,heigh_du);
    
    if(!arrayFlag)
        arrayFlag = [[NSMutableArray alloc] init];
    else [arrayFlag removeAllObjects];
    for(int i=0;i<arrayRect.count;i++)
    {
        [arrayFlag  addObject:[NSNumber numberWithInt:0]];
    }
    
}


- (void) initResource
{
    //AppLog();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(self.view.bounds.size);
    context = UIGraphicsGetCurrentContext();
    [self initScreen];
    
}
- (void) initScreen
{
    // AppLog();
    CGContextSetRGBStrokeColor(context, 0.5, 0.0, 0.5, 0.0);
    CGContextSetRGBFillColor(context, 0.5, 0.0, 0.5, 0.0);
    CGContextFillRect(context, self.view.bounds);
    
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
    
    
    int kt = (int)[arrayRect count];
    //        float fsite = [UIFont systemFontSize]+10;
    for(int i = 0; i< kt;i++)
    {
        
        
//        int flag = [[arrayFlag objectAtIndex:i] intValue];
//        if(flag == 0)
//        {
//          
//            CGContextSetRGBStrokeColor(context, 0x47*1.0/0xff, 0x70*1.0/0xff, 0x8f*1.0/0xff, 1.0);
//            CGContextSetRGBFillColor(context, 0x47*1.0/0xff, 0x70*1.0/0xff, 0x8f*1.0/0xff, 1.0);
//            CGRect someRect = [[arrayRect objectAtIndex:i] CGRectValue];
//            CGContextFillRect(context, someRect);
//            
//            CGContextSetRGBStrokeColor(context,  0x6a*1.0/0xff, 0x88*1.0/0xff, 0xA7*1.0/0xff, 1.0);
//            CGContextStrokeRect(context, someRect);
//            
//            
//        }
//        else
//        {
//            CGContextSetRGBStrokeColor(context, 0x6a*1.0/0xff, 0x88*1.0/0xff, 0xA7*1.0/0xff, 1.0);
//            CGContextSetRGBFillColor(context, 0x6a*1.0/0xff, 0x88*1.0/0xff, 0xA7*1.0/0xff, 1.0);
//            CGRect someRect = [[arrayRect objectAtIndex:i] CGRectValue];
//            CGContextFillRect(context, someRect);
//            
//            
//        }

        
        int flag = [[arrayFlag objectAtIndex:i] intValue];
        if(flag == 0)
        {
            
            CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
            CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);

            CGRect someRect = [[arrayRect objectAtIndex:i] CGRectValue];
            CGContextFillRect(context, someRect);
            
            //draw line
             CGContextSetLineWidth(context, 0.3);
                CGContextSetRGBStrokeColor(context, 0xC0*1.0/0xff,  0xC0*1.0/0xff,  0xC0*1.0/0xff, 1.0);
                CGContextStrokeRect(context, someRect);
//            CGContextAddRect(context, someRect);
            
        }
        else
        {

            CGContextSetRGBStrokeColor(context, 0xC0*1.0/0xff,  0xC0*1.0/0xff,  0xC0*1.0/0xff, 1.0);
            CGContextSetRGBFillColor(context, 0xC0*1.0/0xff,  0xC0*1.0/0xff,  0xC0*1.0/0xff, 1.0);

            CGRect someRect = [[arrayRect objectAtIndex:i] CGRectValue];
            CGContextFillRect(context, someRect);
            
            
        }

        
        
    }
    
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    [imageView setImage:image];
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0.0, 1.0);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 0.0, 1.0);
    
}

- (void) failedCheck:(NSString*)desc
{
    if(status != TOUCHSCREEN_FINISHED)
    {
        isPassed = NO;
        status = TOUCHSCREEN_FINISHED;
        
        
        UIApplication *application = [UIApplication sharedApplication];
        [application setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
        //[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
        [super updateViewConstraints];
        [self.view updateConstraints];
        
        [parentView updateResult:ID value:[NSString stringWithFormat:@" %@#%@#%@",key,isPassed?@"PASSED":@"FAILED",desc]];
        [parentView finishTest:key position:ID];
        
        [self releaseResource];
    }
}

- (void) successCheck:(NSString*)desc
{
    if(status != TOUCHSCREEN_FINISHED)
    {
        isPassed = YES;
        status = TOUCHSCREEN_FINISHED;
        
        [parentView updateResult:ID value:[NSString stringWithFormat:@" %@#%@#%@",key,isPassed?@"PASSED":@"FAILED",desc]];
        [parentView finishTest:key position:ID];
        
        [self releaseResource];
    }
}

- (void) startAutoTest:(NSString*)rKey param:(NSString*)param
{
    AppLog(@"%s startAutoTest dong:%d, cot:%d",__FUNCTION__,dong,cot);
    
    status = TOUCHSCREEN_START;
    if(!self.view.superview)
        [parentView.view addSubview:self.view];
    else
        [parentView.view bringSubviewToFront:self.view];
    PlayBeep();
    status = TOUCHSCREEN_CONFIC;
    dong = 10;
    cot = 10;

    if(parentView.aceptRetest==YES)
    {
        [self initScrollView];
        pickerInfor.backgroundColor = [UIColor whiteColor];
        [pickerInfor selectRow:dong-1 inComponent:0 animated:NO];
        [pickerInfor selectRow:cot-1 inComponent:1 animated:NO];
        [self.view addSubview:scrollView];

    }
    else [self performSelector:@selector(onContinue:) withObject:Nil afterDelay:1];//60
}

- (void) initScrollView
{
    if(scrollView!=Nil) return;
    
    CGRect rect1 = parentView.view.frame;
    scrollView = [[UIScrollView alloc] initWithFrame:rect1];
    scrollView.backgroundColor = [UIColor whiteColor];
    int height = rect1.size.height;
    int width = rect1.size.width;
    
    if(height < 500)
        height += 60;
    scrollView.contentSize = CGSizeMake(width, height);
    scrollView.userInteractionEnabled = YES;
    
    
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, TITLE_HIGHT)];
    lbTitle.text = @"Digitizer";
    [lbTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.backgroundColor = [UIColor colorWithRed:0xEF*1.0/0xFF green:0xEF*1.0/0xFF blue:0xF4*1.0/0xFF alpha:1];
    
    
    
    int lbHeigh = 150;
    int lbtop = 60;
    int lbleft = 10;
    
    
    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(lbleft, lbtop, width-lbleft, lbHeigh)];
    label0.text = @"Digitizer configured";
    label0.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    
    label0.numberOfLines = 0;
    label0.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:label0];
//    [label0 release];
    
    float num = (float)[UIScreen mainScreen].bounds.size.height;
    AppLog(@"heiscreen = %.0f",num);
    if(num < (float)500)
    {
        lbHeigh = 30;
        lbtop = 200;
    }
    else
    {
        lbHeigh = 30;
        lbtop = 230;
    }
    UILabel *label1;
    
    
    int maxdong = 40;
    int maxcot = 25;
    
    
    dataDong = [[NSMutableArray alloc] init];
    dataCot  = [[NSMutableArray alloc] init];
    for (int i = 1; i<= maxdong; i++)
    {
        [dataDong addObject:[NSString stringWithFormat:@"%d",i]];
        if(i<= maxcot)
            [dataCot addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    lbtop += lbHeigh;
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(lbleft, lbtop, width/2-lbleft, 25)];
    label1.text = @"Row";
    label1.font = [UIFont boldSystemFontOfSize:24];
    label1.layer.borderWidth = 1;
    label1.layer.borderColor =[UIColor blackColor].CGColor;
    label1.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:label1];
//    [label1 release];
    
//    if(AppShare.iOS < (float)8.0)
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(width/2, lbtop, width/2-lbleft, 25)];
    //else label1 = [[UILabel alloc] initWithFrame:CGRectMake(width/2, lbtop, width/2-lbleft+1, 25)];
    label1.text = @"Col";
    label1.font = [UIFont boldSystemFontOfSize:24];
    label1.layer.borderWidth = 1;
    label1.layer.borderColor =[UIColor blackColor].CGColor;
    label1.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:label1];
 //   [label1 release];
    
    
    lbtop += 24;
    
    if(AppShare.iOS >= (float)8.0)
        lbHeigh = 150;

    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(lbleft, lbtop, width-2*lbleft, lbHeigh)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.layer.borderWidth = 1;
    pickerView.layer.borderColor =[UIColor blackColor].CGColor;
    [scrollView addSubview:pickerView];
    pickerInfor = pickerView;
//    [pickerView release];
    
    lbtop += lbHeigh;
    lbtop += 60;
    NSString *partNum = getPhoneModal(2);
    NSString *model = [UIDevice currentDevice].model;
    AppLog(@"model: %@, partNum:%@, IOS: %.2f",model,partNum,AppShare.iOS);
    
    
    
    UIButton *btContinue = [UIButton buttonWithType:UIButtonTypeCustom];
    [btContinue setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btContinue.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:24];
    btContinue.frame = CGRectMake(10, height - 60*height*1.0/568, 300*width*1.0/320.0, 50*height*1.0/568);
    [btContinue setTitle:AppShare.STARTText forState:UIControlStateNormal];
    [btContinue setBackgroundColor:[UIColor whiteColor]];
    [btContinue addTarget:self action:@selector(onContinue:) forControlEvents:UIControlEventTouchUpInside];
    btContinue.layer.borderColor = [UIColor blueColor].CGColor;
    btContinue.layer.borderWidth = 1;
    [scrollView addSubview:btContinue];

}
//- (void) startImation
//{
//    float time = 1.0;
//    CGRect rect = [[UIScreen mainScreen] bounds];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:time];
////    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    if(countAnimation == 0)
//    imageViewAnimation.center = CGPointMake(3*rect.size.width/4, rect.size.height/4+rect.size.height/8);
//    if(countAnimation == 1)
//    imageViewAnimation.center = CGPointMake(3*rect.size.width/4, 3*rect.size.height/4+rect.size.height/8);
//    if(countAnimation == 2)
//    imageViewAnimation.center = CGPointMake(rect.size.width/4, 3*rect.size.height/4+rect.size.height/8);
//    if(countAnimation == 3)
//    imageViewAnimation.center = CGPointMake(rect.size.width/4, rect.size.height/4+rect.size.height/8);
//    [UIView commitAnimations];
//    countAnimation++;
//    countAnimation = countAnimation%4;
//    if(imageViewAnimation.hidden== NO)
//        [self performSelector:@selector(startImation) withObject:Nil afterDelay:time];
//}
- (void) onContinue:(id)sender
{
    if(scrollView && scrollView.superview)
    {
        [scrollView removeFromSuperview];
    }
    if (status != TOUCHSCREEN_CONFIC)
    {
        return;
    }
    status = TOUCHSCREEN_START;
    dem = 0;
    [self addvitri];
    [self initResource];
    
    timeout = 30;
    if(dong * cot > 50)
        timeout = 60;
    if(dong * cot > 100)
        timeout = 90;
    if(dong * cot > 150)
        timeout = 120;
    if(dong * cot > 200)
        timeout = 150;
    if(dong * cot > 250)
        timeout = 180;
    if(dong * cot > 300)
        timeout = 240;
    AppLog(@"timeout: %d",timeout);
    
    imageViewProcess.animationDuration = timeout;
    [imageViewProcess startAnimating];

    callCount++;
    [self performSelector:@selector(timeout:) withObject:[NSNumber numberWithInt:callCount] afterDelay:timeout];
    [self performSelector:@selector(countTime) withObject:Nil afterDelay:1];
    countAnimation = 0;
//    [self startImation];
    
}
- (void)timeout:(NSNumber*)num
{
    if([num intValue] == callCount)
    {
    [self failedCheck:@"timeout"];
    }
}
- (void) countTime
{
    if( status == TOUCHSCREEN_FINISHED)
        return;
    if(timeout > 0)
    {
        
        int width= 45,height=45;
        CGRect rect = [[UIScreen mainScreen] bounds];
        if(rect.size.width < 768)
        {
            width= 100,height=100;
        }
        else
        {
            width= 150,height=150;
        }
        timeout --;
        lbTimeShow.text = [NSString stringWithFormat:@"%ds",timeout];
        [self performSelector:@selector(countTime) withObject:Nil afterDelay:1];
        
        if(timeout<15)
            [self updateDrawTimeout];
    }
}

- (void) releaseResource
{
    if(self.view && self.view.superview)
    {
        [self.view removeFromSuperview];
    }
    UIGraphicsEndImageContext();
}


#pragma mark - Touch delegate method



- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // AppLog();
  
    [self updateDrawTouch:touches];
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    AppLog();
//    if(!imageViewAnimation.hidden)
//        imageViewAnimation.hidden = YES;
    [self updateDrawTouch:touches];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   // AppLog();
    [self updateDrawTouch:touches];
}
- (void) updateDrawTouch:(NSSet*)array
{
    CGPoint point;
    //    AppLog(@"%d",[array count]);
    for(UITouch *item in array)
    {
        point = [item locationInView:self.view];
        int bd=0,kt=(int)[arrayRect count];
        
        for(int i = bd; i< kt;i++)
        {
            CGRect someRect = [[arrayRect objectAtIndex:i] CGRectValue];
            if (CGRectContainsPoint(someRect, point))
            {
                CGContextFillRect(context, someRect);
                int flag = [[arrayFlag objectAtIndex:i] intValue];
                if(flag == 0)
                {
                    [arrayFlag replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:1]];
                    dem ++;
                    if(dem == arrayRect.count)
                    {
                        [self initResource];
                        [self performSelector:@selector(successCheck:) withObject:@" " afterDelay:0.5];
                        //[self successCheck:@" "];
                        return;
                    }
                }
            }
        }
        
        
    }
    CGContextStrokePath(context);
    image = UIGraphicsGetImageFromCurrentImageContext();
    [imageView setImage:image];
    [self initResource];
}


- (void) updateDrawTimeout
{

    int bd=0,kt=(int)[arrayRect count];
    
    for(int i = bd; i< kt;i++)
    {
        int flag = [[arrayFlag objectAtIndex:i] intValue];
        if(flag == 0)
        {
            if(timeout%2)
            {
                CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
                CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
            }
            else
            {
                CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
                CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);

            }
                CGRect someRect = [[arrayRect objectAtIndex:i] CGRectValue];
                CGContextFillRect(context, someRect);
            CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0.0, 1.0);
            CGContextStrokeRect(context, someRect);
        }
        
    }
    
    CGContextStrokePath(context);
    image = UIGraphicsGetImageFromCurrentImageContext();
    [imageView setImage:image];
}


#pragma mark -
#pragma mark UIPickerView Delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 1)
    {
        return [dataCot count];
    }
    return [dataDong count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 1)
    {
        return [dataCot  objectAtIndex:row];
    }
    return [dataDong  objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        dong = [[dataDong objectAtIndex:row] intValue];
    }
    else
    {
        cot  = [[dataCot objectAtIndex:row] intValue];
    }
    AppLog(@"dong: %d, cot: %d",dong,cot);
}

@end
