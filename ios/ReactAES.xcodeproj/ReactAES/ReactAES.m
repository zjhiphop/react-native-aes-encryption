//
//  ReactAES.m
//  ReactAES
//
//  Created by Yungui Dai on 16/6/19.
//  Copyright © 2016年 fanday. All rights reserved.
//

#import "ReactAES.h"

#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSData+Base64.m"
#import "NSData+AES.h"



@implementation ReactAES


RCT_EXPORT_MODULE(ReactAES);

RCT_EXPORT_METHOD(encrypt:(NSString *)message key:(NSString *)key resolver:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject) {

    NSData *commandData = [message dataUsingEncoding:NSUTF8StringEncoding];
    EncInfo *encInfo = [commandData AES128EncryptedDataWithKey:key iv:nil];
    NSString *clearText=[commandData getHexadecimalString];
    

    NSMutableData *encryptedData = [NSMutableData data];
    [encryptedData appendData: encInfo.iV];
    [encryptedData appendData: encInfo.cipherBytes];
    NSString *base64EncodedString = [NSString base64StringFromData:encryptedData length:[encryptedData length]];

        if(base64EncodedString){
        resolve(base64EncodedString);
    }else{
        reject(@"-1", @"encrypt failed", nil);
    }
    
}


RCT_EXPORT_METHOD(decrypt:(NSString *)message key:(NSString *)key iv:(NSString *)iv resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSData *data = [NSData base64DataFromString:message];
    NSData *iv2 = [NSData base64DataFromString:iv];

    EncInfo *encInfo = [data AES128DecryptedDataWithKey:key iv:[iv2 getHexadecimalString]];
    NSString * decryptedText = [[NSString alloc] initWithData:encInfo.cipherBytes encoding:NSASCIIStringEncoding];
    if(decryptedText){
        resolve(decryptedText);
    }else{
        reject(@"-1", @"decrypt failed", nil);
    }
    }

@end
