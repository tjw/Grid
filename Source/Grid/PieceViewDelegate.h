
@class PieceView;

@protocol PieceViewDelegate <NSObject>

- (void)pieceView:(PieceView *)pieceView clicked:(NSEvent *)mouseDown;

@end