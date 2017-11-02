//
//  ValueScrollViewController.h
//  MassTrade
//
//  Created by Admin on 9/28/17.
//  Copyright © 2017 GDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CheckPart.h"

@interface ValueScrollViewController : UIViewController
@property (unsafe_unretained, nonatomic) IBOutlet UIView *pageBar1;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *pageBar2;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *pageBar3;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mobileModel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *cashLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet MKMapView *mapView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *storeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *storeLocation;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *barcodeImage;
@property (retain, nonatomic) IBOutlet UILabel *uniqueId;
@property (retain, nonatomic) IBOutlet UILabel *mobileType;

@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, assign) int currentPage;
@end
