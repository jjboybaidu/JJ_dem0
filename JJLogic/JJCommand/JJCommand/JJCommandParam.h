//
//  JJCommandParam.h
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef unsigned long long    DWORD64;      //八字节无符号长整形 UInt64
typedef unsigned int          DWORD;        //四字节无符号长整型 UInt32
typedef unsigned short        WORD;         //两字节无符号整型 UInt16
typedef unsigned char         BYTE;         //一个字节无符号整型 UInt8

/*
 * 协议头尾
 */
extern const WORD HEADER_VALUE;
extern const WORD TAILER_VALUE;

/*
 * CLA类型
 */
extern const BYTE CLA_ENCTRY;
extern const BYTE CLA_NOENCTRY;
extern const BYTE CLA_REQUEST;
extern const BYTE CLA_RESPONSE;
extern const BYTE CLA_P2P;
extern const BYTE CLA_BROADCAST;
extern const BYTE CLA_TRANFER;
extern const BYTE CLA_NOTRANFER;

/*
 * 响应码
 */
extern const WORD SW_SUCCESS;
extern const WORD SW_NO_FULL_SUCCESS;
extern const WORD SW_SUCCESSED_YOURSELF;
extern const WORD SW_SUCCESSED_ERR_FLAG;
extern const WORD SW_NO_RSP;
extern const WORD SW_INPUT_PARAM_ERR;
extern const WORD SW_FAILED_FORWARD;
extern const WORD SW_UNKNOWN_ERR;
extern const WORD SW_NO_INIT;
extern const WORD SW_INS_NOTSUOOORT;
extern const WORD SW_CRC_ERR;
extern const WORD SW_CMD_ERR;
extern const WORD SW_BUSY;
extern const WORD SW_NO_ONLINE_NODE;
extern const WORD SW_NO_ENABLE_NODE;
extern const WORD SW_RQT_REDO;
extern const WORD SW_RQT_SERVER_BUSY;
extern const WORD SW_RQT_NOT_ONLINE_APP;
extern const WORD SW_RQT_NOT_FREE_APP;
extern const WORD SW_NOT_FB_CMD;
extern const int SW_COUNT;
extern const WORD SW_LIST[];

/*
 * INS类型
 */
extern const BYTE INS_COMM_DETECT;
extern const BYTE INS_GET_SVR_TIME;
extern const BYTE INS_GET_SVC_ADDR;
extern const BYTE INS_NAT_P2P_REQ;
extern const BYTE INS_NAT_P2P;
extern const BYTE INS_DISABLE_DEVICE_NODE;
extern const BYTE INS_SUBMIT_DEVICE_STATUS;
extern const BYTE INS_READ_DEVICE_STATUS;
extern const BYTE INS_ADD_CARD;
extern const BYTE INS_DEL_CARD;
extern const BYTE INS_CLEAR_CARD;
extern const BYTE INS_ADD_PSW;
extern const BYTE INS_DEL_PSW;
extern const BYTE INS_UPDATE_PSW;
extern const BYTE INS_CLEAR_PSW;
extern const BYTE INS_GET_HOMEID;
extern const BYTE INS_GET_DOORID;
extern const BYTE INS_GET_DOORADDR;
extern const BYTE INS_CALL;
extern const BYTE INS_LINK_OK_NOTIFY;
extern const BYTE INS_ACCEPT;
extern const BYTE INS_TALKING_HEARTBEAT;
extern const BYTE INS_HANGUP;
extern const BYTE INS_WATCH;
extern const BYTE INS_UNLOCK;
extern const BYTE INS_PHOTO_UP;
extern const BYTE INS_REAL_STREAM;
extern const BYTE INS_APP_MSG_PUSH;
extern const BYTE INS_RECORD_UP;
extern const Byte INS_SET_ACCNUM;
extern const Byte INS_GET_ACCNUM ;
extern const Byte INS_SET_LOCAL_ID;
extern const Byte INS_GET_LOCAL_ID;
extern const Byte INS_SET_TIME;
extern const Byte INS_GET_TIME;
extern const Byte INS_GET_UNLOCK_REC;
extern const int INS_COUNT;
extern const BYTE INS_LIST[];
extern const BYTE Crc8Table[256];

@interface JJCommandParam : NSObject

@end
