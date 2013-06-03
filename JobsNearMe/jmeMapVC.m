//
//  jmeFirstViewController.m
//  JobsNearMe
//
//  Created by Maxwell Cabral on 6/1/13.
//  Copyright (c) 2013 mCab. All rights reserved.
//
#include <stdlib.h>

#import "jmeMapVC.h"
#import "jmeMapAnnotation.h"
#import "jmeHeatAnnotation.h"
#import "jmeJobDetailVC.h"
#import "jmeJobVC.h"
#import "jmeHeatAnnotationView.h"
#import "jmeBaseAnnotation.h"

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
    
    IBOutlet UINavigationBar *navBar;
    
}
@property (strong) NSOperationQueue *queue;
@property IBOutlet MKMapView *mapView;
@property (strong) NSString* lastResponse;
@property (strong) NSString* jobLink;
@end


@interface jmeMapVC (IO)
- (void)sendAsyncRequest:(NSMutableURLRequest*)request withSuccessSelector:(SEL)successSelector andFailureSelector:(SEL)failureSelector;
@end

@implementation jmeMapVC
@synthesize mapView, lastResponse;
@synthesize queue;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    queue = [[NSOperationQueue alloc] init];
    
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
    
    // someplace where you create the UINavigationController
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"header"];
        [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //NSArray *heatPoints = [NSArray arrayWithObjects:@"6666 Yucca St Hollywood CA 90028",@"Los Angeles, CA",@"1600 E 4th St. Los Angeles, 90033", nil];
    //[self addHeatMap:heatPoints];
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
        vc.url = self.jobLink;
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
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self performJobSearch:searchBar.text];
    [self hideKeyboard];
}

- (void)performJobSearch:(NSString*)search
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",@"http://172.22.52.202:3030/jobs/job_list?content-type=application/json&description=",search,@"&state=CA&city=Angeles"]];
    
    //AsynchronousRequest to grab the data
    //NSData *ReqData = [NSData dataWithBytes: [ReqString UTF8String] length: [ReqString length]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    //[request setHTTPBody:ReqData];
    
    [self sendAsyncRequest:request withSuccessSelector:@selector(addSearchPoints:) andFailureSelector:@selector(searchFailed:)];
}

- (void)addSearchPoints:(NSDictionary*)response
{
    NSArray *jobLocations = [response objectForKey:@"message"];
    for (NSDictionary *job in jobLocations) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        NSString *loc = [NSString stringWithFormat:@"%@ %@ %@",[job objectForKey:@"city"],[job objectForKey:@"state"],[job objectForKey:@"country"],nil];
        [geocoder geocodeAddressString:loc completionHandler:^(NSArray* placemarks, NSError* error){
            NSDictionary *workingJob = job;
            for (CLPlacemark* aPlacemark in placemarks)
            {
                if (workingJob != nil){
                    float diff = arc4random() % 10000 / 100000.0;
                    float diff2 = arc4random() % 10000 / 100000.0;
                    
                    CLLocationCoordinate2D coord;
                    int spread = arc4random() % 4;
                    
                    if (0 == spread){
                        coord = CLLocationCoordinate2DMake(aPlacemark.location.coordinate.latitude - diff, aPlacemark.location.coordinate.longitude - diff2);
                    } else if (1 == spread) {
                        coord = CLLocationCoordinate2DMake(aPlacemark.location.coordinate.latitude - diff, aPlacemark.location.coordinate.longitude + diff2);
                    } else if (2 == spread) {
                        coord = CLLocationCoordinate2DMake(aPlacemark.location.coordinate.latitude + diff, aPlacemark.location.coordinate.longitude - diff2);
                    } else {
                        coord = CLLocationCoordinate2DMake(aPlacemark.location.coordinate.latitude + diff, aPlacemark.location.coordinate.longitude + diff2);
                    }
                    
                    jmeMapAnnotation *annotation = [[jmeMapAnnotation alloc] initWithCoordinate:coord];
                    annotation.title = [job objectForKey:@"title"];
                    annotation.subtitle = loc;
                    annotation.details = job;
                    
                    [self.mapView addAnnotation:(NSObject<MKAnnotation>*)annotation];
                    workingJob = nil;
                }
            }
        }];
    }
}

- (void)searchFailed:(NSDictionary*)response
{
    NSLog(@"%@",@"Search Failure");
}

- (IBAction)loadHeatMapTUI:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://172.22.52.202:3030/jobs/job_location?content-type=application/json&state=CA"];
    
    //AsynchronousRequest to grab the data
    //NSData *ReqData = [NSData dataWithBytes: [ReqString UTF8String] length: [ReqString length]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    //[request setHTTPBody:ReqData];
    
    [self sendAsyncRequest:request withSuccessSelector:@selector(addHeatMap:) andFailureSelector:@selector(heatMapFailed:)];
}

- (void)addHeatMap:(NSDictionary*)response
{
    NSArray *heatLocations = [[response objectForKey:@"message"] objectForKey:@"location"];
    for (NSString *loc in heatLocations) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:loc completionHandler:^(NSArray* placemarks, NSError* error){
            for (CLPlacemark* aPlacemark in placemarks)
            {
                float diff = arc4random() % 10000 / 100000.0;
                float diff2 = arc4random() % 10000 / 100000.0;
                
                CLLocationCoordinate2D coord;
                int spread = arc4random() % 4;
                
                if (0 == spread){
                    coord = CLLocationCoordinate2DMake(aPlacemark.location.coordinate.latitude - diff, aPlacemark.location.coordinate.longitude - diff2);
                } else if (1 == spread) {
                    coord = CLLocationCoordinate2DMake(aPlacemark.location.coordinate.latitude - diff, aPlacemark.location.coordinate.longitude + diff2);
                } else if (2 == spread) {
                    coord = CLLocationCoordinate2DMake(aPlacemark.location.coordinate.latitude + diff, aPlacemark.location.coordinate.longitude - diff2);
                } else {
                    coord = CLLocationCoordinate2DMake(aPlacemark.location.coordinate.latitude + diff, aPlacemark.location.coordinate.longitude + diff2);
                }
                
                jmeMapAnnotation *hAnn = [[jmeMapAnnotation alloc] initWithCoordinate:coord];
                [hAnn setRedColor];
                [self.mapView addAnnotation:(NSObject<MKAnnotation>*)hAnn];
            }
        }];
   }
}

- (void)heatMapFailed:(NSDictionary*)response
{
    NSLog(@"%@",@"Heat Failure");
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(jmeMapAnnotation*) annotation {
   // if(annotation.coordinate == self.mapView.userLocation.coordinate) return nil;
    
    if ([annotation.details count] > 0){
    
        NSString* AnnotationIdentifier = @"calloutAnnotation";
        
        MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        customPinView.pinColor = MKPinAnnotationColorRed;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self
                        action:@selector(showJobDetails:)
              forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
        
        NSDictionary *job = ((jmeMapAnnotation*)annotation).details;
        NSString *loc = [NSString stringWithFormat:@"%@ %@ %@",[job objectForKey:@"city"],[job objectForKey:@"state"],[job objectForKey:@"country"],nil];
        jobDetailNameLabel.text = [job objectForKey:@"name"];
        jobDetailAddressLabel.text = loc;
        jobDetailDescription.text = [job objectForKey:@"description"];
        self.jobLink = [job objectForKey:@"url"];
        
        //UIImageView *memorialIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"googlemaps_pin.png"]];
        //customPinView.leftCalloutAccessoryView = memorialIcon;
        
        return customPinView;
    } else if ([annotation.details count] == 0) {
        
        MKPinAnnotationView* customPinView = (MKPinAnnotationView*)[[jmeHeatAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"heatmapAnnotation"];
        return customPinView;
    } else {
        return nil;
    }
    
}

- (IBAction)showJobDetails:(id)sender {
    detailView.hidden = NO;
}

- (IBAction)hideJobDetails:(id)sender {
    detailView.hidden = YES;
}

@end

@implementation jmeMapVC (IO)

- (void)sendAsyncRequest:(NSMutableURLRequest*)request withSuccessSelector:(SEL)successSelector andFailureSelector:(SEL)failureSelector
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         if ([data length] > 0 && error == nil){
             lastResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSDictionary *JSONResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:nil];
             if (JSONResponse)
             {
                 NSString *success = [JSONResponse objectForKey:@"error"];
                 if ([success isEqualToString:@"0"])
                 {
                     //Call on main thread in case we're trying to use a GUI element in the callback.
                     [self performSelectorOnMainThread:successSelector
                                                withObject:JSONResponse
                                             waitUntilDone:NO];
                     return;
                 } else {
                     [self performSelectorOnMainThread:failureSelector
                                                withObject:JSONResponse
                                             waitUntilDone:NO];
                     return;
                 }
             } else {
                 lastResponse = @"bad response";
             }
         }
         else if ([data length] == 0 && error == nil)
         {
             //empty data
             lastResponse = @"no data";
         }
         //used this NSURLErrorTimedOut from foundation error responses
         else if (error != nil && error.code == NSURLErrorTimedOut)
         {
             //timeout
             lastResponse = @"timeout";
         }
         else if (error != nil)
         {
             //generic error
             lastResponse = @"generic error";
         }
         //If its a comm error, call the callback without a message.  The callback will check sender.lastResponse
         //Call on main thread to prevent lockups and prevent a slow context switch.
         [self performSelectorOnMainThread:failureSelector
                                    withObject:nil
                                 waitUntilDone:NO];
         return;
     }];
}
@end