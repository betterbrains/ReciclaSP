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

	pinView.pinColor = MKPinAnnotationColorRed;
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Places" ofType:@"plist"];
    NSArray *places = [[NSArray alloc] initWithContentsOfFile:path];
    mapAnnotations = [[NSMutableArray alloc] init];
    
    NSLog(@"-> %@",[places count]);

    for (NSDictionary *place in places) {
        Pin *pin = [[Pin alloc] init];

        double latitude = [[place valueForKey:@"lat"] doubleValue];
        double longitude = [[place objectForKey:@"lng"] doubleValue];
        
        pin.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        [mapAnnotations addObject:pin];
        
    }
    
    [map addAnnotations:mapAnnotations];
    
    [mapAnnotations release];
    
//	Pin *pin = [[Pin alloc] init];
//    
//	// default pin
//	pin.coordinate = CLLocationCoordinate2DMake(-23.550533, -46.633422);
//	pin.title = @"Pça da Sé";
//	
//	mapAnnotations = [[NSMutableArray alloc] init];
//	
//	// point1
//	Pin *pin1 = [[Pin alloc] init];
//	pin1.coordinate = CLLocationCoordinate2DMake(-23.675361, -46.678376);
//	pin1.title = @"Interlagos";
//	
//	// point2
//	Pin *pin2 = [[Pin alloc] init];
//	pin2.coordinate = CLLocationCoordinate2DMake(-23.553467, -46.709836);
//	pin2.title = @"Pça Panamericana";
//    
//	// point3
//	Pin *pin3 = [[Pin alloc] init];
//	pin3.coordinate = CLLocationCoordinate2DMake(-23.581432, -46.630097);
//	pin3.title = @"Vila Mariana";
//    
//	[mapAnnotations insertObject:pin atIndex:[mapAnnotations count]];
//	[mapAnnotations insertObject:pin1 atIndex:[mapAnnotations count]];
//	[mapAnnotations insertObject:pin2 atIndex:[mapAnnotations count]];
//	[mapAnnotations insertObject:pin3 atIndex:[mapAnnotations count]];
//	
//	// plota os pins no mapa
//	[map addAnnotations:mapAnnotations];
//
//    [pin release];
//    [pin1 release];
//    [pin2 release];
//    [pin3 release];

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
