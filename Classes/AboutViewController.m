//
//  AboutViewController.m
//  ReciclaSP
//
//  Created by Luiz Aguiar on 3/22/11.
//  Copyright 2011 Betterbrains Studio. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

-(IBAction)back {
	
	[self dismissModalViewControllerAnimated:TRUE];
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
