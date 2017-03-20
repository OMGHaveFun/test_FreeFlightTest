//
//  FFTMapOverlay.m
//  FreeFlightTest
//
//  Created by Alexander Yalchik on 3/17/17.
//  Copyright © 2017 OMGHaveFun. All rights reserved.
//

#import "FFTMapOverlay.h"

@implementation FFTMapOverlay

@synthesize coordinate = _coordinate;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    
    self = [super init];
    if (self) {
        _coordinate = coordinate;
    }
    
    return self;
}

- (MKMapRect)boundingMapRect {
    return MKMapRectWorld;
}

@end
