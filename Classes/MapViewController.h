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


@interface MapViewController : UIViewController <MKMapViewDelegate, MKReverseGeocoderDelegate, CLLocationManagerDelegate, UISearchBarDelegate>
{
	IBOutlet MKMapView *map;
	IBOutlet UISegmentedControl *seg;
	IBOutlet UISearchBar *sbLocation;
    
	CLLocationManager *locManager;
}

-(IBAction)changeMapType;
-(IBAction)gotoMyPlace;
-(IBAction)showHideSearchBar;

-(void)addAllAnnotations;
-(void)checkNetworkStatus;

@end
