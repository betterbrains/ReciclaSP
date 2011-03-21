//
//  MapViewController.m
//  ReciclaSP
//
//  Created by Luiz Aguiar on 2/23/11.
//  Copyright 2011 Betterbrains Studio. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController


-(IBAction)changeMapType
{
	map.mapType = seg.selectedSegmentIndex;
}


-(IBAction)gotoMyPlace
{
	locManager = [[CLLocationManager alloc] init];
	locManager.delegate = self;
	
	[locManager startUpdatingLocation];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if (![annotation isKindOfClass:[Pin class]]) {
		return nil;
	}
	
	// try to dequeue an existing pin view first
	static NSString* PinAnnotationID = @"pinAnnotationID";
	//MKPinAnnotationView* pinView = (MKPinAnnotationView *)
	[mapView dequeueReusableAnnotationViewWithIdentifier:PinAnnotationID];

	// if an existing pin view was not available, create one
	MKPinAnnotationView* pinView = [[[MKPinAnnotationView alloc]
									 initWithAnnotation:(Pin*)annotation reuseIdentifier:PinAnnotationID] autorelease];
	
	if (!pinView) {
		return nil;
	}

	pinView.pinColor = MKPinAnnotationColorGreen;
	pinView.animatesDrop = YES;
	pinView.canShowCallout = YES;
	
	return pinView;
	
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    
    
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error { 
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erro!"
														message:@"Não foi possível obter sua localização"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
	
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	map.showsUserLocation = TRUE;
	
	MKCoordinateSpan span = MKCoordinateSpanMake(0.015, 0.015);
	
	[map setRegion:MKCoordinateRegionMake(newLocation.coordinate, span) animated:TRUE];
	
	[locManager stopUpdatingLocation];
	
	locManager = nil;
	
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	// delegate required
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(-23.550533, -46.633422); // praca da se
	MKCoordinateSpan span = MKCoordinateSpanMake(0.220, 0.220);
	
    [self addAllAnnotations];
    
	[map setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
    
}

- (void)addAllAnnotations {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Pev" ofType:@"plist"];
    NSArray *places = [[NSArray alloc] initWithContentsOfFile:path];
  
    // load and add the pins
    for (NSDictionary *place in places) {
        
        Pin *pin = [[Pin alloc] init];

        double latitude = [[place objectForKey:@"lat"] doubleValue];
        double longitude = [[place objectForKey:@"lng"] doubleValue];
        
        pin.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        pin.title = [place objectForKey:@"name"];
        pin.subtitle = [place objectForKey:@"location"];
        
        [map addAnnotation:pin];
        
        [pin release];

    }
    
    [places release];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
    map = nil;
}


- (void)dealloc {
	[map release];
	
    [super dealloc];
}


@end
