//
//  MapKitCoordinateQuadTree.h
//  HelloCordova
//
//  Created by James Mattis on 6/1/16.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "MapKitQuadTree.h"
#import "MapKitAnnotation.h"

@interface MapKitCoordinateQuadTree : NSObject

@property (assign, nonatomic) MKQuadTreeNode* root;

@property (strong, nonatomic) MKMapView *mapView;

- (void)initWithMapRect:(MKMapRect)mapRect;

- (void)setMapRect:(MKMapRect)mapRect;

- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale;

- (void)addAnnotation:(MapKitAnnotation *)annotation;

@end
