//
//  FAViewController.m
//  CircleProgress
//
//  Created by Jason on 2/20/14.
//  Copyright (c) 2014 Faria. All rights reserved.
//

#import "FAViewController.h"
#import "FACircularProgressView.h"

@interface FAViewController ()
@property (weak, nonatomic) IBOutlet FACircularProgressView *circularProgressView;
@property (weak, nonatomic) IBOutlet FACircularProgressView *autoCircularProgressView;
@property (assign, nonatomic) CGFloat currentProgress;
@end

@implementation FAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.circularProgressView.delegate = self;
	self.circularProgressView.progressColor = self.view.tintColor;
	self.autoCircularProgressView.progressColor = [UIColor redColor];
	self.autoCircularProgressView.progressArcWidth = 20.5f;
	
	// Progress
	self.currentProgress = 0.0f;
}

- (IBAction)tappedReset:(id)sender
{
	self.currentProgress = 0.0f;
	[self.circularProgressView setProgress:self.currentProgress animated:NO];
}

- (IBAction)tappedNoAnimated:(id)sender
{
	self.currentProgress += 0.1f;
	[self.circularProgressView setProgress:self.currentProgress animated:NO];
}
- (IBAction)tapped:(id)sender
{
	self.currentProgress += 0.1f;
	[self.circularProgressView setProgress:self.currentProgress duration: 1.1];
}

- (IBAction)tappedAuto:(id)sender
{
	[self.autoCircularProgressView setProgress:1.0f duration: 0.5];
}
- (IBAction)tappedAutoReset:(id)sender
{
	[self.autoCircularProgressView setProgress:0.0f duration: 0.5];
}

#pragma mark - CABasicAnimationDelegate

- (void)animationDidStart:(CAAnimation *)theAnimation
{
	NSLog(@"Animation started");
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	NSLog(@"Animation stopped");
}

@end
