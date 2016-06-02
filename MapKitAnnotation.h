//
//  MapKitAnnotation.h
//  HelloCordova
//
//  Created by James Mattis on 6/1/16.
//
//

#import <MapKit/MapKit.h>

@interface MapKitAnnotation : MKPointAnnotation

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSMutableArray *objects;

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate objects:(NSArray *)objectsArray;

@end
