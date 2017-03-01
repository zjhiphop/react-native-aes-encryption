#import "NSData+AES.h"
#import "NSData+Base64.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation EncInfo

@end

@implementation NSData (AES)

#pragma mark - Public Methods



- (EncInfo *)AES128EncryptedDataWithKey:(NSString *)key iv:(NSString *)iv
{
    EncInfo *aesModel = [[EncInfo alloc]init];
    aesModel.key = [self dataFromHexString:key];
    if(iv != nil){
        aesModel.iV = [self dataFromHexString:iv];
    }else{
        aesModel.iV = [self generateRandomIV:16];

    }
    
    return [self AES128OperationWithEncriptionMode:kCCEncrypt encInfo:aesModel];
}
- (EncInfo *)AES128DecryptedDataWithKey:(NSString *)key iv:(NSString *)iv
{
    EncInfo *aesModel = [[EncInfo alloc]init];
    aesModel.key = [self dataFromHexString:key];
    aesModel.iV = [self dataFromHexString:iv];
    return [self AES128OperationWithEncriptionMode:kCCDecrypt encInfo:aesModel];
}

- (EncInfo *)AES128DecryptedDataWithAesEncInfo:(EncInfo*)aesModel
{
    return [self AES128OperationWithEncriptionMode:kCCDecrypt encInfo:aesModel];
}


#pragma mark - Private Method
- (EncInfo *)AES128OperationWithEncriptionMode:(CCOperation)operation encInfo:(EncInfo*)aesModel {
    
    
    CCCryptorRef cryptor = NULL;
    // 1. Create a cryptographic context.
    CCCryptorStatus status = CCCryptorCreateWithMode(operation, kCCModeCFB, kCCAlgorithmAES, ccNoPadding, [aesModel.iV bytes], [aesModel.key bytes], [aesModel.key length], NULL, 0, 0, kCCModeOptionCTR_BE, &cryptor);
       NSAssert(status == kCCSuccess, @"Failed to create a cryptographic context.");
    
    NSMutableData *retData = [NSMutableData new];
    
    // 2. Encrypt or decrypt data.
    NSMutableData *buffer = [NSMutableData data];
    [buffer setLength:CCCryptorGetOutputLength(cryptor, [self length], true)]; // We'll reuse the buffer in -finish
    
    size_t dataOutMoved;
    status = CCCryptorUpdate(cryptor, self.bytes, self.length, buffer.mutableBytes, buffer.length, &dataOutMoved);
    NSAssert(status == kCCSuccess, @"Failed to encrypt or decrypt data");
    [retData appendData:[buffer subdataWithRange:NSMakeRange(0, dataOutMoved)]];
    
    // 3. Finish the encrypt or decrypt operation.
    status = CCCryptorFinal(cryptor, buffer.mutableBytes, buffer.length, &dataOutMoved);
    NSAssert(status == kCCSuccess, @"Failed to finish the encrypt or decrypt operation");
    [retData appendData:[buffer subdataWithRange:NSMakeRange(0, dataOutMoved)]];
    CCCryptorRelease(cryptor);
    aesModel.cipherBytes=retData;
    return aesModel;
}
- (NSData *)dataFromHexString:(NSString *)string
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    return stringData;
}
-(NSData*)createRandomNSData
{
    NSMutableData* theData = [NSMutableData dataWithCapacity:16];
    u_int32_t randomBits = arc4random_uniform(232354236);
    [theData appendBytes:(void*)&randomBits length:16];
    return theData;
}

- (NSData *)random128BitAESKey {
    unsigned char buf[16];
    arc4random_buf(buf, sizeof(buf));
    return [NSData dataWithBytes:buf length:sizeof(buf)];
}

//function to generate random string of given length.
//random strings are used as IV
- (NSData *)generateRandomIV:(size_t)length
{
    NSMutableData *data = [NSMutableData dataWithLength:length];
    int output = SecRandomCopyBytes(kSecRandomDefault,
                                    length,
                                    data.mutableBytes);
    NSAssert(output == 0, @"error generating random bytes: %d",
             errno);
    
    return data;
}

- (NSString *)getHexadecimalString {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

@end
