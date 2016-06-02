//
//  MapKitAnnotationView.m
//  HelloCordova
//
//  Created by James Mattis on 6/1/16.
//
//

#import "MapKitAnnotationView.h"
#import "MapKitAnnotation.h"

CGPoint MKRectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGRect MKCenterRect(CGRect rect, CGPoint center)
{
    CGRect r = CGRectMake(center.x - rect.size.width/2.0,
                          center.y - rect.size.height/2.0,
                          rect.size.width,
                          rect.size.height);
    return r;
}

static CGFloat const MKScaleFactorAlpha = 0.3;
static CGFloat const MKScaleFactorBeta = 0.4;

CGFloat MKScaledValueForValue(CGFloat value)
{
    return 1.0 / (1.0 + expf(-1 * MKScaleFactorAlpha * powf(value, MKScaleFactorBeta)));
}

@interface MapKitAnnotationView ()

@property (strong, nonatomic) UILabel *countLabel;

@end

@implementation MapKitAnnotationView

-(id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.image = [UIImage imageNamed:@"pin.png"];
    }
    
    return self;
}

- (void)setupLabel
{
    self.countLabel = [[UILabel alloc] initWithFrame:self.frame];
    self.countLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    self.countLabel.numberOfLines = 1;
    self.countLabel.font = [UIFont boldSystemFontOfSize:12];
    self.countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    [self addSubview:self.countLabel];
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    
    if (_count > 1)
    {
        [self setupLabel];

        CGRect newBounds = CGRectMake(0, 0, roundf(44 * MKScaledValueForValue(count)), roundf(44 * MKScaledValueForValue(count)));
        self.frame = MKCenterRect(newBounds, self.center);
        
        CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width / 1.3, newBounds.size.height / 1.3);
        
        self.countLabel.frame = MKCenterRect(newLabelBounds, MKRectCenter(newBounds));
        self.countLabel.text = [@(_count) stringValue];
    }

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, true);
    
    if (self.count > 1)
    {
        UIColor *circleFillColor;
        
        if (self.count >= 150)
            circleFillColor = [UIColor colorWithHue:(338.0 / 359.0) saturation:(42.0 / 100.0) brightness:(95.0 / 100.0) alpha:1.0];
        else if (self.count >= 20)
            circleFillColor = [UIColor colorWithHue:(60.0 / 359.0) saturation:(51.0 / 100.0) brightness:(95.0 / 100.0) alpha:1.0];
        else
            circleFillColor = [UIColor colorWithHue:(192.0 / 359.0) saturation:(62.0 / 100.0) brightness:(84.0 / 100.0) alpha:1.0];
        
        CGRect circleFrame = CGRectInset(rect, 4, 4);
        
        [circleFillColor setFill];
        CGContextFillEllipseInRect(context, circleFrame);
    }
    else
    {
        [self.image drawInRect:rect];
    }
}

@end
