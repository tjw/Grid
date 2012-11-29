
@class SquareView;

@protocol SquareViewDelegate <NSObject>

- (void)squareView:(SquareView *)squareView clicked:(NSEvent *)mouseDown;

@end