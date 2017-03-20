//
//  FFTHomeAnnotation.m
//  FreeFlightTest
//
//  Created by Alexander Yalchik on 3/16/17.
//  Copyright © 2017 OMGHaveFun. All rights reserved.
//

#import "FFTHomeAnnotation.h"
#import "FFTHomeAnnotationView.h"

@implementation FFTHomeAnnotation

@synthesize coordinate;

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *returnedAnnotationView = (FFTHomeAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([FFTHomeAnnotation class])];
    if (returnedAnnotationView == nil) {
        returnedAnnotationView = [[FFTHomeAnnotationView alloc] initWithAnnotation:annotation
                                                                   reuseIdentifier:NSStringFromClass([FFTHomeAnnotation class])];
    }
    else {
        returnedAnnotationView.annotation = annotation;
    }
    
    return returnedAnnotationView;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

@end
