//
//  MapViewController.h
//  ReciclaSP
//
//  Created by Luiz Aguiar on 2/23/11.
//  Copyright 2011 Betterbrains Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Pin.h"


@interface MapViewController : UIViewController <MKMapViewDelegate, MKReverseGeocoderDelegate, CLLocationManagerDelegate>
{
	IBOutlet MKMapView *map;
	IBOutlet UISegmentedControl *seg;
	
	CLLocationManager *locManager;
}

-(IBAction)changeMapType;
-(IBAction)gotoMyPlace;

-(void)addAllAnnotations;
-(void)checkNetworkStatus;

@end
