AsyncBlockOperation
===================

Create asynchronous operations using blocks.


NSBlockOperation's blockOperationWithBlock method is immensely powerful. It allows us to create a synchronous operation from a block. However, it does not give us the ability to create an asynchronous operation.

If we need an asynchronous operation for a small task, it might be tempting to subclass NSOperation. Usually though, subclassing NSOperation is overkill.

I cooked up a class called AsyncBlockOperation. It's very similar to NSBlockOperation with one caveat; the block you pass to it receives one argument, a reference to the AsyncBlockOperation for the block. When your block is done with its task, it must call [op complete]

Here's an example of its use:


    NSOperation* asyncOp = [AsyncBlockOperation blockOperationWithBlock:^(AsyncBlockOperation* op) {
        NSLog(@"starting op");
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (op.isCancelled){
                return [op complete];
            }
            
            NSLog(@"2 seconds have passed");
            NSLog(@"calling [op complete]");
            [op complete];
        });
        NSLog(@"op block returns but op isn't finished");
    }];
    asyncOp.completionBlock = ^{
        NSLog(@"completion block called!");
    };
    [asyncOp start];

The output will be:


2013-04-29 22:51:57.417 Experiments[5795:11603] starting op


2013-04-29 22:51:57.419 Experiments[5795:11603] op block returns but op isn't finished


2013-04-29 22:51:59.420 Experiments[5795:11603] 2 seconds have passed


2013-04-29 22:51:59.421 Experiments[5795:11603] calling [op complete]


2013-04-29 22:51:59.422 Experiments[5795:12e03] completion block called!
