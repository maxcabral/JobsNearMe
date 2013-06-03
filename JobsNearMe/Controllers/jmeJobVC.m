//
//  jmeJobVC.m
//  JobsNearMe
//
//  Created by Maxwell Cabral on 6/1/13.
//  Copyright (c) 2013 mCab. All rights reserved.
//

#import "jmeJobVC.h"

@interface jmeJobVC ()
{
    IBOutlet UIWebView *jobView;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *forwardButton;
    IBOutlet UIBarButtonItem *reloadButton;
    Boolean hasBeenShown;
    
    IBOutlet UINavigationBar *navBar;
}

@end

@implementation jmeJobVC
@synthesize url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hasBeenShown = false;
    // Do any additional setup after loading the view.
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"header"];
        [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!hasBeenShown){
        [jobView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:self.url]]];
        backButton.enabled = NO;
        forwardButton.enabled = NO;
        reloadButton.enabled = NO;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**********
 WebViewDelegate Methods
 *********/
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    hasBeenShown = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (jobView.canGoBack){
        backButton.enabled = YES;
    } else {
        backButton.enabled = NO;
    }
    
    if (jobView.canGoForward){
        forwardButton.enabled = YES;
    } else {
        forwardButton.enabled = NO;
    }
    reloadButton.enabled = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (jobView.canGoBack){
        backButton.enabled = YES;
    } else {
        backButton.enabled = NO;
    }
    
    if (jobView.canGoForward){
        forwardButton.enabled = YES;
    } else {
        forwardButton.enabled = NO;
    }
    reloadButton.enabled = YES;
}

/*********
 View Event Handler Code
 *********/
- (IBAction)barButtonClicked:(UIBarButtonItem *)button
{
    if ([button isEqual:backButton]){
        [jobView goBack];
    } else if ([button isEqual:forwardButton]) {
        [jobView goForward];
    } else if ([button isEqual:reloadButton]) {
        [jobView reload];
        reloadButton.enabled = NO;
    }
}

- (IBAction)doneButtonTUI:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
