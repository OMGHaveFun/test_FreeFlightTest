//
//  FFTHomeAnnotation.h
//  FreeFlightTest
//
//  Created by Alexander Yalchik on 3/16/17.
//  Copyright © 2017 OMGHaveFun. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface FFTHomeAnnotation : NSObject <MKAnnotation>

@property (nonatomic) BOOL isDirectionEnabled;
@property (nonatomic) CGFloat annotationSize;
@property (nonatomic) CGFloat directionAngle;
@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
