//
//  MapKitAnnotation.m
//  HelloCordova
//
//  Created by James Mattis on 6/1/16.
//
//

#import "MapKitAnnotation.h"

@implementation MapKitAnnotation

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate objects:(NSArray *)objectsArray
{
    self = [super init];
    
    if (self)
    {
        self.coordinate = coordinate;

        self.objects = [[NSMutableArray alloc] init];
        
        if (objectsArray.count > 0)
        {
            [self.objects addObjectsFromArray:objectsArray];
        }
        
        self.count = objectsArray.count;
        
        NSLog(@"  MKA: init (%1.5f, %1.5f) %@ %zd", self.coordinate.latitude, self.coordinate.longitude, self.objects, self.count);
    }
    
    return self;
}

-(NSInteger)count
{
    return self.objects.count;
}

- (NSUInteger)hash
{
    NSMutableString *objectsString = [[NSMutableString alloc] init];
    
    for (NSNumber *number in self.objects)
    {
        [objectsString appendFormat:@"%zd", number.integerValue];
    }
    
    NSString *toHash = [NSString stringWithFormat:@"%.5f%.5f%@", self.coordinate.latitude, self.coordinate.longitude, objectsString];
    
    return [toHash hash];
}

- (BOOL)isEqual:(id)object
{
    return [self hash] == [object hash];
}

@end
