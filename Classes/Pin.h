//
//  Pin.h
//  ReciclaSP
//
//  Created by Luiz Aguiar on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface Pin : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
}

@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *subtitle;


@end
