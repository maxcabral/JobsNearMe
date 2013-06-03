//
//  jmeMapAnnotation.h
//  JobsNearMe
//
//  Created by Maxwell Cabral on 6/1/13.
//  Copyright (c) 2013 mCab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "jmeBaseAnnotation.h"

@interface jmeMapAnnotation : jmeBaseAnnotation<MKAnnotation>

@property (strong) NSString *title;
@property (strong) NSString *subtitle;
@property (strong) NSDictionary *details;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (strong) UIColor *heatColor;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
-(void)setRedColor;
-(void)setOrangeColor;
-(void)setYellowColor;
-(void)setGreenColor;
-(void)setBlueColor;
-(void)setLightBlueColor;
@end
