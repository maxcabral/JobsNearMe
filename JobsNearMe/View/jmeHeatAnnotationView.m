//
//  jmeHeatAnnotationView.m
//  JobsNearMe
//
//  Created by Maxwell Cabral on 6/2/13.
//  Copyright (c) 2013 mCab. All rights reserved.
//

#import "jmeHeatAnnotationView.h"
#import "jmeHeatAnnotation.h"

#import <UIKit/UIKit.h>

@implementation jmeHeatAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id )annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self){
        self.frame = CGRectMake(0, 0, 20.0, 20.0);
        self.backgroundColor = ((jmeHeatAnnotation*)annotation).heatColor;
    }
    return self;
}

- (id)initWithAnnotation:(id )annotation reuseIdentifier:(NSString *)reuseIdentifier andSideLength:(CGFloat)length
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self){
        self.frame = CGRectMake(0, 0, length, length);
        self.backgroundColor = ((jmeHeatAnnotation*)annotation).heatColor;
    }
    return self;
}

@end
