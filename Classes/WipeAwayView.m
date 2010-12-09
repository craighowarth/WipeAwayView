//
//  WipeAwayView.m
//  WipeAway
//
//  Created by Craig on 12/6/10.
//
//  See http://craigcoded.com/2010/12/08/erase-top-uiview-to-reveal-content-underneath/ for full explanation
//

#import "WipeAwayView.h"

@implementation WipeAwayView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		wipingInProgress = NO;
		eraser = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"eraser" ofType:@"png"]];
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)newMaskWithColor:(UIColor *)color eraseSpeed:(CGFloat)speed {
	
	wipingInProgress = NO;
	
	eraseSpeed = speed;
	
	[color retain];
	[maskColor release];
	maskColor = color;
	
	[self setNeedsDisplay];
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	wipingInProgress = YES;
	
}
	
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if ([touches count] == 1) {
		UITouch *touch = [touches anyObject];
		location = [touch locationInView:self];
		location.x -= [eraser size].width/2;
		location.y -= [eraser size].width/2;
		[self setNeedsDisplay];
	}
	
}

- (void)drawRect:(CGRect)rect {

	CGContextRef context = UIGraphicsGetCurrentContext();

	if (wipingInProgress) {
		if (imageRef) {
			// Restore the screen that was previously saved
			CGContextTranslateCTM(context, 0, rect.size.height);
			CGContextScaleCTM(context, 1.0, -1.0);
			
			CGContextDrawImage(context, rect, imageRef);
			CGImageRelease(imageRef);

			CGContextTranslateCTM(context, 0, rect.size.height);
			CGContextScaleCTM(context, 1.0, -1.0);
		}

		// Erase the background -- raise the alpha to clear more away with eash swipe
		[eraser drawAtPoint:location blendMode:kCGBlendModeDestinationOut alpha:eraseSpeed];
	} else {
		// First time in, we start with a solid color
		CGContextSetFillColorWithColor( context, maskColor.CGColor );
		CGContextFillRect( context, rect );
	}

	// Save the screen to restore next time around
	imageRef = CGBitmapContextCreateImage(context);
	
}

- (void)dealloc {
	[maskColor release];
	[eraser release];
    [super dealloc];
}


@end
