//
//  PXStroke.h
//  PXEngine
//
//  Created by Kevin Lindsey on 7/2/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXPaint.h"
#import "PXStrokeRenderer.h"

/**
 *  PXStrokeType is an enumeration indicating the placement of the stroke in relation to the contour it is being applied
 *  to.
 */
typedef enum
{
    kStrokeTypeCenter,
    kStrokeTypeInner,
    kStrokeTypeOuter
} PXStrokeType;

/**
 *  PXStroke is a general-purpose stroke allowing for the specification of standard stroke properties such as width,
 *  color, joins, and caps.
 */
@interface PXStroke : NSObject <PXStrokeRenderer>

/**
 *  An indication of how this stroke should be applied to its associated contour.
 */
@property (nonatomic) PXStrokeType type;

/**
 *  The width of this stroke
 */
@property (nonatomic) CGFloat width;

/**
 *  The paint to apply when rendering this stroke
 */
@property (nonatomic, strong) id<PXPaint> color;

/**
 *  An array indicating a pattern of dashes to be applied during rendering of this stroke
 */
@property (nonatomic, strong) NSArray* dashArray;

/**
 *  An offset to be applied before applying the values of the dashArayy
 */
@property (nonatomic) CGFloat dashOffset;

/**
 *  A value indicating how end-points of a stroke should be closed
 */
@property (nonatomic) CGLineCap lineCap;

/**
 *  A value indicating how joined line segments should be joined
 */
@property (nonatomic) CGLineJoin lineJoin;

/**
 *  A value indicating at which point an acute line join should be mitered
 */
@property (nonatomic) CGFloat miterLimit;

/**
 *  Initialize a new allocated stroke with the specified stroke width
 *
 *  @param width The stroke width
 */
- (id)initWithStrokeWidth:(CGFloat)width;

/**
 *  Return ths CGPath representation of the stroke as it will be rendered in the CGContext
 *
 *  @param path The path to stroke
 */
- (CGPathRef)newStrokedPath:(CGPathRef)path;

@end
