//
//  AddressAnnotation.m
//  smallFoot
//
//  Created by Ben Perkins on 4/8/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation
@synthesize coordinate;

- (NSString *)subtitle{
	return nil;
}

- (NSString *)title{
	return nil;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}

@end