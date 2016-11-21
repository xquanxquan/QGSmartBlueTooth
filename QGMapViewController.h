//
//  ViewController.h
//  MapViewV3
//
//  Created by 12345 on 25/9/16.
//  Copyright © 2016年 12345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface QGMapViewController : UIViewController  <MKMapViewDelegate, CLLocationManagerDelegate,MKOverlay>

- (IBAction)back:(id)sender;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentSpeedLabel;

@property (weak, nonatomic) IBOutlet UILabel *sumDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgSpeedLabel;

@property (weak, nonatomic) IBOutlet UILabel *sumTimeLabel;


@end

