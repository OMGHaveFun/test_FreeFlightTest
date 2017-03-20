//
//  FFTMapOverlayRenderer.h
//  FreeFlightTest
//
//  Created by Alexander Yalchik on 3/17/17.
//  Copyright © 2017 OMGHaveFun. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface FFTMapOverlayRenderer : MKOverlayRenderer

@property (nonatomic, assign) double diameterInMeters;
@property (nonatomic, assign) MKMapRect circleRect;
@property (nonatomic, copy) UIColor *fillColor;

@end
