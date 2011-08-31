//
//  NewPevViewController.h
//  ReciclaSP
//
//  Created by Luiz Aguiar on 8/31/11.
//  Copyright 2011 Betterbrains Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface NewPevViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    
    IBOutlet UIButton *button;
}

-(IBAction)newPEV;

@end
