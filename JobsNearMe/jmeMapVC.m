//
//  jmeFirstViewController.m
//  JobsNearMe
//
//  Created by Maxwell Cabral on 6/1/13.
//  Copyright (c) 2013 mCab. All rights reserved.
//

#import "jmeMapVC.h"

@interface jmeMapVC ()
{
    CLLocationManager *locationManager;
    CLLocation *currentPosition;
}
@property IBOutlet MKMapView *mapView;
@end

@interface jmeMapVC (MapViewDelegate)
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;
@end

@implementation jmeMapVC
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Check if the user has enabled location services.
    // Create a location manager.
    locationManager = [[CLLocationManager alloc] init];
    // Set ourselves as it's delegate so that we get
    // notified of position updates.
    locationManager.delegate = self;
    // Set the desired accuracy.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)viewDidDisappear:(BOOL)animated
{
    currentPosition = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)locateSelected:(id)sender
{
    // Check if the user has enabled location services.
    if ([CLLocationManager locationServicesEnabled]) {
        [locationManager startUpdatingLocation];
    }
}

@end

@implementation jmeMapVC (MapViewDelegate)

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [locationManager stopUpdatingLocation];

    [self moveViewToLocation:newLocation];
    /*
        HUWMapAnnotation *annotation =
        [[HUWMapAnnotation alloc]
         initWithCoordinate:newLocation.coordinate];
        annotation.name = @"Hugo Wetterberg";
        annotation.email = @"hugo@wetterberg.nu";
        annotation.age = 30;
        [self.mapView addAnnotation:annotation];*/
}

- (void)moveViewToLocation:(CLLocation*)newLocation
{
    // Create a map point from the coordinate.
    MKMapPoint point = MKMapPointForCoordinate(newLocation.coordinate);
    // Get the relationship between map points
    // and metres at our current latitude.
    double pointsPerMeter = MKMapPointsPerMeterAtLatitude(newLocation.coordinate.latitude);
    // Calculate the number of map points that
    // equals a distance of 500m.
    double visibleDistance = pointsPerMeter * 500.0;
    
    // Create a rectangle that is a kilometer at
    // the sides and is centered on our position.
    MKMapRect rect = MKMapRectMake(
                                   point.x - visibleDistance,
                                   point.y - visibleDistance,
                                   visibleDistance * 2,
                                   visibleDistance * 2);
    
    // Tell the map view to show the rectangle.
    [self.mapView setVisibleMapRect:rect animated:YES];
}

@end
