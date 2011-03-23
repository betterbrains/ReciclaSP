//
//  ReciclaSPViewController.m
//  ReciclaSP
//
//  Created by Luiz Aguiar on 2/25/11.
//  Copyright 2011 Betterbrains Studio. All rights reserved.
//

#import "ReciclaSPViewController.h"
#import "AboutViewController.h"

@implementation ReciclaSPViewController

-(IBAction)showAbout {
	
	AboutViewController *about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
	
	about.modalTransitionStyle = UIModalTransitionStylePartialCurl;
	
	[self presentModalViewController:about animated:TRUE];
	
	[about release];
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
