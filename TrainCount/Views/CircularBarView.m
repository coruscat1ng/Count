//
//  circular_bar.m
//  count
//
//  Created by Max Ivanov on 30.04.2021.
//

#import "CircularBarView.h"

@import QuartzCore;

@interface CircularBarView()

@property (strong, nonatomic) CAShapeLayer *progressBar;

@end

@implementation CircularBarView

#define STARTING_ANGLE 0

- (void)drawRect: (CGRect) rect
{

	[self setBar];
	[self printScore];
  
}

-(void)setBar
{
	if(self.current_time > 0) {
		int min_size = MIN(self.bounds.size.width, self.bounds.size.height);
		self.progressBar.lineWidth = MAX(min_size / 20, 5);
		CGMutablePathRef circle = CGPathCreateMutable();
		CGPathAddArc(circle, 0, self.bounds.size.width / 2, self.bounds.size.height / 2,
								 (min_size / 2 - self.progressBar.lineWidth), STARTING_ANGLE, M_PI * 2 + STARTING_ANGLE, YES);
		
		self.progressBar.path = circle;
	} else {
		
		self.progressBar.path = 0;
	}
}
-(void)printScore
{
	UIColor *rights_color = [UIColor greenColor];
	UIColor *wrongs_color = [UIColor redColor];
	
	UIFont *textFont = [UIFont preferredFontForTextStyle: UIFontTextStyleBody];
	textFont = [textFont fontWithSize: 30];
	
	
	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.alignment = NSTextAlignmentCenter;

	NSMutableAttributedString *text = [[NSMutableAttributedString alloc]
																		 initWithString: [NSString stringWithFormat: @"%d\n%d", self.rights , self.wrongs]
																		 attributes: @{
																			 NSFontAttributeName: textFont,
																			 NSParagraphStyleAttributeName: style
																		 }];
	NSUInteger len = [NSString stringWithFormat: @"%d", self.rights].length;
	NSRange rights_range = NSMakeRange(0, len);
	
	[text addAttribute: NSForegroundColorAttributeName
							 value: rights_color
							 range: rights_range];
	
	NSRange wrongs_range = NSMakeRange(len, text.length - len);
	
	[text addAttribute: NSForegroundColorAttributeName
							 value: wrongs_color
							 range: wrongs_range];
 
	CGRect textRect;

	textRect.size = [text size];
	textRect.origin = CGPointMake((self.bounds.size.width - textRect.size.width) / 2 , (self.bounds.size.height - textRect.size.height) / 2);

	[text drawInRect: textRect];
}

-(void)animate
{
	float fraction = self.current_time / self.max_time;
	
	CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath: @"strokeEnd"];
	strokeAnimation.fromValue = [NSNumber numberWithFloat: fraction];
	strokeAnimation.toValue = [NSNumber numberWithFloat: 0.0f];
	strokeAnimation.duration = self.current_time;
	strokeAnimation.removedOnCompletion = NO;
	
	[self.progressBar addAnimation: strokeAnimation forKey: @"strokeEnd"];
	
	CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath: @"strokeColor"];
	colorAnimation.fromValue = (__bridge id _Nullable) (CGColorCreateSRGB(1 - fraction, fraction, 0, 0.5 + fraction / 2));
	colorAnimation.toValue = (__bridge id _Nullable) (CGColorCreateSRGB(1, 0, 0, 0.5));
	colorAnimation.duration = self.current_time;
	colorAnimation.removedOnCompletion = NO;
	
	[self.progressBar addAnimation: colorAnimation forKey: @"strokeColor"];
	
}

- (void)setup
{
	self.progressBar = [CAShapeLayer layer];
	self.progressBar.strokeColor = [UIColor clearColor].CGColor;
	self.progressBar.fillColor = [UIColor clearColor].CGColor;
	[self.progressBar setBackgroundColor: [UIColor clearColor].CGColor];
	
	[self.layer addSublayer: self.progressBar];
}

- (void)awakeFromNib
{
	[super awakeFromNib];
  [self setup];
}
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
  }
  return self;
}


@end
