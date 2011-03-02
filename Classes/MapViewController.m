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
	
	pin = [[Pin alloc] init];
		
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
	
	
	//MKAnnotationView *pinView = [[MKAnnotationView alloc] initWithAnnotation:(Pin*)annotation reuseIdentifier:nil];
	//pinView.image = [UIImage imageNamed:@"rec.png"];
	//pinView.canShowCallout = YES; // ballon
	
	return pinView;
	
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
//	cidade.text = (placemark.locality) ? placemark.locality:@"nao sei";
//	
//	estado.text = (placemark.administrativeArea) ? placemark.administrativeArea:@"nao sei";
	
	pin.title = placemark.thoroughfare;
	pin.subtitle = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.country];
	pin.coordinate = placemark.coordinate;
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
	
//	pin.coordinate = newLocation.coordinate;
	
//	[map addAnnotation:pin];
	
//	MKReverseGeocoder *geo = [[MKReverseGeocoder alloc] initWithCoordinate:map.centerCoordinate];
	
//	geo.delegate = self;
	
//	[geo start]; // call didFindPlacemark
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	// delegate required
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(-23.550533, -46.633422); // praca da se
	
	MKCoordinateSpan span = MKCoordinateSpanMake(0.180, 0.180);
	
//	mapAnnotations = [[NSMutableArray alloc] init];
	
	pin = [[Pin	alloc] init];
	
	pin.coordinate = coordinate;
	
//	[mapAnnotations insertObject:pin atIndex:[mapAnnotations count]];
	
	[map addAnnotation:pin];
	
	[map setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
    map = nil;
	pin = nil;
}


- (void)dealloc {
	[map release];
	[pin release];
	
    [super dealloc];
}


@end
