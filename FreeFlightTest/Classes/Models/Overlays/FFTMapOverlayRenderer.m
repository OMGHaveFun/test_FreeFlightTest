//
//  FFTMapOverlayRenderer.m
//  FreeFlightTest
//
//  Created by Alexander Yalchik on 3/17/17.
//  Copyright © 2017 OMGHaveFun. All rights reserved.
//

#import "FFTMapOverlayRenderer.h"

@implementation FFTMapOverlayRenderer

// this method is called as a part of rendering the map, and it draws the overlay polygon by polygon
// which means that it renders overlay by square pieces
- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(mapRect.origin.x, mapRect.origin.y, mapRect.size.width, mapRect.size.height)];
    
    // converting to the 'world' coordinates
    double radiusInMapPoints = self.diameterInMeters * MKMapPointsPerMeterAtLatitude(self.overlay.coordinate.latitude);
    MKMapSize radiusSquared = {radiusInMapPoints, radiusInMapPoints};
    MKMapPoint regionOrigin = MKMapPointForCoordinate(self.overlay.coordinate);
    MKMapRect regionRect = (MKMapRect){regionOrigin, radiusSquared};
    regionRect = MKMapRectOffset(regionRect, -radiusInMapPoints/2, -radiusInMapPoints/2);
    regionRect = MKMapRectIntersection(regionRect, MKMapRectWorld);
    
    // next path is used for excluding the area within the specific radius from current user location
    UIBezierPath *excludePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(_circleRect.origin.x, _circleRect.origin.y, _circleRect.size.width, _circleRect.size.height) cornerRadius:_circleRect.size.width];
    [path appendPath:excludePath];
    
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextAddPath(context, path.CGPath);
    CGContextEOFillPath(context);
}

@end
