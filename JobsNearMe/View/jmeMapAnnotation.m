//
//  jmeMapAnnotation.m
//  JobsNearMe
//
//  Created by Maxwell Cabral on 6/1/13.
//  Copyright (c) 2013 mCab. All rights reserved.
//

#import "jmeMapAnnotation.h"

@implementation jmeMapAnnotation
@synthesize name, address, details;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self){
        self.coordinate = coordinate;
    }
    return self;
}

-(NSString*)title
{
    return name;
}

-(NSString*)subtitle
{
    return address;
}

@end
