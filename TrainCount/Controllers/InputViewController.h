//
//  InputViewController.h
//  TrainCount
//
//  Created by Max Ivanov on 15.05.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InputViewControllerDelegate

	-(void)textChanged;
	-(void)textEntered;
	
@end

@interface InputViewController : UIViewController

-(void)clearInput;

@property id<InputViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableString *enteredNumber;

@end

NS_ASSUME_NONNULL_END
