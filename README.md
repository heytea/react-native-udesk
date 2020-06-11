# react-native-udesk

## Getting started

`$ npm install react-native-udesk --save`

### Mostly automatic installation

`$ react-native link react-native-udesk`

## Usage
```js
import ReactNativeUdesk from 'react-native-udesk';

// 以下是ReactNativeUdesk可使用的方法

export interface IInitParam {
    domain:string;
    appKey:string;
    appId:string;
    sdkToken:string;  //是客户的唯一标识，用来识别身份
}

/**
 * 初始化信息
 * @param {IInitParam} param 参数 
 */
export function init(param:IInitParam): Promise<null>

/**
 * 用户信息，用于传入这些用户信息，供客服查看
 */
export interface IUserInfo {
    nickname: string;
    email: string;
    phone: string;
    description: string;
}

/**
 * 开始聊天
 * @param {IUserInfo} userInfo 用户信息
 */
export function startChat(userInfo?: IUserInfo): Promise<null>
```
