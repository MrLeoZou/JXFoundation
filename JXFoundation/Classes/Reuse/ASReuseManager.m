//
//  ASReuseManager.m
//  ASUIKit
//
//  Created by Achilles on 17/7/15.
//  Copyright (c) 2015 Achilles. All rights reserved.
//

#import "ASReuseManager.h"

@interface ASReuseManager()
{
    Class _itemClass;
}
@property(nonatomic, strong)NSMutableSet* busyItems;
@property(nonatomic, strong)NSMutableSet* leisureItems;
@end

@implementation ASReuseManager

#pragma mark --------------------- life cycle ---------------------
-(instancetype)initWithCls:(Class)cls
{
    if(NULL == cls || ![cls conformsToProtocol:@protocol(ASReuseManagerItemProtocol)])
        return nil;
    
    self = [super init];
    if(self)
    {
        _busyItems = [NSMutableSet set];
        _leisureItems = [NSMutableSet set];
        _itemClass = cls;
    }
    return self;
}

#pragma mark --------------------- operation ---------------------
-(id<ASReuseManagerItemProtocol>)dequeueReusableItem
{
    assert(_itemClass);
    id item = [_leisureItems anyObject];
    if(item)
    {
        [_leisureItems removeObject:item];
        [_busyItems addObject:item];
        [item onPrepareForReuse:self];
    }
    else
    {
        item = [self _createAnItem];
        [_busyItems addObject:item];
    }
    return item;
}

-(void)enqueueReusableItem:(id<ASReuseManagerItemProtocol>)item
{
    [_busyItems removeObject:item];
    [_leisureItems addObject:item];
}

-(void)reQueueWithBusyOperation:(ASReuseManagerCheckItemOp)op
{
    if(NULL == op)
        return;
    
    
    NSMutableSet* copy = [NSMutableSet setWithSet:_busyItems];
    
    [copy enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop)
    {
        if(!op(obj))
        {
            [self.busyItems removeObject:obj];
            [self.leisureItems addObject:obj];
        }
    }];
}

-(void)cleanLeisureItem
{
    if (_willRemoveOp)
    {
        for (id<ASReuseManagerItemProtocol> item in _leisureItems)
        {
            _willRemoveOp(item);
        }
    }
    [_leisureItems removeAllObjects];
}

#pragma mark ------------------------- accessor -------------------------
-(Class)itemClass
{
    return _itemClass;
}

-(NSUInteger)busyItemCount
{
    return [_busyItems count];
}

-(NSUInteger)leisureItemCount
{
    return [_leisureItems count];
}

-(NSUInteger)cacheItemCount
{
    return [self busyItemCount] + [self leisureItemCount];
}

#pragma mark - private
-(id<ASReuseManagerItemProtocol>)_createAnItem
{
    id<ASReuseManagerItemProtocol> item = nil;
    if(_createOp)
    {
        item = _createOp();
    }
    else
    {
        item = [_itemClass new];
    }
    return item;
}

@end
