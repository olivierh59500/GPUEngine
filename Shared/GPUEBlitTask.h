//
//  GPUEBlitTask.h
//  Noise Lab-Mac
//
//  Created by Brent Gulanowski on 2018-06-20.
//  Copyright © 2018 Lichen Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GPUETask.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPUEBlitTask : NSObject<GPUETask>

@property (nonatomic, readonly) id<MTLResource> resource;

- (instancetype)initWithResource:(id<MTLResource>)resource;
- (void)performBlitWithEncoder:(id<MTLBlitCommandEncoder>)encoder;

@end

NS_ASSUME_NONNULL_END
