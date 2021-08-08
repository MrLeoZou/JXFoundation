//
//  ASReuseManager.h
//  ASUIKit
//
//  Created by Achilles on 17/7/15.
//  Copyright (c) 2015 Achilles. All rights reserved.
//


#import "ASReuseManagerItemProtocol.h"

typedef id<ASReuseManagerItemProtocol>(^ASReuseManagerCreateItemOp)(void);              // 创建对象
typedef void(^ASReuseManagerWillRemoveItemOp)(id<ASReuseManagerItemProtocol> item);         // 销毁对象
typedef BOOL(^ASReuseManagerCheckItemOp)(id<ASReuseManagerItemProtocol> item);          // 检查对象是否可被复用


@interface ASReuseManager : NSObject
#pragma mark --------------------- life cycle ---------------------
// create a manager for reuse instance of cls
-(instancetype)initWithCls:(Class)cls;

#pragma mark --------------------- config ---------------------
// defaulty, init an object directly
// set this method to init with custom method or do something at init time
@property(copy)ASReuseManagerCreateItemOp createOp;

// call when remove an object in leisureMap.
// The object will always remove from leisureMap.
@property(copy)ASReuseManagerWillRemoveItemOp willRemoveOp;

#pragma mark --------------------- operation ---------------------
// get an leisure item and move it to busy set
-(id<ASReuseManagerItemProtocol>)dequeueReusableItem;

// move an item from busy set to leisure set
-(void)enqueueReusableItem:(id<ASReuseManagerItemProtocol>)item;

// move item from busy set to leisure set batchly
-(void)reQueueWithBusyOperation:(ASReuseManagerCheckItemOp)op;

// clean lesire set
-(void)cleanLeisureItem;

#pragma mark ------------------------- accessor -------------------------
// reuse class
-(Class)itemClass;

/** cache = busy + leisure */
-(NSUInteger)busyItemCount;
-(NSUInteger)leisureItemCount;
-(NSUInteger)cacheItemCount;

@end
