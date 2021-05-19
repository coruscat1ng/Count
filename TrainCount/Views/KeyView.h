//
//  KeyView.h
//  TrainCount
//
//  Created by Max Ivanov on 15.05.2021.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface KeyView : UIView

@property (nonatomic, weak) NSString *text;

-(void)addTarget: (id) target setAction: (SEL)action;
- (void)setIsEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
