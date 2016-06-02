//
//  MapKitCoordinateQuadTree.m
//  HelloCordova
//
//  Created by James Mattis on 6/1/16.
//
//

#import "MapKitCoordinateQuadTree.h"
#import "MapKitAnnotation.h"

MKBoundingBox MKBoundingBoxForMapRect(MKMapRect mapRect)
{
    CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(mapRect.origin);
    CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)));
    
    CLLocationDegrees minLat = botRight.latitude;
    CLLocationDegrees maxLat = topLeft.latitude;
    
    CLLocationDegrees minLon = topLeft.longitude;
    CLLocationDegrees maxLon = botRight.longitude;
    
    return MKBoundingBoxMake(minLat, minLon, maxLat, maxLon);
}

MKMapRect MKMapRectForBoundingBox(MKBoundingBox boundingBox)
{
    MKMapPoint topLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.x0, boundingBox.y0));
    MKMapPoint botRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.xf, boundingBox.yf));
    
    return MKMapRectMake(topLeft.x, botRight.y, fabs(botRight.x - topLeft.x), fabs(botRight.y - topLeft.y));
}

NSInteger MKZoomScaleToZoomLevel(MKZoomScale scale)
{
    double totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0;
    NSInteger zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom);
    NSInteger zoomLevel = MAX(0, zoomLevelAtMaxZoom + floor(log2f(scale) + 0.5));
    
    return zoomLevel;
}

float MKCellSizeForZoomScale(MKZoomScale zoomScale)
{
    NSInteger zoomLevel = MKZoomScaleToZoomLevel(zoomScale);
    
    switch (zoomLevel) {
        case 13:
        case 14:
        case 15:
            return 64;
        case 16:
        case 17:
        case 18:
            return 32;
        case 19:
            return 16;
            
        default:
            return 88;
    }
}


@implementation MapKitCoordinateQuadTree

- (void)initWithMapRect:(MKMapRect)mapRect
{
    @autoreleasepool
    {
        MKBoundingBox boundingBox = MKBoundingBoxForMapRect(mapRect);
        
        _root = MKQuadTreeNodeMake(boundingBox, 4);
    }
}

- (void)setMapRect:(MKMapRect)mapRect
{
    NSLog(@"__coordQuadTree setMapRect");

    _root->boundingBox = MKBoundingBoxForMapRect(mapRect);
}

- (void)addAnnotation:(MapKitAnnotation *)annotation
{
    NSLog(@"addAnnotation");

    MKQuadTreeNodeData data = MKQuadTreeNodeDataMake(annotation.coordinate.latitude, annotation.coordinate.longitude, ((NSNumber *)annotation.objects.firstObject).integerValue);

    MKQuadTreeNodeInsertData(_root, data);
}

- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale
{
    double MKCellSize = MKCellSizeForZoomScale(zoomScale);
    double scaleFactor = zoomScale / MKCellSize;
    
    NSInteger minX = floor(MKMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MKMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MKMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MKMapRectGetMaxY(rect) * scaleFactor);
    
    NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    
    for (NSInteger x = minX; x <= maxX; x++)
    {
        for (NSInteger y = minY; y <= maxY; y++)
        {
            MKMapRect mapRect = MKMapRectMake(x / scaleFactor, y / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor);
            
            __block double totalX = 0;
            __block double totalY = 0;
            __block int count = 0;
            
            NSMutableArray *sightings = [[NSMutableArray alloc] init];
            
            MKQuadTreeGatherDataInRange(self.root, MKBoundingBoxForMapRect(mapRect), ^(MKQuadTreeNodeData data) {
                totalX += data.x;
                totalY += data.y;
                count++;
                
                NSInteger sightingInfo = data.data;
                
                [sightings addObject:@(sightingInfo)];
            });
            
            CLLocationCoordinate2D coordinate;
            
            if (count > 0)
            {
                if (sightings.count > 1)
                {
                    coordinate = CLLocationCoordinate2DMake(totalX / count, totalY / count);
                }
                else
                {
                    coordinate = CLLocationCoordinate2DMake(totalX, totalY);
                }
                
                MapKitAnnotation *annotation = [[MapKitAnnotation alloc] initWithCoordinate:coordinate objects:sightings];
                [clusteredAnnotations addObject:annotation];
            }
        }
    }
    
    return [NSArray arrayWithArray:clusteredAnnotations];
}

@end
