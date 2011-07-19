//
//  MapViewController.m
//  ReciclaSP
//
//  Created by Luiz Aguiar on 2/23/11.
//  Copyright 2011 Betterbrains Studio. All rights reserved.
//

#import "MapViewController.h"
#import "Reachability.h"
#import "JSONKit.h"


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

- (IBAction)showHideSearchBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3]; 
    
    //bool o = [UIDevice currentDevice].orientation ==UIInterfaceOrientationPortrait;
    
    if (sbLocation.center.y > 0) {
        // the searchBar is inside the screen, so lets hide
        sbLocation.center = CGPointMake(sbLocation.center.x, -23);
        
        // retract the map
        map.frame = CGRectMake(0, 0, 320, 416);
    } else {
        // the searchBar is outside the screen, so lets show
        sbLocation.center = CGPointMake(sbLocation.center.x, 21);

        // stretch the map
        map.frame = CGRectMake(0, 44, 320, 370);
    }
    
    [UIView commitAnimations];

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *mapsURL = @"http://maps.googleapis.com/maps/api/geocode/json?address=";
    
    NSString *address = searchBar.text;
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    mapsURL = [mapsURL stringByAppendingString:address];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:mapsURL]];
    
    JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    NSArray *items = [decoder objectWithData:data];
    
    NSLog(@"Numbers os items: %d", [items count]);
    
    // hide keyboard
    [sbLocation resignFirstResponder];
    
    // hide the searchBar
    [self showHideSearchBar];
    
    [mapsURL release];
    [address release];
    [decoder release];
    [data release];
    [items release];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [self showHideSearchBar];    

    // hide keyboard
    [sbLocation resignFirstResponder];
    
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
    
    [self checkNetworkStatus];
	
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
    for (NSDictionary *pev in places) {
        
        Pin *pin = [[Pin alloc] init];

        double latitude = [[pev objectForKey:@"lat"] doubleValue];
        double longitude = [[pev objectForKey:@"lng"] doubleValue];
        
        pin.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        pin.title = [pev objectForKey:@"name"];
        pin.subtitle = [pev objectForKey:@"location"];
        
        [map addAnnotation:pin];
        
        [pin release];

    }
    
    [places release];
    
    [self checkNetworkStatus];
    
}


- (void)checkNetworkStatus {

    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    if (internetStatus == NotReachable) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"Falha de conexão" 
                                                         message:@"Não foi possível conectar à internet." 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil ];
        
        [alert show];
        
        [alert release];
    }
    
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
