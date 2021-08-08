//
//  ASReuseManagerItemProtocol.h
//  ASUtil
//
//  Created by Achilles on 17/7/15.
//  Copyright (c) 2015 Achilles. All rights reserved.
//
//
#import <Foundation/Foundation.h>

@protocol ASReuseManagerItemProtocol <NSObject>
-(void)onPrepareForReuse:(id)sender;
@end

