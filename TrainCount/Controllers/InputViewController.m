//
//  InputViewController.m
//  TrainCount
//
//  Created by Max Ivanov on 15.05.2021.
//

#import "InputViewController.h"
#import "KeyView.h"

enum KeyCodes {
	One, Two, Three,
	For, Five, Six,
	Seven, Eight, Nine,
	Delete, Zero, Done,
	KeyCodesSize
};

NSString *KeyNames[KeyCodesSize] = {
	[One] = @"1", [Two] = @"2", [Three] = @"3",
	[For] = @"4", [Five] = @"5", [Six] = @"6",
	[Seven] = @"7", [Eight] = @"8", [Nine] = @"9",
	[Delete] = @"x", [Zero] = @"0", [Done] = @"=",
};

@interface InputViewController ()

@property (strong) KeyView *doneButton;
@property (strong) KeyView *deleteButton;

@end

@implementation InputViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIStackView *view = (UIStackView *) self.view;
	[view setAxis: UILayoutConstraintAxisVertical];
	[view setBaselineRelativeArrangement: NO];
	[view setAlignment: UIStackViewAlignmentFill];
	[view setDistribution: UIStackViewDistributionFillEqually];
	[view setSpacing: 5];
	[view setTranslatesAutoresizingMaskIntoConstraints: YES];
	
	for(int i = 0; i < 4; i++) {
		UIStackView *row = [[UIStackView alloc] init];
		[row setAxis: UILayoutConstraintAxisHorizontal];
		[row setBaselineRelativeArrangement: NO];
		[row setAlignment: UIStackViewAlignmentFill];
		[row setDistribution: UIStackViewDistributionFillEqually];
		[row setTranslatesAutoresizingMaskIntoConstraints: YES];
		for(int j = 0; j < 3; j++) {
			KeyView *temp = [[KeyView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
			enum KeyCodes keyCode = 3 * i + j;
			temp.text = KeyNames[keyCode];
			switch (keyCode) {
				case Done:
					[temp addTarget: self setAction: @selector(enterText:)];
					[temp setIsEnabled: NO];
					self.doneButton = temp;
					break;
				case Delete:
					[temp addTarget: self setAction: @selector(deleteCharacter:)];
					[temp setIsEnabled: NO];
					self.deleteButton = temp;
					break;
					
				default:
					[temp addTarget: self setAction: @selector(addText:)];
					[temp setIsEnabled: YES];
					break;
			}
			[row addArrangedSubview: temp];
		}
		[view addArrangedSubview: row];
	}
}
-(void)clearInput
{
	[self.enteredNumber deleteCharactersInRange: NSMakeRange(0, [self.enteredNumber length])];
	[self.deleteButton setIsEnabled: NO];
	[self.doneButton setIsEnabled: NO];
}

-(void)addText: (KeyView *) sender
{
	if(![self.enteredNumber length]) {
		[self.deleteButton setIsEnabled: YES];
		[self.doneButton setIsEnabled: YES];
	}
	[self.enteredNumber appendString: sender.text];
	if(self.delegate)
		[self.delegate textChanged];
}
-(void)deleteCharacter: (id) sender
{
	NSUInteger len = [self.enteredNumber length];
	if(len) {
		[self.enteredNumber deleteCharactersInRange: NSMakeRange([self.enteredNumber length] - 1, 1)];
		if(self.delegate)
			[self.delegate textChanged];
	}
	if(len == 1) {
		[self.deleteButton setIsEnabled: NO];
		[self.doneButton setIsEnabled: NO];
	}
}
-(void)enterText: (id) sender
{
	if(self.delegate)
		[self.delegate textEntered];
}

- (NSMutableString *)enteredNumber
{
	if(!_enteredNumber) {
		_enteredNumber = [[NSMutableString alloc] init];
	}
	return _enteredNumber;
}

@end
