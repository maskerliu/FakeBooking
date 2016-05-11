//
//  NSData+DPNetwork.m
//  FakeReservation
//
//  Created by yixin.jiang on 5/11/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import "NSData+DPNetwork.h"

#include <zlib.h>
#import <CommonCrypto/CommonCryptor.h>


id dp_key() {
    static id __key__ = nil;
    if(!__key__) {
        char bytes[] = {0x5c, 0x73, 0x74, 0x75, 0x70, 0x71, 0x6, 0x70, 0x70, 0x3, 0x3, 0x4, 0x6, 0x76, 0x0, 0x70};
        int a = 0x18;
        for (int i = 0; i < 16; i++) {
            char b = (char) (0xFF & bytes[i] ^ a);
            bytes[i] = b;
            a = b;
        }
        __key__ = [[NSString alloc] initWithBytes:bytes length:16 encoding:NSASCIIStringEncoding];
    }
    return __key__;
}

id dp_iv() {
    static id __iv__ = nil;
    if(!__iv__) {
        char bytes[] = {0x0, 0x76, 0x7a, 0xa, 0x3, 0x74, 0x7c, 0xa, 0x5, 0x75, 0x6, 0x5, 0x3, 0x4, 0x2, 0x25};
        int a = 0x61;
        for (int i = 15; i >= 0; i--) {
            char b = (char) (0xFF & bytes[i] ^ a);
            bytes[i] = b;
            a = b;
        }
        __iv__ = [[NSString alloc] initWithBytes:bytes length:16 encoding:NSASCIIStringEncoding];
    }
    return __iv__;
}

@implementation NSData (DPNetwork)

- (NSData *)dp_decodeGZip {
    if ([self length] == 0) return nil;
    
    unsigned full_length = (unsigned int)[self length];
    unsigned half_length = (unsigned int)[self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}

- (NSData *)dp_encodeGZip {
    if ([self length] == 0) return nil;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData:compressed];
}


- (NSData *)dp_encryptWithKey: (NSString *) key iv: (NSString *) iv
{
    // 'key' should be 16 bytes for AES128, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)
    bzero( keyPtr, sizeof(keyPtr) ); // fill with zeroes (for padding)
    // 'iv' is optional, same size as 'key'
    char ivPtr[kCCKeySizeAES128+1];
    bzero( ivPtr, sizeof(ivPtr) );
    
    // fetch key data
    [key getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSASCIIStringEncoding];
    // fetch iv data
    [iv getCString: ivPtr maxLength: sizeof(ivPtr) encoding: NSASCIIStringEncoding];
    
    // encrypts in-place, since this is a mutable data object
    size_t numBytesEncrypted = 0;
    size_t resultLength = ([self length] + kCCKeySizeAES256) & ~(kCCKeySizeAES256 - 1);
    char resultBuffer[resultLength];
    CCCryptorStatus result = CCCrypt( kCCEncrypt, kCCAlgorithmAES128, 0,
                                     keyPtr, kCCKeySizeAES128,
                                     iv == nil ? NULL : ivPtr,
                                     [self bytes], [self length], /* input */
                                     resultBuffer, resultLength, /* output */
                                     &numBytesEncrypted );
    
    if ( result == kCCSuccess )
        return [NSData dataWithBytes:resultBuffer length:numBytesEncrypted];
    else
        return nil;
}

- (NSData *)dp_decryptWithKey: (NSString *) key iv: (NSString *) iv
{
    // 'key' should be 16 bytes for AES128, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)
    bzero( keyPtr, sizeof(keyPtr) ); // fill with zeroes (for padding)
    // 'iv' is optional, same size as 'key'
    char ivPtr[kCCKeySizeAES128+1];
    bzero( ivPtr, sizeof(ivPtr) );
    
    // fetch key data
    [key getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSASCIIStringEncoding];
    // fetch iv data
    [iv getCString: ivPtr maxLength: sizeof(ivPtr) encoding: NSASCIIStringEncoding];
    
    // encrypts in-place, since this is a mutable data object
    size_t numBytesEncrypted = 0;
    size_t resultLength = ([self length] + kCCKeySizeAES256) & ~(kCCKeySizeAES256 - 1);
    char resultBuffer[resultLength];
    bzero( resultBuffer , resultLength );
    CCCryptorStatus result = CCCrypt( kCCDecrypt, kCCAlgorithmAES128, 0,
                                     keyPtr, kCCKeySizeAES128,
                                     iv == nil ? NULL : ivPtr,
                                     [self bytes], [self length], /* input */
                                     resultBuffer, resultLength, /* output */
                                     &numBytesEncrypted );
    
    if ( result == kCCSuccess )
        return [NSData dataWithBytes:resultBuffer length:numBytesEncrypted];
    else if ( resultBuffer[0] ) // compromise for PKCS5 padding
        return [NSData dataWithBytes:resultBuffer length:resultLength];
    else
        return nil;
}


- (NSData *)dp_decodeMobileData {
    NSData *data2 = [self dp_decryptWithKey:dp_key() iv:dp_iv()];
    NSData *data3 = [data2 dp_decodeGZip];
    return data3;
}

- (NSData *)dp_encodeMobileData {
    NSInteger length = [self length];
    NSInteger length16 = length % 16 == 0 ? length : length + (16 - length % 16);
    if(length == length16) {
        NSData *data2 = [self dp_encryptWithKey:dp_key() iv:dp_iv()];
        return data2;
    } else {
        NSMutableData *data = [[NSMutableData alloc] initWithLength:length16];
        uint8_t *buf = [data mutableBytes];
        memcpy(buf, [self bytes], length);
        memset(buf + length, 0, length16 - length);
        NSData *data2 = [data dp_encryptWithKey:dp_key() iv:dp_iv()];
        return data2;
    }
}

@end
