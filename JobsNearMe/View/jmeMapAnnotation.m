//
//  jmeMapAnnotation.m
//  JobsNearMe
//
//  Created by Maxwell Cabral on 6/1/13.
//  Copyright (c) 2013 mCab. All rights reserved.
//

#import "jmeMapAnnotation.h"
@interface jmeMapAnnotation(){
    
}
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@end

@implementation jmeMapAnnotation
@synthesize title, subtitle, details, coordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate
{
    self = [super init];
    if (self){
        self.coordinate = theCoordinate;
    }
    return self;
}

@end
