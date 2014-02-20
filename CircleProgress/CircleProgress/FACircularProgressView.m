#import "FACircularProgressView.h"

@interface FACircularProgressView()
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (assign, nonatomic) CGFloat currentProgress;
@property (assign, nonatomic) CGFloat lastProgress;
@property (assign, nonatomic) BOOL animated;
@property (assign, nonatomic) CFTimeInterval duration;
@end

@implementation FACircularProgressView

- (void)awakeFromNib
{
    [self setUp];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.delegate = nil;
    self.currentProgress = 0.0f;
    self.lastProgress = 0.0f;
    self.animated = YES;
    self.duration = 0.5;
    self.progressArcWidth = 3.0f;
}

- (void)drawRect:(CGRect)rect
{
    // Outer circle
    CGRect newRect = ({
        CGRect insetRect = CGRectInset(rect, 1.5f, 1.5f);
        CGRect newRect = insetRect;
        newRect.size.width = MIN(CGRectGetMaxX(insetRect), CGRectGetMaxY(insetRect));
        newRect.size.height = newRect.size.width;
        newRect.origin.x = insetRect.origin.x + (CGRectGetWidth(insetRect) - CGRectGetWidth(newRect)) / 2;
        newRect.origin.y = insetRect.origin.y + (CGRectGetHeight(insetRect) - CGRectGetHeight(newRect)) / 2;
        newRect;
    });
    UIBezierPath *outerCircle = [UIBezierPath bezierPathWithOvalInRect:newRect];
    [self.progressColor setStroke];
    outerCircle.lineWidth = 1;
    [outerCircle stroke];
	
//	[self drawOutterCircle: rect];
}

- (void)drawOutterCircle:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGFloat lineWidth = 2;
	
	CGContextSetRGBStrokeColor(context, 211/255.0, 217/255.0, 225/255.0, 1.0);
	CGContextSetRGBFillColor(context, 244/255.0, 244/255.0, 247/255.0, 1.0);
	CGContextSetLineWidth(context, lineWidth);
	
	
    CGRect outerRect = ({
			CGFloat offset = CGRectGetWidth(rect)*0.01;
			CGRect insetRect = CGRectInset(rect, offset, offset);
			CGRect newRect = insetRect;
			newRect.size.width = MIN(CGRectGetMaxX(insetRect), CGRectGetMaxY(insetRect));
			newRect.size.height = newRect.size.width;
			newRect.origin.x = insetRect.origin.x + (CGRectGetWidth(insetRect) - CGRectGetWidth(newRect)) / 2;
			newRect.origin.y = insetRect.origin.y + (CGRectGetHeight(insetRect) - CGRectGetHeight(newRect)) / 2;
			newRect;
    });

	
	CGRect borderRect = CGRectInset(outerRect, lineWidth * 0.5, lineWidth * 0.5);
	
	CGContextFillEllipseInRect (context, borderRect);
	CGContextStrokeEllipseInRect(context, borderRect);
	CGContextFillPath(context);
	
	CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
	CGContextSetLineWidth(context, 2.0);

	CGRect innerRect = CGRectMake(rect.origin.x+rect.size.width*0.2,
																rect.origin.y+rect.size.height*0.2,
																rect.size.width*0.6,
																rect.size.height*0.6);
	
	borderRect = CGRectInset(innerRect, lineWidth * 0.5, lineWidth * 0.5);
	
	CGContextFillEllipseInRect (context, borderRect);
	CGContextStrokeEllipseInRect(context, borderRect);
	CGContextFillPath(context);
	
	CGRect frame = self.frame;
	frame.origin = CGPointZero;
	
//	[self drawRoundPath: context];
}

- (void) drawRoundPath: (CGContextRef) context
{
	CGContextSaveGState(context);
	
	CGContextSetLineCap(context, kCGLineCapRound);
	
	CGFloat radius = self.frame.size.width*0.39;
	CGFloat lineWidth = self.frame.size.width*0.2f;
	CGContextSetLineWidth(context, lineWidth);
	CGContextSetRGBStrokeColor(context, 35/255.0, 112/255.0, 245/255.0, 1.0);
	
	float angelMod = 34/18.0f;
	if(2 == 15)
		angelMod = 2;
	
	CGPoint arcCenter = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
	
	CGContextAddArc(context,
									arcCenter.
									x,arcCenter.y,
									radius,
									-M_PI_2,
									2/(CGFloat)15*(angelMod*M_PI) - M_PI_2
									,NO);
	
	CGContextStrokePath(context);
	
	CGContextSetRGBStrokeColor(context, 66/255.0, 162/255.0, 251/255.0, 1.0);
	CGContextSetLineWidth(context, lineWidth-4);
	
	CGFloat angle = 2/(CGFloat)15*(angelMod*M_PI) - M_PI_2;
	
	CGContextAddArc(context,
									arcCenter.x,
									arcCenter.y,
									radius,
									-M_PI_2,
									angle,
									NO);
	
	CGContextStrokePath(context);
	
	CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
	CGContextFillEllipseInRect (context, CGRectMake(arcCenter.x-5,arcCenter.y-radius-5,10,10));
	
	CGFloat x = arcCenter.x + radius * cos(angle);
	CGFloat y = arcCenter.y + radius * sin(angle);
	
	CGContextFillEllipseInRect (context, CGRectMake(x-5,y-5,10,10));
	
	CGContextRestoreGState(context);
}


- (CGPathRef)progressPath
{
    // Offset
    CGFloat offset = - M_PI_2;
  
    // EndAngle
    CGFloat endAngle =  1 * 2 * M_PI + offset;
  
    // Center
    CGRect rect = self.bounds;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));

    // Radius
    CGFloat radius = MIN(center.x, center.y) - self.progressArcWidth / 2;
  
    // Inner arc
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:center
                                                           radius:radius
                                                       startAngle:offset
                                                         endAngle:endAngle
                                                        clockwise: 1];
    
    return arcPath.CGPath;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self refreshShapeLayer];
}

#pragma mark - Getters methods

- (CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.strokeColor = self.progressColor.CGColor;
        _shapeLayer.lineWidth = self.progressArcWidth;
        _shapeLayer.fillColor = nil;
        _shapeLayer.lineJoin = kCALineJoinBevel;
      
			
			CAGradientLayer *gradientLayer = [CAGradientLayer layer];
			gradientLayer.startPoint = CGPointMake(0.5,1.0);
			gradientLayer.endPoint = CGPointMake(0.5,0.0);
			gradientLayer.frame = self.bounds;
			NSMutableArray *colors = [NSMutableArray array];
			for (int i = 0; i < 10; i++) {
				[colors addObject:(id)[[UIColor colorWithHue:(0.1 * i) saturation:1 brightness:.8 alpha:1] CGColor]];
			}
			gradientLayer.colors = colors;
			gradientLayer.mask = _shapeLayer;
			
			[self.layer addSublayer:gradientLayer];
    }
    
    return _shapeLayer;
}

#pragma mark - Private methods

- (void)refreshShapeLayer
{
	// Update path
	self.shapeLayer.path = [self progressPath];
	CALayer *currentLayer = (CALayer *)[self.shapeLayer presentationLayer];
	CGFloat oldStrokeEnd = [(NSNumber *)[currentLayer valueForKeyPath:@"strokeEnd"] floatValue];
	self.shapeLayer.strokeEnd = self.currentProgress;
	// Update lastProgress
	//	self.lastProgress = self.currentProgress;
	// Animation
	
	// From value
	CGFloat toValue = self.currentProgress;
#warning , not perfect , need check for reverse
	CGFloat  fromValue = self.lastProgress < oldStrokeEnd ? self.lastProgress : oldStrokeEnd;
	NSLog(@"%f %f %f", oldStrokeEnd, self.lastProgress, fromValue);
	CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	pathAnimation.delegate = self.delegate;
	pathAnimation.duration = self.duration;
	pathAnimation.fromValue = @(fromValue);
	pathAnimation.toValue = @(toValue);
	pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
	[self.shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
  
  self.lastProgress = self.currentProgress;
}

#pragma mark - Public methods

- (void)setProgress:(CGFloat)progress animated:(BOOL)animate
{
    self.currentProgress = MAX(MIN(progress, 1.0f), 0.0f);
    self.animated = animate;
    
    [self setNeedsLayout];
}

- (void)setProgress:(CGFloat)progress duration:(CFTimeInterval)duration
{
    self.duration = duration;
    [self setProgress:progress animated:YES];
}

@end
