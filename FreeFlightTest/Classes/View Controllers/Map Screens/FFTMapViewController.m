//
//  FFTMapViewController.m
//  FreeFlightTest
//
//  Created by Alexander Yalchik on 3/16/17.
//  Copyright © 2017 OMGHaveFun. All rights reserved.
//

#import "FFTMapViewController.h"

#import <MapKit/MapKit.h>

#import "FFTConstants.h"
#import "FFTHomeAnnotation.h"
#import "FFTMapOverlay.h"
#import "FFTMapOverlayRenderer.h"

@interface FFTMapViewController () <MKMapViewDelegate> {
    MKCircle *invertCircle;
    MKAnnotationView *homeAnnotationView;
    CLLocationCoordinate2D annotationCoordinate;
    float invertCircleRadius;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISlider *invertCircleRadiusSlider;

@end

@implementation FFTMapViewController

#pragma mark - Lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customize];
}

- (void)customize {
    
    [self showDefaultLocation];
    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    if(![defaults floatForKey:kLastHomeLatitudeKey]){
        [defaults setFloat:FFTDefaultHomePositionLatitude forKey:kLastHomeLatitudeKey];
    }
    if(![defaults floatForKey:kLastHomeLongitudeKey]){
        [defaults setFloat:FFTDefaultHomePositionLongitude forKey:kLastHomeLongitudeKey];
    }
    if(![defaults floatForKey:kLastHomeInvertCircleRadiusKey]){
        [defaults setFloat:FFTDefaultInvertCircleRadiusKey forKey:kLastHomeInvertCircleRadiusKey];
    }
    [defaults synchronize];
    
    annotationCoordinate.latitude = [defaults floatForKey:kLastHomeLatitudeKey];
    annotationCoordinate.longitude = [defaults floatForKey:kLastHomeLongitudeKey];
    
    invertCircleRadius = [defaults floatForKey:kLastHomeInvertCircleRadiusKey];
    self.invertCircleRadiusSlider.value = invertCircleRadius;
    
    FFTHomeAnnotation *homeAnnotation = [[FFTHomeAnnotation alloc] init];
    homeAnnotation.coordinate = annotationCoordinate;
    homeAnnotation.imageName = @"home_icon";
    
    // set annotation size
    homeAnnotation.annotationSize = 50.0;
    
    // direction icon init
    homeAnnotation.isDirectionEnabled = YES;
    homeAnnotation.directionAngle = 315.0;
    
    [self.mapView addAnnotation:homeAnnotation];
    
    [self addMapOverlay];
}

- (void)showDefaultLocation {
    
    MKCoordinateRegion defaultRegion;
    defaultRegion.center.latitude = FFTDefaultMapPositionLatitude;
    defaultRegion.center.longitude = FFTDefaultMapPositionLongitude;
    defaultRegion.span.latitudeDelta = FFTDefaultSpanDelta;
    defaultRegion.span.longitudeDelta = FFTDefaultSpanDelta;
    
    [self.mapView setRegion:defaultRegion animated:YES];
}

- (void)addMapOverlay {
    CLLocationDistance fenceDistance = invertCircleRadius;
    CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(annotationCoordinate.latitude, annotationCoordinate.longitude);
    invertCircle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:fenceDistance];
    [self.mapView addOverlay:invertCircle];
    
    FFTMapOverlay *overlay = [[FFTMapOverlay alloc] initWithCoordinate:annotationCoordinate];
    [self.mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];
}

#pragma mark - MKMapViewDelegate -

- (MKCircleRenderer *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[FFTMapOverlay class]]) {
        FFTMapOverlayRenderer *renderer = [[FFTMapOverlayRenderer alloc] initWithOverlay:overlay];
        renderer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        renderer.circleRect = invertCircle.boundingMapRect;
        
        return (MKCircleRenderer *)renderer;
    }
    
    MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor yellowColor];
    circleView.lineWidth = 2.0;
    
    return circleView;
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    homeAnnotationView = nil;
    
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        if ([annotation isKindOfClass:[FFTHomeAnnotation class]]) {
            homeAnnotationView = [FFTHomeAnnotation createViewAnnotationForMapView:self.mapView annotation:annotation];
            homeAnnotationView.draggable = YES;
            
            //observe actual coordinate for dragging homeAnnotationView
            [homeAnnotationView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    
    return homeAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    switch (newState) {
        case MKAnnotationViewDragStateStarting:
            annotationView.dragState = MKAnnotationViewDragStateDragging;
            break;
        case MKAnnotationViewDragStateEnding:
            annotationView.dragState = MKAnnotationViewDragStateNone;
            CLLocationCoordinate2D newCoordinate = annotationView.annotation.coordinate;
            [self updateHomeCoordinateWithNewCoordinate:newCoordinate];
            break;
        case MKAnnotationViewDragStateCanceling:
            annotationView.dragState = MKAnnotationViewDragStateNone;
            break;
            
        default:
            break;
    }
}

#pragma mark - Actions -

- (IBAction)invertCircleRadiusSliderValueChanged:(UISlider *)sender {
    invertCircleRadius = sender.value;
    [self updateInvertCircleRadiusWithNewRadius:invertCircleRadius];
    
    [self updateMapOverlay];
}

#pragma mark - Observer -

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    CGPoint position = homeAnnotationView.center;
    annotationCoordinate = [self.mapView convertPoint:position toCoordinateFromView:self.view];
    
    [self updateMapOverlay];
}

#pragma mark - Custom Methods -

- (void)updateMapOverlay {
    [self.mapView removeOverlays:[self.mapView overlays]];
    [self addMapOverlay];
}

- (void)updateHomeCoordinateWithNewCoordinate:(CLLocationCoordinate2D)newCoordinate {
    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    [defaults setFloat:newCoordinate.latitude forKey:kLastHomeLatitudeKey];
    [defaults setFloat:newCoordinate.longitude forKey:kLastHomeLongitudeKey];

    [defaults synchronize];
}

- (void)updateInvertCircleRadiusWithNewRadius:(float)newRadius {
    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    [defaults setFloat:newRadius forKey:kLastHomeInvertCircleRadiusKey];
    
    [defaults synchronize];
}

@end
