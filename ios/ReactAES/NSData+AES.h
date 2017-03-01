/**
 http://mythosil.hatenablog.com/entry/20111017/1318873155
 http://blog.dealforest.net/2012/03/ios-android-per-aes-crypt-connection/
 */
#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>

@interface EncInfo : NSObject
{
    
//    NSData *iV;
//    NSData *cipherBytes;
//    NSData *key;
//    NSString *ivHex;
}
@property(nonatomic,strong)NSData *iV;
@property(nonatomic,strong)NSData *key;
@property(nonatomic,strong)NSData *cipherBytes;
@end

@interface NSData (AES)

- (EncInfo *)AES128EncryptedDataWithKey:(NSString *)key iv:(NSString *)iv;
- (EncInfo *)AES128DecryptedDataWithKey:(NSString *)key iv:(NSString *)iv;
- (NSString *)getHexadecimalString;
@end
