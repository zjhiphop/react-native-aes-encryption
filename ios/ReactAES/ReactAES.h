//
//  ReactAES.h
//  ReactAES
//
//  Created by Yungui Dai on 16/6/19.
//  Copyright © 2016年 fanday. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<React/RCTBridgeModule.h>) // React Native >= 0.40
#import <React/RCTBridgeModule.h>
#else // React Native < 0.40
#import "RCTBridgeModule.h"
#endif


@interface ReactAES : NSObject <RCTBridgeModule>

@end
