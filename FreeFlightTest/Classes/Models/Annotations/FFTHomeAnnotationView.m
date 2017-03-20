//
//  FFTHomeAnnotationView.m
//  FreeFlightTest
//
//  Created by Alexander Yalchik on 3/18/17.
//  Copyright © 2017 OMGHaveFun. All rights reserved.
//

#import "FFTHomeAnnotationView.h"

#define degreesToRadians(x) (x * M_PI / 180.0)
static CGFloat kSideMargin = 10.0;
static CGFloat kTriangleSideSize = 9.0;

@implementation FFTHomeAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        homeAnnotation = (FFTHomeAnnotation *)self.annotation;
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat squreSideLenght = homeAnnotation.annotationSize;
        CGRect frame = CGRectMake(0, 0, squreSideLenght, squreSideLenght);
        [self setFrame:frame];

        UIImageView *annotationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:homeAnnotation.imageName]];
        annotationImage.contentMode = UIViewContentModeScaleAspectFit;
        annotationImage.frame = CGRectMake(kSideMargin, kSideMargin, squreSideLenght - kSideMargin*2, squreSideLenght - kSideMargin*2);
        [self addSubview:annotationImage];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {

    if (homeAnnotation.isDirectionEnabled) {
        UIColor *fillColor = [UIColor colorWithRed:4.0f/255.0f
                                             green:174.0f/255.0f
                                              blue:218.0f/255.0f
                                             alpha:1.0f];
        [fillColor setFill];
        
        CGFloat angle = degreesToRadians(homeAnnotation.directionAngle);
        
        CGFloat radius = self.frame.size.height/2;
        CGPoint centerPoint = CGPointMake(radius, radius);
        
        CGPoint firstTrianglePoint = [self pointAroundCircumferenceFromCenter:centerPoint withRadius:radius andAngle:angle];
        CGPoint secondTrianglePoint = [self secondTrianglePointFromTriangleVertexPoint:firstTrianglePoint withDistance:kTriangleSideSize andAngle:angle];
        CGPoint thirdTrianglePoint = [self thirdTrianglePointFromTriangleVertexPoint:firstTrianglePoint withDistance:kTriangleSideSize andAngle:angle];

        UIBezierPath *triangle = [UIBezierPath bezierPath];
        [triangle moveToPoint:firstTrianglePoint];
        [triangle addLineToPoint:secondTrianglePoint];
        [triangle addLineToPoint:thirdTrianglePoint];
        [triangle closePath];
        [triangle fill];
    }
}

- (CGPoint)pointAroundCircumferenceFromCenter:(CGPoint)center withRadius:(CGFloat)radius andAngle:(CGFloat)alpha {
    CGPoint point = CGPointZero;
    point.x = center.x + radius * cos(alpha);
    point.y = center.y + radius * sin(alpha);
    
    return point;
}

- (CGPoint)secondTrianglePointFromTriangleVertexPoint:(CGPoint)triangleVertexPoint withDistance:(CGFloat)distance andAngle:(CGFloat)alpha {
    
    CGPoint point = CGPointZero;
    CGFloat triangleAngle = degreesToRadians(60);
    
    point.x = triangleVertexPoint.x - distance * sin(triangleAngle - alpha);
    point.y = triangleVertexPoint.y - distance * cos(triangleAngle - alpha);
    
    return point;
}

- (CGPoint)thirdTrianglePointFromTriangleVertexPoint:(CGPoint)center withDistance:(CGFloat)distance andAngle:(CGFloat)alpha {
    
    CGPoint point = CGPointZero;
    CGFloat triangleAngle = degreesToRadians(60);
    CGFloat supportAngle = degreesToRadians(90);
    
    point.x = center.x - distance * sin(triangleAngle - alpha) - distance * cos(supportAngle - alpha);
    point.y = center.y - distance * cos(triangleAngle - alpha) + distance * sin(supportAngle - alpha);
    
    return point;
}

@end
