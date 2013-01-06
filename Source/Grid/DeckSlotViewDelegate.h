
@class DeckSlotView;

@protocol DeckSlotViewDelegate <NSObject>

- (void)deckSlotView:(DeckSlotView *)deckSlotView clicked:(NSEvent *)mouseDown;

@end