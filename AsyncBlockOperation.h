//
//  AsyncBlockOperation.h
//
//  Created by XibXor.com on 4/29/13.
//
//

#import <Foundation/Foundation.h>

@class AsyncBlockOperation;
typedef void (^td_async_block_operation_opblock)(AsyncBlockOperation* op);



@interface AsyncBlockOperation : NSOperation

@property (atomic, assign) BOOL isExecuting;
@property (atomic, assign) BOOL isFinished;

@property (atomic, strong) td_async_block_operation_opblock executionBlock;




+ (id) blockOperationWithBlock:(td_async_block_operation_opblock) block;

- (id) initWithBlock:(td_async_block_operation_opblock) block;
- (void) complete;


@end
