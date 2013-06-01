//
//  jmeMapAnnotation.h
//  JobsNearMe
//
//  Created by Maxwell Cabral on 6/1/13.
//  Copyright (c) 2013 mCab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface jmeMapAnnotation : NSObject<MKAnnotation>

@property (strong) NSString *name;
@property (strong) NSString *address;
@property (assign) NSArray *details;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
