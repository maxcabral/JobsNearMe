//
//  jmeFirstViewController.m
//  JobsNearMe
//
//  Created by Maxwell Cabral on 6/1/13.
//  Copyright (c) 2013 mCab. All rights reserved.
//

#import "jmeMapVC.h"
#import "jmeMapAnnotation.h"
#import "jmeJobDetailVC.h"
#import "jmeJobVC.h"

#import <QuartzCore/QuartzCore.h>

@interface jmeMapVC ()
{
    CLLocationManager *locationManager;
    CLLocation *currentPosition;
    IBOutlet UIButton *geoLocateButton;
    
    IBOutlet UIView *detailView;
    IBOutlet UILabel *jobDetailNameLabel;
    IBOutlet UILabel *jobDetailAddressLabel;
    IBOutlet UITextView *jobDetailDescription;
    IBOutlet UIButton *jobDetailLinkButton;
    
    IBOutlet UIToolbar *keyboardToolbar;
    
}
@property IBOutlet MKMapView *mapView;
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
    
    detailView.layer.cornerRadius = 10.0;
    
    UIColor *color = [UIColor whiteColor];
    
    for (UIView *view in (detailView.subviews)) {
        if ([view isKindOfClass:[UILabel class]]){
            view.layer.shadowColor = [color CGColor];
            view.layer.shadowRadius = 4.0f;
            view.layer.shadowOpacity = .9;
            view.layer.shadowOffset = CGSizeZero;
            view.layer.masksToBounds = NO;
        } else if ([view isKindOfClass:[UIButton class]]) {
            UIButton *bView = (UIButton*)view;
            bView.titleLabel.layer.shadowColor = [color CGColor];
            bView.titleLabel.layer.shadowRadius = 4.0f;
            bView.titleLabel.layer.shadowOpacity = .9;
            bView.titleLabel.layer.shadowOffset = CGSizeZero;
            bView.titleLabel.layer.masksToBounds = NO;
        }
    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.0];
    
    // Modify any animatable properties
    geoLocateButton.transform = CGAffineTransformMakeRotation( 290 * M_PI / 180 );
    geoLocateButton.layer.shadowColor = [[UIColor whiteColor] CGColor];
    geoLocateButton.layer.shadowRadius = 2.0f;
    geoLocateButton.layer.shadowOpacity = .9;
    geoLocateButton.layer.shadowOffset = CGSizeZero;
    geoLocateButton.layer.masksToBounds = NO;
    
    [UIView commitAnimations];
    
    // Add a long press gesture recognizer to the map for
    // adding new pins to the map
    /*
    UITapGestureRecognizer *touchToHide = [[UITapGestureRecognizer alloc] initWithTarget:self
                                           action:@selector(hideKeyboard)];
    
    for (uint cnt = 0; cnt < self.mapView.gestureRecognizers.count; cnt++){
        if (cnt != self.mapView.gestureRecognizers.count - 4){
            [touchToHide requireGestureRecognizerToFail:[self.mapView.gestureRecognizers objectAtIndex:cnt]];
        }
    }
   
    [self.mapView addGestureRecognizer:touchToHide];*/
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    currentPosition = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentJob"]){
        jmeJobVC *vc = segue.destinationViewController;
        vc.url = @"http://jobs.ziprecruiter.com";
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    CGRect frame = keyboardToolbar.frame;
    float s = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].origin.y - frame.size.height - 40;
    float b = self.view.frame.size.height - 260.0;
    frame.origin.y = s;
    keyboardToolbar.frame = frame;
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    frame = keyboardToolbar.frame;
    s = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y - frame.size.height - 20;
    b = self.view.frame.size.height - 260.0;
    frame.origin.y = s;
    keyboardToolbar.frame = frame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height;
    keyboardToolbar.frame = frame;
    
    [UIView commitAnimations];
}

- (IBAction)hideKBSelected:(id)sender
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (IBAction)locateSelected:(id)sender
{
    // Check if the user has enabled location services.
    if ([CLLocationManager locationServicesEnabled]) {
        [locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [locationManager stopUpdatingLocation];

    [self moveViewToLocation:newLocation];
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
    
    
    jmeMapAnnotation *annotation = [[jmeMapAnnotation alloc]
    initWithCoordinate:newLocation.coordinate];
    annotation.title = @"Me";
    annotation.subtitle = @"My Address";

    [self.mapView addAnnotation:annotation];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(jmeMapAnnotation *) annotation {
    
   // if(annotation.coordinate == self.mapView.userLocation.coordinate) return nil;
    
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier1";
    
    /*
    jmeMapAnnotationView* customPinView = [[jmeMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    customPinView.pinColor = MKPinAnnotationColorRed;
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
    */
    
    MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                           initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    customPinView.pinColor = MKPinAnnotationColorRed;
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self
                    action:@selector(showJobDetails:)
          forControlEvents:UIControlEventTouchUpInside];
    customPinView.rightCalloutAccessoryView = rightButton;
    
    //UIImageView *memorialIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"googlemaps_pin.png"]];
    //customPinView.leftCalloutAccessoryView = memorialIcon;
    
    return customPinView;
}

- (IBAction)showJobDetails:(id)sender {
    detailView.hidden = NO;
}

- (IBAction)hideJobDetails:(id)sender {
    detailView.hidden = YES;
}

@end
