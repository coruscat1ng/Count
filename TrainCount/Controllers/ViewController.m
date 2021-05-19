//
//  ViewController.m
//  TrainCount
//
//  Created by Max Ivanov on 14.05.2021.
//

#import "ViewController.h"
#import "CircularBarView.h"
#import "InputViewController.h"

#define Right_Color CGColorCreateSRGB(0, 1, 0, .5)
#define Wrong_Color CGColorCreateSRGB(1, 0, 0, .5)

#define ANIMATION_TIME 0.8

#define MAX_SECONDS 16
#define ADD_SECONDS 3
#define PENALTY 1
#define INTERVAl 0.1
#define DELTA 0.1

enum Operation {
	Summ,
	Multiplication,
	Division,
	Difference,
	Operations_Number
};

@interface ViewController () <InputViewControllerDelegate>
{
	NSTimer *timer;
	float seconds;
	int right_answer;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) InputViewController *inputViewController;


@property (weak, readwrite) IBOutlet UILabel *formula;
@property (weak) IBOutlet UILabel *answer;

@property (weak) IBOutlet CircularBarView *scoreBar;

@property (weak) IBOutlet UIButton *restartButton;

@end

@implementation ViewController

- (IBAction)restartGame:(id)sender
{
	[sender setHidden: YES];
	[self.formula setHidden: NO];
	[self.answer setEnabled: YES];
	
	[self startGame];
	[self.scoreBar setNeedsDisplay];
	
	[self add: self.inputViewController];
	
	[self.answer setText: @""];
	[self.inputViewController clearInput];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.answer.layer setBorderColor: [UIColor clearColor].CGColor];
	[self.formula.layer setBorderColor: self.view.backgroundColor.CGColor];
	[self.inputViewController.view.layer setBorderColor: [UIColor clearColor].CGColor];
	
	[self.answer setText: @"train your counting!"];
	[self.formula setText: @"CountGame"];
	
	[self.restartButton setHidden: NO];
	
}

- (void)checkAnswer
{
	if(seconds < DELTA + INTERVAl) {
		return;
	}
	if(self.answer.text.intValue == right_answer) {

		[self animate: self.inputViewController.view.layer from: self.view.backgroundColor.CGColor to: Right_Color];
		[self generateProblem];
		
		
		seconds > (MAX_SECONDS - PENALTY) ? (seconds = MAX_SECONDS) : (seconds += ADD_SECONDS);
		
		self.scoreBar.rights++;
		
	} else {
		[self animate: self.inputViewController.view.layer from: self.view.backgroundColor.CGColor to: Wrong_Color];
		seconds < PENALTY ? (seconds = 0) : (seconds -= PENALTY);
		self.scoreBar.wrongs++;
	}
	
	self.scoreBar.current_time = seconds;
	[self.answer setText: @""];
	[self.inputViewController clearInput];
	[self.scoreBar setNeedsDisplay];
	[self.scoreBar animate];
}


- (void)updateTimer
{
	if(seconds < DELTA + INTERVAl) {
		[timer invalidate];
		[self endGame];
	}
	
	seconds -= INTERVAl;
}

-(void)startGame
{
	self.scoreBar.max_time = self.scoreBar.current_time = seconds = MAX_SECONDS + DELTA;
	self.scoreBar.rights = 0;
	self.scoreBar.wrongs = 0;
	
	[self generateProblem];
	
	timer = [NSTimer scheduledTimerWithTimeInterval: INTERVAl
																					 target: self
																				 selector: @selector (updateTimer)
																				 userInfo: nil
																					repeats: YES];
	[self.scoreBar animate];
	
	[[NSRunLoop currentRunLoop]addTimer: timer forMode: NSRunLoopCommonModes];
}

-(void)endGame
{
	self.scoreBar.current_time = 0;
	[self.scoreBar setNeedsDisplay];
	
	[self.answer setText: @"train your counting!"];
	[self.formula setText: @"CountGame"];
	[self.restartButton setHidden: NO];
	
	[self remove: self.inputViewController];
}


-(void)generateProblem
{
	enum Operation operation = arc4random() % Operations_Number;
	NSString *expression;
	int left, right;
	
	switch(operation) {
		case Summ:
			left = arc4random() % 200 + 1;
			right = arc4random() % 200 + 1;
			right_answer = left + right;
			expression = [NSString stringWithFormat: @"%d + %d", left, right];
			break;
		case Difference:
			left = arc4random() % 200 + 1;
			right = arc4random() % 200 + 1;
			if(left < right) {
				int temp = left;
				left = right;
				right = temp;
			}
			right_answer = left - right;
			expression = [NSString stringWithFormat: @"%d - %d", left, right];
			break;
		case Division:
			left = arc4random() % 200 + 5;
			right = arc4random() % 90 + 1;
			if(left < right) {
				int temp = left;
				left = right;
				right = temp;
			}
			right_answer = left / right + 1;
			left = right_answer * right;
			
			expression = [NSString stringWithFormat: @"%d ÷ %d", left, right];
			break;
		case Multiplication:
			left = arc4random() % 30 + 1;
			right = arc4random() % 30 + 1;
			right_answer = left * right;
			expression = [NSString stringWithFormat: @"%d · %d", left, right];
			break;
		case Operations_Number:
			break;
	}
	
	self.formula.text = [NSString stringWithFormat: @"%@ = ?", expression];
}

-(InputViewController *)inputViewController
{
	if(!_inputViewController) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: NSBundle.mainBundle];
		_inputViewController = [storyboard instantiateViewControllerWithIdentifier: @"InputViewController"];
		_inputViewController.view.frame = self.containerView.frame;
		_inputViewController.delegate = self;
	}
	return _inputViewController;
}


-(void)remove: (UIViewController *) controller
{
	[controller willMoveToParentViewController: 0];
	[controller.view removeFromSuperview];
	[controller removeFromParentViewController];
}
-(void)add: (UIViewController *) controller
{
	[self addChildViewController: controller];
	[self.view addSubview: controller.view];
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
} 


- (void)textChanged {
	[self.answer setText: [self.inputViewController enteredNumber]];

}

- (void)textEntered {
	[self.answer setText: [self.inputViewController enteredNumber]];
	[self checkAnswer];
}

-(void)animate: (CALayer *) layer from: (CGColorRef) startingColor to: (CGColorRef) endingColor
{
	CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath: @"backgroundColor"];
	colorAnimation.fromValue = (__bridge id _Nullable) (startingColor);
	colorAnimation.toValue = (__bridge id _Nullable) (endingColor);
	colorAnimation.duration = ANIMATION_TIME / 2;
	colorAnimation.autoreverses = YES;
	colorAnimation.removedOnCompletion = YES;
	
	[layer addAnimation: colorAnimation forKey: @"backgroundColor"];
	
	CABasicAnimation *cornersAnimation = [CABasicAnimation animationWithKeyPath: @"cornerRadius"];
	cornersAnimation.toValue = [NSNumber numberWithFloat: MIN(layer.frame.size.height, layer.frame.size.width) / 4];
	cornersAnimation.fromValue = [NSNumber numberWithFloat: MIN(layer.frame.size.height, layer.frame.size.width) / 2];
	cornersAnimation.duration = ANIMATION_TIME / 2;
	cornersAnimation.autoreverses = YES;
	cornersAnimation.removedOnCompletion = YES;
	
	[layer addAnimation: cornersAnimation forKey: @"corneRadius"];
	
	
	CABasicAnimation *bordersAnimation = [CABasicAnimation animationWithKeyPath: @"borderWidth"];
	bordersAnimation.fromValue = [NSNumber numberWithFloat: 0];
	bordersAnimation.toValue = [NSNumber numberWithFloat: MIN(layer.frame.size.height, layer.frame.size.width) / 2];
	bordersAnimation.duration = ANIMATION_TIME;
	bordersAnimation.autoreverses = NO;
	bordersAnimation.removedOnCompletion = YES;
	
	[layer addAnimation: bordersAnimation forKey: @"borderWidth"];

}



@end
