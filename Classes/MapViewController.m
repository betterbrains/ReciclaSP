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
    [self checkNetworkStatus];
    
    NSString *mapsURL = @"http://maps.googleapis.com/maps/api/geocode/json?address=";
    
    NSString *address = searchBar.text;
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    mapsURL = [mapsURL stringByAppendingString:address];
    mapsURL = [mapsURL stringByAppendingString:@"&sensor=true"];
    
    JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionUnicodeNewlines];
    
    NSURL *url = [[NSURL alloc] initWithString:mapsURL];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    id jsonResponse = [decoder objectWithData:data];
    
    // releases
    [url release];
    [data release];
    
    NSString *status = [jsonResponse objectForKey:@"status"];
    id results = [jsonResponse objectForKey:@"results"];
    
    // verify the status of query
    if ([status isEqualToString:@"OK"]) {
        
        if ([results isKindOfClass:[NSArray class]]) {
            
            if ([results count] < 3) {
                
                NSDictionary *locationDic = [[[results objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"];
                NSNumber *latitude = [locationDic objectForKey:@"lat"];
                NSNumber *longitude = [locationDic objectForKey:@"lng"];

                // define the new region and zoom
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
                MKCoordinateSpan span = MKCoordinateSpanMake(0.008, 0.008);
                
                [map setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];

            } else {
                UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"Muitos resultados" 
                                                                 message:@"Especifique melhor o endereço usando: nome da rua, número, cidade." 
                                                                delegate:nil 
                                                       cancelButtonTitle:@"OK" 
                                                       otherButtonTitles:nil ];
                
                [alert show];
                [alert release];

            }
            
        }

    } 
    else if ([status isEqualToString:@"ZERO_RESULTS"]) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"Não encontrado" 
                                                         message:@"Especifique melhor o endereço usando: nome da rua, número, cidade." 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil ];
        
        [alert show];
        [alert release];
    }
    else if ([status isEqualToString:@"OVER_QUERY_LIMIT"]) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"Problema na conexão" 
                                                         message:@"Houve um problema com o serviço de mapas, tente novamente por favor." 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil ];
        
        [alert show];
        [alert release];
        
    }
    
    
    
    // hide keyboard
    [sbLocation resignFirstResponder];
    
    // hide the searchBar
    [self showHideSearchBar];
    
    [decoder release];
    jsonResponse = nil;
    
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
