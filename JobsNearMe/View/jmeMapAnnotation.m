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
@synthesize title, subtitle, details, coordinate, heatColor;

-(id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate
{
    self = [super init];
    if (self){
        self.coordinate = theCoordinate;
    }
    return self;
}

-(void)setRedColor
{
    self.heatColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.650];
}

-(void)setOrangeColor
{
    self.heatColor = [UIColor colorWithRed:1.000 green:0.500 blue:0.000 alpha:0.650];
}

-(void)setYellowColor
{
    self.heatColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.000 alpha:0.650];
}

-(void)setGreenColor
{
    self.heatColor = [UIColor colorWithRed:0.002 green:0.873 blue:0.003 alpha:0.650];
}

-(void)setBlueColor
{
    self.heatColor = [UIColor colorWithRed:0.000 green:0.004 blue:0.728 alpha:0.650];
}

-(void)setLightBlueColor
{
    self.heatColor = [UIColor colorWithRed:0.054 green:0.832 blue:1.000 alpha:0.650];
}

@end
