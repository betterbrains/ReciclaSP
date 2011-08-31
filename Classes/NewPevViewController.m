//
//  NewPevViewController.m
//  ReciclaSP
//
//  Created by Luiz Aguiar on 8/31/11.
//  Copyright 2011 Betterbrains Studio. All rights reserved.
//

#import "NewPevViewController.h"


@implementation NewPevViewController


-(IBAction)newPEV 
{
    if ([MFMailComposeViewController canSendMail]) {
        button.enabled = TRUE;
        
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setToRecipients:[NSArray arrayWithObject:@"reciclasp@betterbrains.com.br"]];
        [mailController setSubject:@"Sugestão de novo PEV"];
        [mailController setMessageBody:@"" isHTML:NO];
        [self presentModalViewController:mailController animated:YES];
        [mailController release]; 
    }
    else 
    {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"Erro" 
                                                         message:@"Seu device não esta configurado para enviar Email." 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil ];
        
        [alert show];
        [alert release];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
