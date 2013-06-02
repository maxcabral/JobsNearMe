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

@property (strong) NSString *title;
@property (strong) NSString *subtitle;
@property (strong) NSArray *details;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
