//
//  GPUComputeTask.m
//  NoiseLab
//
//  Created by Brent Gulanowski on 2018-06-20.
//  Copyright © 2018 Lichen Labs. All rights reserved.
//

#import "GPUComputeTask.h"

@interface GPUComputeTask ()

@property (nonatomic, readonly) id<MTLComputePipelineState> pipeline;

@end

@implementation GPUComputeTask

@dynamic threadCount;

- (instancetype)initWithLibrary:(id<MTLLibrary>)library kernelFunction:(NSString *)kernelName {
    self = [super init];
    if (self) {
        
        id<MTLFunction> kernelFunction = [library newFunctionWithName:kernelName];
        NSError *error;
        _pipeline = [library.device newComputePipelineStateWithFunction:kernelFunction error:&error];
        if(!_pipeline) {
            NSLog(@"Failed to create compute pipeline state: %@", error);
            return nil;
        }
        
        _threadgroupSize = MTLSizeMake(16, 16, 1);
        _shouldRun = YES;
    }
    return self;
}

- (void)encodeTaskWithCommandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    
    id<MTLComputeCommandEncoder> encoder = [commandBuffer computeCommandEncoder];
    [encoder setComputePipelineState:self.pipeline];
    [self configureEncoder:encoder];
    [encoder endEncoding];
}

- (void)configureEncoder:(id<MTLComputeCommandEncoder>)encoder {
    [self configureEncoderResources:encoder];
    [self dispatchWithEncoder:encoder];
}

- (void)configureEncoderResources:(id<MTLComputeCommandEncoder>)encoder {}

- (void)dispatchWithEncoder:(id<MTLComputeCommandEncoder>)encoder {
    [encoder dispatchThreads:self.threadCount threadsPerThreadgroup:self.threadgroupSize];
    _hasRun = YES;
}

@end
