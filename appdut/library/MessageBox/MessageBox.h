//
//  MessageBox.h
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface MessageBox : NSObject
{
    id root;
    SEL selector;
    
    UIView *view;
    
    int tagNum;
    int ios;
    
    
    UILabel *caption;
    UILabel *content;
    UIButton *btn;
    UIButton *btnCancel;
    UIImageView *image;
    UIImageView *imageSmall;
    UIImageView *imagelogo;
    UISegmentedControl *segmenButton;
    int vitriCount;// dem so tren seg
    int tagEndOffTime;// khi het thoi gian se tra ve
    NSMutableArray *buttonList;
    
    UILabel *labelTextboxTitle;
    UITextField *txtTextbox;
    
    
    NSTimer *timer;
    int count;
    int tapClick;
    int width;
    int height;
    BOOL setDataToDeleGate;
    UIImageView *imageViewActivity;
    UIImageView *imageViewAnimal;
    
}

@property (nonatomic, strong) UILabel *lbl;


- (void) showWithTextbox:(NSString *)label textbox:(NSString*)textbox msg:(NSString *)msg title:(NSString *)title button:(NSString*)button cancel:(NSString*)cancel tag:(int)tag delegate:(id)delegate sel:(SEL)sel;
- (void) showWithContent:(NSString *)msg title:(NSString *)title button:(NSString*)button cancel:(NSString*)cancel tag:(int)tag delegate:(id)delegate sel:(SEL)sel;
- (void) showContentWith:(NSString *)msg title:(NSString *)title Button:(NSMutableArray*)button canceltag:(int)tag delegate:(id)delegate sel:(SEL)sel;
- (void) showContentSeg:(NSString *)msg title:(NSString *)title Button:(NSMutableArray*)buttons tag:(int)tag delegate:(id)delegate sel:(SEL)sel;
- (void) showNoneButton:(NSString *)msg title:(NSString *)title;
- (void) showWithImage:(UIImage *)img message:(NSString *)msg title:(NSString *)title button:(NSString*)button cancel:(NSString*)cancel tag:(int)tag delegate:(id)delegate sel:(SEL)sel;
- (void) onclick;
- (void) dismiss;

- (void)setContentAligment:(NSTextAlignment) Alignment;
- (void)setContentToTop;
- (void)setContentCenterToPoint:(CGPoint)point;
- (void)setContentFont:(UIFont*)font;
- (void)setContentFrame:(CGRect)rect;

- (void)setTextboxValue:(NSString *)data;
- (void)setCaptionFont:(UIFont*)font;
- (void)setCaptionFrame:(CGRect)rect;
- (void)setCaptionBackground:(UIColor *)color;
- (void)setbtnFarme:(CGRect)rect;

- (void) stopBlinkKing;
- (void) onClickNoSound;
- (void) setBackground:(UIColor *) color;
- (void) setBGImage:(UIImage *) img;

- (void)setSmallImage:(UIImage *)img;
- (void)setSmallImage:(UIImage *)img withFrame:(CGRect) frame;

- (void) addView:(UIView *)viewsub;
- (UIView *)viewWithTag:(int)tag;

- (void) setBorderWidth:(float)width corner:(float)cornerRadius;
- (void) setFrame:(CGRect) rect;
- (void) btClick:(id)sender;
- (void) onclickWithTag:(NSNumber*)tag;
- (void)countWithItemSeg:(int)intdex countTime:(int)num endOffWithButtonNum:(int)tag;
- (void) showContentFull:(NSString *)msg title:(NSString *)title ButtonImg:(UIImage*)buttonbg btPress:(UIImage*)btPress tag:(int)tag delegate:(id)delegate sel:(SEL)sel;

- (void) showContentTime:(int)Time title:(NSString *)title ImageList:(NSArray *)images ImageDong:(NSArray *)imagesdong tag:(int)tag delegate:(id)delegate sel:(SEL)sel;
- (void) showContentTime:(int)Time message:(NSString *)msg title:(NSString *)title ImageList:(NSArray *)images ImageDong:(NSArray *)imagesdong tag:(int)tag delegate:(id)delegate sel:(SEL)sel;

- (void) setTimeViewAnimal:(float)time;// xu ly time for image dong
- (void) setFarmeViewAnimal:(CGRect)rect;//xu ly vi tri cho image dong
- (void) setImageForViewAnimal:(UIImage *)img; //stop image dong and change image to show

- (void) setTimeViewProcessActivity:(float)time;
- (void) setFarmeViewProcessActivity:(CGRect)rect;

- (void) showContentWithControll:(NSString *)msg title:(UIImageView *)titleImgView Slogan:(UIImageView *)sloganImgView ButtonImg:(UIImage*)buttonbg btPress:(UIImage*)btPress tag:(int)tag delegate:(id)delegate sel:(SEL)sel;
- (void) hidenLBL;
- (void) setCountFrame:(CGRect) rect;
- (void) setCountFont:(UIFont*)font;
- (void) createLBL:(NSString*)str;
- (void) setbtnBackgroundColor:(UIColor *)color;
- (void) setbtnTest:(NSString *)test;
- (void) setbtCancelFarme:(CGRect)rect;
@end
