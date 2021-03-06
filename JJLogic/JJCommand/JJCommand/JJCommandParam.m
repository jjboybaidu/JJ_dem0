//
//  JJCommandParam.m
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJCommandParam.h"

/*
 * 协议头尾
 */
const WORD HEADER_VALUE    = 0xA5A5;
const WORD TAILER_VALUE    = 0xA3A3;

/*
 * CLA类型
 */
const BYTE CLA_ENCTRY                  = 0x80;
const BYTE CLA_NOENCTRY                = 0x00;
const BYTE CLA_REQUEST                 = 0x00;
const BYTE CLA_RESPONSE                = 0x08;
const BYTE CLA_P2P                     = 0x00;
const BYTE CLA_BROADCAST               = 0x04;
const BYTE CLA_TRANFER                 = 0x00;
const BYTE CLA_NOTRANFER               = 0x02;

/*
 * 响应码
 */
const UInt16 SW_SUCCESS 			= 0x9000;
const UInt16 SW_NO_FULL_SUCCESS 	= 0x9001;
const UInt16 SW_SUCCESSED_YOURSELF 	= 0x9002;
const UInt16 SW_SUCCESSED_ERR_FLAG 	= 0x9003;
const UInt16 SW_NO_RSP 				= 0xFFFF;
const UInt16 SW_INPUT_PARAM_ERR 	= 0xFFFE;
const UInt16 SW_FAILED_FORWARD 		= 0xFFF0;
const UInt16 SW_UNKNOWN_ERR 		= 0x6A01;
const UInt16 SW_NO_INIT 			= 0x6A02;
const UInt16 SW_INS_NOTSUOOORT 		= 0x6A03;
const UInt16 SW_CRC_ERR 			= 0x6A04;
const UInt16 SW_CMD_ERR 			= 0x6A05;
const UInt16 SW_BUSY 				= 0x6A06;
const UInt16 SW_NO_ONLINE_NODE 		= 0x6B01;
const UInt16 SW_NO_ENABLE_NODE 		= 0x6B02;
const UInt16 SW_RQT_REDO 			= 0x6100;
const UInt16 SW_RQT_SERVER_BUSY 	= 0x6A88;
const UInt16 SW_RQT_NOT_ONLINE_APP 	= 0x6A01;
const UInt16 SW_RQT_NOT_FREE_APP 	= 0x6A02;
const UInt16 SW_NOT_FB_CMD 			= 0x1000;
const int SW_COUNT = 20;
const WORD SW_LIST[] = {
    SW_SUCCESS,
    SW_NO_FULL_SUCCESS,
    SW_SUCCESSED_YOURSELF,
    SW_SUCCESSED_ERR_FLAG,
    SW_NO_RSP,
    SW_INPUT_PARAM_ERR,
    SW_FAILED_FORWARD,
    SW_UNKNOWN_ERR,
    SW_NO_INIT,
    SW_INS_NOTSUOOORT,
    SW_CRC_ERR,
    SW_CMD_ERR,
    SW_BUSY,
    SW_NO_ONLINE_NODE,
    SW_NO_ENABLE_NODE,
    SW_RQT_REDO,
    SW_RQT_SERVER_BUSY,
    SW_RQT_NOT_ONLINE_APP,
    SW_RQT_NOT_FREE_APP,
    SW_NOT_FB_CMD
};

/*
 * INS类型
 */
const BYTE INS_COMM_DETECT 			= 0x01;
const BYTE INS_GET_SVR_TIME 		= 0x02;
const BYTE INS_GET_SVC_ADDR			= 0x11;
const BYTE INS_NAT_P2P_REQ			= 0x12;
const BYTE INS_NAT_P2P 				= 0x13;
const BYTE INS_DISABLE_DEVICE_NODE 	= 0x21;
const BYTE INS_SUBMIT_DEVICE_STATUS = 0x22;
const BYTE INS_READ_DEVICE_STATUS 	= 0x23;
const BYTE INS_ADD_CARD 			= 0x24;
const BYTE INS_DEL_CARD 			= 0x25;
const BYTE INS_CLEAR_CARD 			= 0x26;
const BYTE INS_ADD_PSW 				= 0x27;
const BYTE INS_DEL_PSW 				= 0x28;
const BYTE INS_UPDATE_PSW 			= 0x29;
const BYTE INS_CLEAR_PSW 			= 0x2A;
const BYTE INS_GET_HOMEID 			= 0x30;
const BYTE INS_GET_DOORID 			= 0x31;
const BYTE INS_GET_DOORADDR			= 0x32;
const BYTE INS_CALL 				= 0x41;
const BYTE INS_LINK_OK_NOTIFY 		= 0x42;
const BYTE INS_ACCEPT 				= 0x43;
const BYTE INS_TALKING_HEARTBEAT 	= 0x44;
const BYTE INS_HANGUP 				= 0x45;
const BYTE INS_WATCH 				= 0x46;
const BYTE INS_UNLOCK 				= 0x47; //71
const BYTE INS_PHOTO_UP 			= 0x51;
const BYTE INS_REAL_STREAM 			= 0x52;
const BYTE INS_APP_MSG_PUSH 		= 0x61;
const BYTE INS_RECORD_UP            = 0x77;
const Byte INS_SET_ACCNUM           = 0x82;
const Byte INS_GET_ACCNUM           = 0x83;
const Byte INS_SET_LOCAL_ID         = 0x84;
const Byte INS_GET_LOCAL_ID         = 0x85;
const Byte INS_SET_TIME             = 0x86;
const Byte INS_GET_TIME             = 0x87;
const Byte INS_GET_UNLOCK_REC       = 0x88;
const int INS_COUNT = 31;
const BYTE INS_LIST[] = {
    INS_COMM_DETECT,
    INS_GET_SVR_TIME,
    INS_GET_SVC_ADDR,
    INS_NAT_P2P_REQ,
    INS_NAT_P2P,
    INS_DISABLE_DEVICE_NODE,
    INS_SUBMIT_DEVICE_STATUS,
    INS_READ_DEVICE_STATUS,
    INS_ADD_CARD,
    INS_DEL_CARD,
    INS_CLEAR_CARD,
    INS_ADD_PSW,
    INS_DEL_PSW,
    INS_UPDATE_PSW,
    INS_CLEAR_PSW,
    INS_GET_HOMEID,
    INS_GET_DOORID,
    INS_GET_DOORADDR,
    INS_CALL,
    INS_LINK_OK_NOTIFY,
    INS_ACCEPT,
    INS_TALKING_HEARTBEAT,
    INS_HANGUP,
    INS_WATCH,
    INS_UNLOCK,
    INS_PHOTO_UP,
    INS_REAL_STREAM,
    INS_APP_MSG_PUSH,
    INS_RECORD_UP,
    INS_SET_ACCNUM,
    INS_GET_ACCNUM,
    INS_SET_LOCAL_ID,
    INS_GET_LOCAL_ID,
    INS_SET_TIME,
    INS_GET_TIME,
    INS_GET_UNLOCK_REC
};

const BYTE Crc8Table[256] = {
    0x00, 0x07, 0x0E, 0x09, 0x1C, 0x1B, 0x12, 0x15,
    0x38, 0x3F, 0x36, 0x31, 0x24, 0x23, 0x2A, 0x2D,
    0x70, 0x77, 0x7E, 0x79, 0x6C, 0x6B, 0x62, 0x65,
    0x48, 0x4F, 0x46, 0x41, 0x54, 0x53, 0x5A, 0x5D,
    0xE0, 0xE7, 0xEE, 0xE9, 0xFC, 0xFB, 0xF2, 0xF5,
    0xD8, 0xDF, 0xD6, 0xD1, 0xC4, 0xC3, 0xCA, 0xCD,
    0x90, 0x97, 0x9E, 0x99, 0x8C, 0x8B, 0x82, 0x85,
    0xA8, 0xAF, 0xA6, 0xA1, 0xB4, 0xB3, 0xBA, 0xBD,
    0xC7, 0xC0, 0xC9, 0xCE, 0xDB, 0xDC, 0xD5, 0xD2,
    0xFF, 0xF8, 0xF1, 0xF6, 0xE3, 0xE4, 0xED, 0xEA,
    0xB7, 0xB0, 0xB9, 0xBE, 0xAB, 0xAC, 0xA5, 0xA2,
    0x8F, 0x88, 0x81, 0x86, 0x93, 0x94, 0x9D, 0x9A,
    0x27, 0x20, 0x29, 0x2E, 0x3B, 0x3C, 0x35, 0x32,
    0x1F, 0x18, 0x11, 0x16, 0x03, 0x04, 0x0D, 0x0A,
    0x57, 0x50, 0x59, 0x5E, 0x4B, 0x4C, 0x45, 0x42,
    0x6F, 0x68, 0x61, 0x66, 0x73, 0x74, 0x7D, 0x7A,
    0x89, 0x8E, 0x87, 0x80, 0x95, 0x92, 0x9B, 0x9C,
    0xB1, 0xB6, 0xBF, 0xB8, 0xAD, 0xAA, 0xA3, 0xA4,
    0xF9, 0xFE, 0xF7, 0xF0, 0xE5, 0xE2, 0xEB, 0xEC,
    0xC1, 0xC6, 0xCF, 0xC8, 0xDD, 0xDA, 0xD3, 0xD4,
    0x69, 0x6E, 0x67, 0x60, 0x75, 0x72, 0x7B, 0x7C,
    0x51, 0x56, 0x5F, 0x58, 0x4D, 0x4A, 0x43, 0x44,
    0x19, 0x1E, 0x17, 0x10, 0x05, 0x02, 0x0B, 0x0C,
    0x21, 0x26, 0x2F, 0x28, 0x3D, 0x3A, 0x33, 0x34,
    0x4E, 0x49, 0x40, 0x47, 0x52, 0x55, 0x5C, 0x5B,
    0x76, 0x71, 0x78, 0x7F, 0x6A, 0x6D, 0x64, 0x63,
    0x3E, 0x39, 0x30, 0x37, 0x22, 0x25, 0x2C, 0x2B,
    0x06, 0x01, 0x08, 0x0F, 0x1A, 0x1D, 0x14, 0x13,
    0xAE, 0xA9, 0xA0, 0xA7, 0xB2, 0xB5, 0xBC, 0xBB,
    0x96, 0x91, 0x98, 0x9F, 0x8A, 0x8D, 0x84, 0x83,
    0xDE, 0xD9, 0xD0, 0xD7, 0xC2, 0xC5, 0xCC, 0xCB,
    0xE6, 0xE1, 0xE8, 0xEF, 0xFA, 0xFD, 0xF4, 0xF3
};


@implementation JJCommandParam

@end
