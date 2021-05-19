//
//  KeyView.m
//  TrainCount
//
//  Created by Max Ivanov on 15.05.2021.
//

#import "KeyView.h"
#define Normal_Color CGColorCreateSRGB(0.3, .3, .3, 1)
#define Highlighted_Color CGColorCreateSRGB(0.6, .6, .6, 1)
#define Text_Color CGColorCreateSRGB(1, 1, 1, .9)

#define Disabled_Color CGColorCreateSRGB(0.45, .45, .45, 1)
#define Disabled_Text_Color CGColorCreateSRGB(.7, .7, .7, 1)

@interface KeyView() {
	BOOL isEnabled;
}

@property (strong, nonatomic) CAShapeLayer *shape;
@property (strong) CATextLayer *textLayer;

@property (strong) UILabel *keyLabel;

@property SEL action;
@property id target;

@end

@implementation KeyView

- (void)drawRect: (CGRect) rect
{
	[self setShape];
 
	CGRect textRect;
	
	textRect.size = [[self.keyLabel attributedText] size];
	textRect.origin = CGPointMake((self.bounds.size.width - textRect.size.width) / 2 , (self.bounds.size.height - textRect.size.height) / 2);

	[self.keyLabel setFrame: textRect];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}

-(void)setup
{
	self.shape = [CAShapeLayer layer];
	
	self.shape.strokeColor = [UIColor clearColor].CGColor;
	self.shape.fillColor = Normal_Color;
	
	[self.layer addSublayer: self.shape];
	
	self.keyLabel = [[UILabel alloc] initWithFrame: self.frame];
	
	[self addSubview: self.keyLabel];

	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTap:)];

	[self addGestureRecognizer: tapGesture];
}

- (void)setText: (NSString *) input
{
	_text = input;
	UIFont *textFont = [UIFont preferredFontForTextStyle: UIFontTextStyleBody];
	textFont = [textFont fontWithSize: 30];
	
	
	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.alignment = NSTextAlignmentCenter;

	NSMutableAttributedString *text = [[NSMutableAttributedString alloc]
																		 initWithString: [NSString stringWithFormat: @"%@", input]
																		 attributes: @{
																			 NSFontAttributeName: textFont,
																			 NSParagraphStyleAttributeName: style,
																			 NSBackgroundColorAttributeName: [UIColor clearColor],
																			 NSForegroundColorAttributeName: [UIColor redColor]
																		 }];
	[self.keyLabel setAttributedText: text];
}

-(void)setShape
{
	int min_size = MIN(self.bounds.size.width, self.bounds.size.height);
	self.shape.lineWidth = MAX(min_size / 40, 1);
	CGMutablePathRef circle = CGPathCreateMutable();
	CGPathAddArc(circle, 0, self.bounds.size.width / 2, self.bounds.size.height / 2,
								 (min_size / 2 - self.shape.lineWidth), 0, M_PI * 2, YES);
		
	self.shape.path = circle;

}

-(void)addTarget: (id) target setAction: (SEL)action
{
	self.action = action;
	self.target = target;
}
-(void)colorAnimationFrom: (CGColorRef) startingColor to: (CGColorRef) endingColor
{
	CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath: @"fillColor"];
	colorAnimation.fromValue = (__bridge id _Nullable) (startingColor);
	colorAnimation.toValue = (__bridge id _Nullable) (endingColor);
	colorAnimation.duration = 0.1f;
	colorAnimation.autoreverses = NO;
	colorAnimation.removedOnCompletion = YES;
	
	[self.shape addAnimation: colorAnimation forKey: @"fillColor"];
}

-(void)handleTap: (UITapGestureRecognizer *) sender
{
	if(!isEnabled) {
		return;
	}
	if(CGPathContainsPoint(self.shape.path, 0, [sender locationInView: self], YES)) {
		
		[self.target performSelector: self.action withObject: self];
		[self colorAnimationFrom: Normal_Color to: Highlighted_Color];
	}
}


- (void)setIsEnabled:(BOOL)enabled
{
	isEnabled = enabled;
	if(isEnabled) {
		//[self.shape setBackgroundColor: Normal_Color];
		[self.shape setFillColor: Normal_Color];
		[self.keyLabel setTextColor: [UIColor colorWithCGColor: Text_Color]];
	} else {
		//[self.shape setBackgroundColor: Disabled_Color];
		[self.shape setFillColor: Disabled_Color];
		[self.keyLabel setTextColor: [UIColor colorWithCGColor: Disabled_Text_Color]];
	}
}

@end
