//
//  ValueScrollViewController.m
//  MassTrade
//
//  Created by Admin on 9/28/17.
//  Copyright © 2017 GDT. All rights reserved.
//

#import "ValueScrollViewController.h"
#import "iDevice.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "TestListViewController.h"

@interface ValueScrollViewController () <UIScrollViewDelegate>

@end

@implementation ValueScrollViewController
@synthesize currentPage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppShare = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _scrollView.delegate = self;
    [_pageBar1 setBackgroundColor:[UIColor colorWithRed:29 green:179 blue:99 alpha:1]];
    [_pageBar2 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
    [_pageBar3 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
    currentPage = 0;
    
    [_mobileModel setText:[NSString stringWithFormat:@"%@ %@ GB",getPhoneModal(4),[AppShare.checkPart getCapacity]]];
    
    NSString *imageURL = [_dic objectForKey:@"qrcode"];
    UIImage *img;
    @try {
        img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    } @catch (NSException *exception) {
        img = Nil;
    }
    if(img)
        _barcodeImage.image = img;
    
    [_uniqueId setText:[[_dic objectForKey:@"uniqueid"] stringValue]];
    
    NSString *cash = [_dic objectForKey:@"str1"];
    NSString *needle = [cash componentsSeparatedByString:@": "][1];
    needle = [needle componentsSeparatedByString:@". "][0];
    [_cashLabel setText:needle];
    
    NSString *storeDic = [_dic objectForKey:@"str3"];
    storeDic = [storeDic componentsSeparatedByString:@": "][1];
    NSString *storeName = [storeDic componentsSeparatedByString:@" Location "][0];
    NSString *storeAddress = [storeDic componentsSeparatedByString:@" Location "][1];
    
    [_storeLabel setText:storeName];
    [_storeLocation setText:storeAddress];
    if ([[AppShare.checkPart getCarier] isEqualToString:@"N/A"]) {
        [_mobileType setText:@"Carrier Pending"];
    }
    else {
        [_mobileType setText:[AppShare.checkPart getCarier]];
    }
    
    NSString *location = storeAddress;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = _mapView.region;
                         region.center = [(CLCircularRegion *)placemark.region center];
                         region.span.longitudeDelta /= 8.0;
                         region.span.latitudeDelta /= 8.0;
                         
                         [_mapView setRegion:region animated:YES];
                         [_mapView addAnnotation:placemark];
                     }
                 }
     ];
    
}
- (IBAction)showTestLists:(id)sender {
    TestListViewController* testController = [self.storyboard instantiateViewControllerWithIdentifier:@"TestListViewController"];
    [self presentViewController:testController animated:YES completion:nil];
}
- (IBAction)restartButtonTapped:(id)sender {
    AppShare.dismissable = YES;
    AppShare.canCheck = 1;
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [aScrollView setContentOffset: CGPointMake(aScrollView.contentOffset.x, 0)];
    currentPage = (_scrollView.contentOffset.x + CGRectGetWidth(_scrollView.frame) / 2) / CGRectGetWidth(_scrollView.frame);
    [_pageBar1 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
    [_pageBar2 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
    [_pageBar3 setBackgroundColor:[UIColor colorWithRed:229 green:244 blue:236 alpha:1]];
    switch (currentPage) {
        case 0:
            [_pageBar1 setBackgroundColor:[UIColor colorWithRed:29 green:179 blue:99 alpha:1]];
            break;
        case 1:
            [_pageBar2 setBackgroundColor:[UIColor colorWithRed:29 green:179 blue:99 alpha:1]];
            break;
        case 2:
            [_pageBar3 setBackgroundColor:[UIColor colorWithRed:29 green:179 blue:99 alpha:1]];
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openMapButtonTapped:(id)sender {
    NSString *mapURLStr = [NSString stringWithFormat: @"http://maps.apple.com/?q=%@",_storeLocation.text];
    
    mapURLStr = [mapURLStr stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSURL *url = [NSURL URLWithString:[mapURLStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
    
}
- (IBAction)saveButtonTapped:(id)sender {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
