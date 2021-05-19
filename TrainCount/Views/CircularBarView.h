//
//  circular_bar.h
//  count
//
//  Created by Max Ivanov on 30.04.2021.
//

#ifndef circular_bar_h
#define circular_bar_h
#import <UIKit/UIKit.h>

@interface CircularBarView: UIView

@property(nonatomic) int rights;
@property(nonatomic) int wrongs;

@property(nonatomic) float current_time;
@property(nonatomic) float max_time;

-(void)animate;
@end

#endif /* circular_bar_h */
