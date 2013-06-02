//
//  jmeHeadAnnotation.h
//  JobsNearMe
//
//  Created by Maxwell Cabral on 6/1/13.
//  Copyright (c) 2013 mCab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface jmeHeatAnnotation : NSObject<MKAnnotation>
@property (strong) NSString *title;
@property (strong) NSString *subtitle;
@property (strong) UIColor *heatColor;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
-(void)setRedColor;
-(void)setOrangeColor;
-(void)setYellowColor;
-(void)setGreenColor;
-(void)setBlueColor;
-(void)setLightBlueColor;
@end
