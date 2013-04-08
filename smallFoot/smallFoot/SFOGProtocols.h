//
//  SFOGProtocols.h
//  smallFoot
//
//  Created by w on 4/8/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol SFOGFootprint<FBGraphObject>

@property (retain, nonatomic) NSString *id;
@property (retain, nonatomic) NSString *url;

@end

@protocol SFOGRecordFootprintAction<FBOpenGraphAction>

@property (retain, nonatomic) id<SFOGFootprint> carbon_footprint;

@end
