//
//  JJEncrypt.h
//  JJEncrypt
//
//  Created by WilliamLiuWen on 16/7/9.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJEncrypt : NSObject

/**
 *  3des加密
 *
 *  @param encryptString 待加密的string
 *  @param keyString     约定的密钥
 *  @param ivString      约定的密钥
 *
 *  @return 3des加密后的string
 */
+ (NSString*)getEncryptWithString:(NSString*)encryptString keyString:(NSString*)keyString ivString:(NSString*)ivString;

/**
 *  3des解密
 *
 *  @param decryptString 待解密的string
 *  @param keyString     约定的密钥
 *  @param ivString      约定的密钥
 *
 *  @return 3des解密后的string
 */
+ (NSString*)getDecryptWithString:(NSString*)decryptString keyString:(NSString*)keyString ivString:(NSString*)ivString;

@end
