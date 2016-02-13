#import <Foundation/Foundation.h>


@interface NSMutableArray (Queue)

- (void) enqueue: (id)item;
- (id) dequeue;
- (id) peek;

@end