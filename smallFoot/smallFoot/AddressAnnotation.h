//
//  AddressAnnotation.h
//  smallFoot
//
//  Created by Ben Perkins on 4/8/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface AddressAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;

}

- (NSString *)subtitle;
- (NSString *)title;
-(id)initWithCoordinate:(CLLocationCoordinate2D) c;
    
@end

