//
//  WipeAwayView.h
//  WipeAway
//
//  Created by Craig on 12/6/10.
//

#import <UIKit/UIKit.h>

@interface WipeAwayView : UIView {

	CGPoint		location;
	CGImageRef	imageRef;
	UIImage		*eraser;
	BOOL		wipingInProgress;
	UIColor		*maskColor;
	CGFloat		eraseSpeed;
	
}

- (void)newMaskWithColor:(UIColor *)color eraseSpeed:(CGFloat)speed;

@end
