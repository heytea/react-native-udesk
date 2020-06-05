
export interface IInitParam {
    domain:string;
    appKey:string;
    appId:string;
    sdkToken:string;  //是客户的唯一标识，用来识别身份
}

//初始化信息
export function init(param:IInitParam):Promise<null>

//开始聊天
export function startChat():Promise<null>