//
//  FFTConstants.h
//  FreeFlightTest
//
//  Created by Alexander Yalchik on 3/17/17.
//  Copyright © 2017 OMGHaveFun. All rights reserved.
//

#ifndef FFTConstants_h
#define FFTConstants_h

static NSString * const kLastHomeLatitudeKey = @"kLastHomeLatitude";
static NSString * const kLastHomeLongitudeKey = @"kLastHomeLongitude";
static NSString * const kLastHomeInvertCircleRadiusKey = @"kLastHomeInvertCircleRadius";

// default map position in France
static const float FFTDefaultMapPositionLatitude = 48.864716;
static const float FFTDefaultMapPositionLongitude = 2.349014;
static const float FFTDefaultSpanDelta = 0.4;

// default home position in France
static const float FFTDefaultHomePositionLatitude = 48.879024;
static const float FFTDefaultHomePositionLongitude = 2.367449;

// default circle radius around home icon
static const float FFTDefaultInvertCircleRadiusKey = 100;

#endif /* FFTConstants_h */
