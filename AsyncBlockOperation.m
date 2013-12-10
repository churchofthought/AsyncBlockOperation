//
//  AsyncBlockOperation.m
//
//  Created by XibXor.com on 4/29/13.
//
//

#import "AsyncBlockOperation.h"

@interface AsyncBlockOperation()
@end


@implementation AsyncBlockOperation

+ (id) blockOperationWithBlock:(td_async_block_operation_opblock) block {
    return [[self alloc] initWithBlock:block];
}


- (id) initWithBlock:(td_async_block_operation_opblock) block {
    self = [self init];
    _executionBlock = block;

    return self;
}

- (void) start {
    if (_executionBlock){
        // set status properties and fire off KVO
        [self setIsRunning:YES];
        
        // execute the block, passing self for completion
        _executionBlock(self);
        
        // release the execution block after execution
        _executionBlock = nil;
    }else {
        [self complete];
    }
}

- (void) complete {
    // release the execution block
    _executionBlock = nil;
    
    // set status properties and fire off KVO
    [self setIsRunning:NO];
}

- (void) setIsRunning: (BOOL) isRunning {
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.isFinished = !(self.isExecuting = isRunning);
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
}

@end
