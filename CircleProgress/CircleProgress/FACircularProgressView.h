#import <UIKit/UIKit.h>

@interface FACircularProgressView : UIView

// Set delegate to allow callbacks (animataionDidFinish, etc)
@property(strong, nonatomic) id delegate;

// Color of wrapper circle and progress arc.
@property(strong, nonatomic) UIColor *progressColor;

// Width of progress arc
@property (assign, nonatomic) CGFloat progressArcWidth;

// Set new progress (0.0f - 1.0f) with animation option
- (void)setProgress:(CGFloat)progress animated:(BOOL)animate;

// Set new progress (0.0f - 1.0f) animated with custom duration
- (void)setProgress:(CGFloat)progress duration:(CFTimeInterval)duration;

@end
