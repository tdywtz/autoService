//
//  CZWUrl.h
//  autoService
//
//  Created by bangong on 15/11/26.
//  Copyright © 2015年 车质网. All rights reserved.
// http://192.168.1.114:999  <==>  http://sbss.12365auto.com
// http://192.168.1.114:8888  <==>  http://m.12365auto.com


#ifdef DEBUG

#define prefix_url(string) [NSString stringWithFormat:@"http://192.168.1.114:999%@",string]
#define prefix_m_url(string) [NSString stringWithFormat:@"http://192.168.1.114:8888%@",string]

#else

#define prefix_url(string) [NSString stringWithFormat:@"http://sbss.12365auto.com%@",string]
#define prefix_m_url(string) [NSString stringWithFormat:@"http://m.12365auto.com%@",string]

#endif



#define AUTO_URLSTRING(string) [NSString stringWithFormat:@"%@%@",prefix_url(@"/server/forThreeAppService.ashx?"),string]
#define AUTO_M_URLSTRING(string) [NSString stringWithFormat:@"%@%@",prefix_m_url(@"/server/forCommonService.ashx?"),string]


/*
 ************************************
 ************************************专家和用户--共用接口
 ************************************
 */

//用户使用协议
#define auto_agreeForIOS       @"http://m.12365auto.com/user/agreeForIOS.shtml"
//专家注册协议
#define auto_expertsAgree      @"http://m.12365auto.com/user/expertsAgree.html"

//综合信息页面-综合信息
#define auto_fac_info           AUTO_URLSTRING(@"act=fac_info&fid=%@")
//综合信息页面-促销信息列表
#define auto_fac_prolist        AUTO_URLSTRING(@"act=fac_prolist&fid=%@&p=%ld&s=10")
//促销信息详情
#define auto_fac_proinfo        AUTO_URLSTRING(@"act=fac_proinfo&id=%@")
//
#define auto_fac_list           AUTO_URLSTRING(@"act=fac_list_n")
//三包政策
#define auto_fac_policy         AUTO_URLSTRING(@"act=fac_policy&fid=%@")


//广告http://m.12365auto.com/AppServer/forAdvService.ashx?act=three_dt
#define auto_DTopAdv            prefix_m_url(@"/AppServer/forAdvService.ashx?act=three_dt")

/**获取省份*/
#define auto_province           AUTO_M_URLSTRING(@"act=pro")

/**获取城市 */
#define auto_city               AUTO_M_URLSTRING(@"act=city&pid=%@")


/**获取品牌*/
#define auto_car_brand          AUTO_M_URLSTRING(@"act=letter")

/**获取车系*/
#define auto_car_series         AUTO_M_URLSTRING(@"act=s_list&id=%@")

/**获取车型*/
#define auto_car_model          AUTO_M_URLSTRING(@"act=modellist&sid=%@")

/**获取经销商*/
#define auto_business           AUTO_M_URLSTRING(@"act=dis&pid=%@&cid=%@&sid=%@")

/**用户申诉列表(主界面)*/
#define auto_appealList         AUTO_URLSTRING(@"act=appeallist&type=%@&step=%@&cid=%@&sid=%@&p=%ld&s=10")

/**搜索列表*/
#define auto_search             AUTO_URLSTRING(@"act=appeallist&type=%@&title=%@&p=%ld&s=%ld")

/**申诉详情回复与咨询*/
#define auto_appealDetailsReply AUTO_URLSTRING(@"act=reply")

//我来回答
#define auto_wlxz               AUTO_URLSTRING(@"act=wlxz")

/**获取申诉详情底部申诉状态*/
#define auto_appealState        AUTO_URLSTRING(@"act=backAppealState&uid=%@&type=%@&cpid=%@")

/**我的收藏*/
#define auto_collect            AUTO_URLSTRING(@"act=u_appeallist&ids=%@")

/**回复列表*/
#define auto_centerAnswer       AUTO_URLSTRING(@"act=replylist&uid=%@&type=%@&p=%ld&s=10")

/**查看回复回传*/
#define auto_ShowReply          AUTO_URLSTRING(@"act=showreply&id=%@")

/**清空回复列表*/
#define auto_emptyreply         AUTO_URLSTRING(@"act=emptyreply&uid=%@&type=%@")

/**用户反馈*/
#define auto_feedback           AUTO_URLSTRING(@"act=feedback")

/**请求添加好友 */
#define auto_requestAddFriends  AUTO_URLSTRING(@"act=addFriends")

/**删除好友*/
#define auto_delFriend          AUTO_URLSTRING(@"act=delFriend")

/**同意好友请求 */
#define auto_agreeAddFriends    AUTO_URLSTRING(@"act=agreeAddfriends")

/**好友关系（状态）*/
#define auto_firendState        AUTO_URLSTRING(@"act=friendstate")

/**好友列表*/
#define auto_friendsList        AUTO_URLSTRING(@"act=friendslist")

/**根据用户融云id获取用户信息*/
#define auto_infoByRYID         AUTO_URLSTRING(@"act=infoByRYID&id=%@")

/**web页面--申诉详情*/
#define auto_webAppealDetails   prefix_url(@"/appeal/appealinfo.aspx?cpid=%@&uid=%@&type=%@")//@"http://sbss.12365auto.com/appeal/appealinfo.aspx?cpid=%@&uid=%@&type=%@"

/**获取专家建议列表*/
#define auto_adviceList         AUTO_URLSTRING(@"act=adviceList&uid=%@&type=%@&cpid=%@&eid=%@")

/**上传图片接口
   -专家注册上传身份证明图片
   -申诉图片
   -反馈图片
 */
#define auto_ULbackUrl          AUTO_URLSTRING(@"act=ULbackUrl")



/*
 *************************************
************************************** 用户使用接口
 *************************************
 */

/**用户申述表单*/
#define user_appeal            AUTO_URLSTRING(@"act=myappeal")

/**用户注册 */
#define user_register          AUTO_URLSTRING(@"act=u_reg")

/**用户登录*/
#define user_login             AUTO_URLSTRING(@"act=u_login")

//找回密码(用户)
#define user_sendemail         AUTO_M_URLSTRING(@"act=sendemail&username=%@&origin=%@")

/*获取普通用户信息*/
#define user_information       AUTO_URLSTRING(@"act=u_info&uid=%@")

/**获取指定用户申述列表*/
#define user_appealList        AUTO_URLSTRING(@"act=u_appeallist&uid=%@&p=%ld&s=10")

/**修改信息*/
#define user_updateInformation AUTO_M_URLSTRING(@"act=u_updateinfo")

/**上传头像*/
#define user_uploadAvatar      AUTO_URLSTRING(@"act=uploadAvatar")

/**我的申诉删除*/
#define user_appealDelete      AUTO_URLSTRING(@"act=delappeal&cpid=%@")

/**申诉状态列表(我的申诉)*/
#define user_appealStateList   AUTO_URLSTRING(@"act=u_state&uid=%@")

/**用户对专家评价*/
#define user_evaluate          AUTO_URLSTRING(@"act=u_eval&uid=%@&cpid=%@&score=%@&username=%@&content=%@&eid=%@")

/**选择此专家为我协助*/
#define user_selectExpertHelp  AUTO_URLSTRING(@"act=selectEx&uid=%@&cpid=%@&eid=%@")

/**厂家解决是否满意*/
#define user_facsolvedNot      AUTO_URLSTRING(@"act=facsolvedNot&uid=%@&cpid=%@&state=%@")

/**根据cpid获取申诉详情*/
#define user_appealDelails     AUTO_URLSTRING(@"act=appealinfo&cpid=%@")

/**用户对厂家进行评价*/
#define user_fceval            AUTO_URLSTRING(@"act=u_fceval")

/**专家意见报告下载页面*/
#define user_advice            AUTO_URLSTRING(@"act=advice&eid=%@&cpid=%@")



/*
 **************************************
 **************************************专家使用接口
 **************************************
 */

/**专家登陆*/
#define expert_login              AUTO_URLSTRING(@"act=e_login")

/**专家注册*/
#define expert_register           AUTO_URLSTRING(@"act=e_reg")
/**修改注册信息*/
#define expert_e_update           AUTO_URLSTRING(@"act=e_update")

//找回密码(专家)
#define expert_sendemail          AUTO_URLSTRING(@"act=sendemail&username=%@&origin=%@")

/**获取专家用户信息*/
#define expert_information        AUTO_URLSTRING(@"act=e_info&eid=%@")

/**上传头像 */
#define expert_uploadAvatar       AUTO_URLSTRING(@"act=e_uploadtAvatar")

/**修改信息 */
#define expert_updateInformation  AUTO_URLSTRING(@"act=e_updateinfo")

/**获取指定专家协助列表*/
#define expert_helpList           AUTO_URLSTRING(@"act=myxiezhu&eid=%@&p=%ld&s=10")

/**查看专家信息-专家协助历史列表*/
#define expert_e_CompleteOrder    AUTO_URLSTRING(@"act=e_CompleteOrder&eid=%@")

/**我来协助*/
#define expert_wlxz               A UTO_URLSTRING(@"act=wlxz&uid=%@&cpid=%@&eid=%@&reason=%@&ename=%@&uname=%@")

/**提交申诉处理建议*/
#define expert_proposal           AUTO_URLSTRING(@"act=addCommreport")

/**绑定支付宝账号*/
#define expert_bindAccount        AUTO_URLSTRING(@"act=bindAccount")
//**修改支付宝账号*/
#define expert_reAccount          AUTO_URLSTRING(@"act=reAccount")
/**获取账户信息*/
#define expert_e_integral         AUTO_URLSTRING(@"act=e_integral&eid=%@")
/**获取账单列表*/
#define expert_billdetial         AUTO_URLSTRING(@"act=billdetial&eid=%@&acid=%@&p=%ld&s=10")
/**提现*/
#define expert_withdraw           AUTO_URLSTRING(@"act=withdraw")
