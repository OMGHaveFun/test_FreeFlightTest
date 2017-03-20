//
//  FFTMapOverlay.h
//  FreeFlightTest
//
//  Created by Alexander Yalchik on 3/17/17.
//  Copyright © 2017 OMGHaveFun. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface FFTMapOverlay : NSObject <MKOverlay>

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
