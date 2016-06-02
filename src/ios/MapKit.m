//
//  MapKit.m
//  HelloCordova
//
//  Created by James Mattis on 6/1/16.
//
//

#import "MapKit.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "AppDelegate.h"
#import "MapKitAnnotation.h"
#import "MapKitAnnotationView.h"
#import "MapKitCoordinateQuadTree.h"

@interface MapKit () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;

@property (strong, nonatomic) MapKitCoordinateQuadTree *coordinateQuadTree;

@end


@implementation MapKit

-(void)consoleLog:(CDVInvokedUrlCommand*)command
{
    NSLog(@"consoleLog: %@", command.arguments.firstObject);
}

-(instancetype)init
{
    NSLog(@"init");
    
    self = [super init];
    
    if (self != nil)
    {
        
    }
    
    return self;
}

- (void)pluginInitialize
{
    NSLog(@"pluginInitialize");

    [super pluginInitialize];
    
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height)];
    
    self.mapView.mapType = MKMapTypeSatellite;
    
    self.mapView.delegate = self;
    [self.webView addSubview:self.mapView];
    
    self.coordinateQuadTree = [[MapKitCoordinateQuadTree alloc] init];
    
    self.coordinateQuadTree.mapView = self.mapView;
    
    [self.coordinateQuadTree initWithMapRect:self.mapView.visibleMapRect];
}

- (void)createMapView:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    CGFloat height = [command.arguments[1] floatValue];
    CGFloat width = [command.arguments[2] floatValue];
    CGFloat xPos = [command.arguments[3] floatValue];
    CGFloat yPos = [command.arguments[4] floatValue];
    
    NSLog(@"createMapView");
    
    self.mapView.frame = CGRectMake(xPos, yPos, width, height);
    self.mapView.tag = mapId;

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)showMapView:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.hidden = NO;
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    
}

- (void)hideMapView:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.hidden = YES;
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)removeMapView:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];

    [self.mapView removeFromSuperview];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)changeMapHeight:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    CGFloat height = [command.arguments[1] floatValue];
    
    [self.mapView setFrame:CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, height)];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)changeMapWidth:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    CGFloat width = [command.arguments[1] floatValue];
    
    [self.mapView setFrame:CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, width, self.mapView.frame.size.height)];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)changeMapBounds:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    CGFloat height = [command.arguments[1] floatValue];
    CGFloat width = [command.arguments[2] floatValue];
    
    [self.mapView setFrame:CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, width, height)];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
   
}

- (void)changeMapXPos:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    CGFloat XPos = [command.arguments[1] floatValue];
    
    [self.mapView setFrame:CGRectMake(XPos, self.mapView.frame.origin.y, self.mapView.frame.size.width, self.mapView.frame.size.height)];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)changeMapYPos:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    CGFloat YPos = [command.arguments[1] floatValue];
    
    [self.mapView setFrame:CGRectMake(self.mapView.frame.origin.x, YPos, self.mapView.frame.size.width, self.mapView.frame.size.height)];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)changeMapPosition:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    CGFloat XPos = [command.arguments[1] floatValue];
    CGFloat YPos = [command.arguments[2] floatValue];
    
    [self.mapView setFrame:CGRectMake(XPos, YPos, self.mapView.frame.size.width, self.mapView.frame.size.height)];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)isShowingUserLocation:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    NSString *locationVisible;
    
    if (self.mapView.userLocationVisible)
    {
        locationVisible = @"true";
    }
    else
    {
        locationVisible = @"false";
    }
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)showMapScale:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.showsScale = YES;
    
    NSLog(@"showMapScale");
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)hideMapScale:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.showsScale = NO;
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)showMapUserLocation:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.showsUserLocation = YES;
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)hideMapUserLocation:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.showsUserLocation = NO;
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)showMapCompass:(CDVInvokedUrlCommand*)command
{
    NSLog(@"showMapCompass");
    
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.showsCompass = YES;
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)hideMapCompass:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.showsCompass = NO;
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)showMapPointsOfInterest:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.showsPointsOfInterest = YES;
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)hideMapPointsOfInterest:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.showsPointsOfInterest = NO;
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)showMapBuildings:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.showsBuildings = YES;
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)hideMapBuildings:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.showsBuildings = NO;
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)showMapTraffic:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.showsTraffic = YES;
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)hideMapTraffic:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    self.mapView.showsTraffic = NO;
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)setMapOpacity:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    CGFloat newAlpha = [command.arguments[1] floatValue];
    
    [self.mapView setAlpha: newAlpha];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)setMapCenter:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    CGFloat centerLat = [command.arguments[1] floatValue];
    CGFloat centerLon = [command.arguments[2] floatValue];
    BOOL animated = [command.arguments[3] boolValue];
    
    CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(centerLat, centerLon);
    [self.mapView setCenterCoordinate:newCenter animated:animated];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)enableMapRotate:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    [self.mapView setRotateEnabled:YES];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
- (void)disableMapRotate:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    [self.mapView setRotateEnabled:NO];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)enableMapScroll:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    [self.mapView setScrollEnabled:YES];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)disableMapScroll:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    [self.mapView setScrollEnabled:NO];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)enableMapUserInteraction:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    [self.mapView setUserInteractionEnabled:YES];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)disableMapUserInteraction:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    [self.mapView setUserInteractionEnabled:NO];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)setMapRegion:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    CGFloat centerLat = [command.arguments[1] floatValue];
    CGFloat centerLon = [command.arguments[2] floatValue];
    CGFloat spanLat = [command.arguments[3] floatValue];
    CGFloat spanLon = [command.arguments[4] floatValue];
    BOOL animated = [command.arguments[5] boolValue];
    
    CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(centerLat, centerLon);
    MKCoordinateSpan newSpan = MKCoordinateSpanMake(spanLat, spanLon);
    
    MKCoordinateRegion newRegion = MKCoordinateRegionMake(newCenter, newSpan);
    [self.mapView setRegion:newRegion animated:animated];
    
    [self.coordinateQuadTree setMapRect:self.mapView.visibleMapRect];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)addMapPin:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    CGFloat lat = [command.arguments[1] floatValue];
    CGFloat lon = [command.arguments[2] floatValue];
    NSInteger objectID = [command.arguments[3] integerValue];
    
    NSLog(@"addMapPin");

    MapKitAnnotation* pin = [[MapKitAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) objects:@[@(objectID)]];
    
    [self.coordinateQuadTree addAnnotation:pin];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)addMapPins:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    NSArray* pins = command.arguments[1];
    NSMutableArray* Pins = [[NSMutableArray alloc] init];
    
    NSLog(@"addMapPins");

    for (int i = 0; i < pins.count; i++)
    {
        NSArray* pinInfo = [pins objectAtIndex:i];
        
        CGFloat lat = [[pinInfo objectAtIndex:0] floatValue];
        CGFloat lon = [[pinInfo objectAtIndex:1] floatValue];
        NSString* title = [pinInfo objectAtIndex:2];
        NSString* description = [pinInfo objectAtIndex:3];
        
        MKPointAnnotation* pin = [[MKPointAnnotation alloc]init];
        pin.coordinate = CLLocationCoordinate2DMake(lat, lon);
        pin.title = title;
        pin.subtitle = description;
        
        [Pins addObject:pin];
    }
    
    [self.mapView addAnnotations:Pins];
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    
}

- (void)removeAllMapPins:(CDVInvokedUrlCommand*)command
{
    CGFloat mapId = [command.arguments.firstObject floatValue];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[NSString stringWithFormat:@"%f", mapId]];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(nonnull MKAnnotationView *)view
{
    MapKitAnnotation *annotation = (MapKitAnnotation *) view.annotation;
    
    if (annotation.count == 1)
    {
        NSMutableString* jsParam = [[NSMutableString alloc] init];
     
        [jsParam appendString:@"\""];
        [jsParam appendString:[NSString stringWithFormat:@"%zd", ((NSNumber *)annotation.objects.firstObject).integerValue]];
        [jsParam appendString:@"\""];
        
        NSString* jsString = [NSString stringWithFormat:@"MKInterface.__objc__.pinClickCallback(%@);", jsParam];
        [self.webView stringByEvaluatingJavaScriptFromString:jsString];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *pinReuseIdentifier = @"pinReuseIdentifier";
    
    MapKitAnnotationView *pinAnnotationView = nil;
    
    pinAnnotationView = (MapKitAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReuseIdentifier];
    
    if (pinAnnotationView == nil)
    {
        pinAnnotationView = [[MapKitAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinReuseIdentifier];
    }
    else
    {
        pinAnnotationView.annotation = annotation;
    }
    
    pinAnnotationView.count = ((MapKitAnnotation *)annotation).count;
    
    pinAnnotationView.canShowCallout = NO;
    pinAnnotationView.draggable = NO;

    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    __weak __typeof(self) weakSelf = self;
    
    NSLog(@"regionDidChangeAnimated");

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        __strong __typeof(self) strongSelf = weakSelf;
        
        double scale = strongSelf.mapView.bounds.size.width / strongSelf.mapView.visibleMapRect.size.width;
        
        NSArray *annotations = [strongSelf.coordinateQuadTree clusteredAnnotationsWithinMapRect:mapView.visibleMapRect withZoomScale:scale];
        
        NSMutableSet *before = [NSMutableSet setWithArray:strongSelf.mapView.annotations];
        [before removeObject:[strongSelf.mapView userLocation]];
        NSSet *after = [NSSet setWithArray:annotations];
        
        NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
        [toKeep intersectSet:after];
        
        NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
        [toAdd minusSet:toKeep];
        
        NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
        [toRemove minusSet:after];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.mapView removeAnnotations:[toRemove allObjects]];
            [strongSelf.mapView addAnnotations:[toAdd allObjects]];
        });
    });
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    [views enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull object, NSUInteger index, BOOL * _Nonnull stop) {
        
        UIView *view = (UIView *) object;
        
        CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        
        bounceAnimation.values = @[@(0.05), @(1.1), @(0.9), @(1)];
        
        bounceAnimation.duration = 0.6;
        NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounceAnimation.values.count];
        for (NSUInteger i = 0; i < bounceAnimation.values.count; i++) {
            [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        }
        [bounceAnimation setTimingFunctions:timingFunctions.copy];
        bounceAnimation.removedOnCompletion = NO;
        
        [view.layer addAnimation:bounceAnimation forKey:@"bounce"];
    }];
}

@end
