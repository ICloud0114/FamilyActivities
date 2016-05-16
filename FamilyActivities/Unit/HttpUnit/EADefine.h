//
//  EADefine.h
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/17.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#ifndef FamilyActivities_EADefine_h
#define FamilyActivities_EADefine_h


#endif

#import "OpenUDID.h"

#define DEVICEID [OpenUDID value]

#define SUCCESS @"success" //获取数据状态
#define MSG     @"msg"
#define MSN     @"msn"

#define DATA      @"data"
#define ACTDATA      @"actdata"
#define ACTDETAIL   @"actdetail"  //活动详情
#define DISCUSSDATA  @"discussdata"//评论列表
#define ARTICLEDATA  @"articledata"//攻略， 更多信息
#define BASEURL   @"www.xiongbb.com"    //接口
#define ACTID     @"actid"  //活动编号

#define RURL      @"rUrl"   //专题链接
#define TYPE      @"type"  //Type为0指明当前是活动，为1则当前是专题
#define ID        @"id"   //上传活动编号


//初始化
//http://kids.ujianli.com/index.php?m=Api&a=gettoken
#define INITIALIZATION  @"index.php?m=Api&a=gettoken"

//读取配置文件
//http://kids.ujianli.com/index.php?m=Api&a=getconfig
#define GET_CONFIG  @"index.php?m=Api&a=getconfig"

//推荐列表（精选列表）
//http://kids.ujianli.com/index.php?m=Api&a=recommend
#define GET_CHOICE  @"index.php?m=Api&a=recommend"

//按关键字查询活动
//http://kids.ujianli.com/index.php?m=Api&a=sList&tt=0
#define SEARCH_BY_KEYWORD  @"index.php?m=Api&a=sList&tt=0"

//按分类菜单查询活动
//http://kids.ujianli.com/index.php?m=Api&a=sList&tt=1
#define SEARCH_BY_CLASS  @"index.php?m=Api&a=sList&tt=1"

//附近活动
//http://kids.ujianli.com/index.php?m=Api&a=sList&tt=2
#define NEARBY_ACTIVITIES  @"index.php?m=Api&a=sList&tt=2"

//相关活动
//http://kids.ujianli.com/index.php?m=Api&a=sList&tt=3
#define CLOSE_ACTIVITIES  @"index.php?m=Api&a=sList&tt=3"

//活动内容（详细信息）
//http://kids.ujianli.com/index.php?m=Api&a=info
#define ACTIVITIES_INFO  @"index.php?m=Api&a=info"

//更多信息（活动文章）//攻略
//http://kids.ujianli.com/index.php?m=Api&a=article
#define MORE_INFO  @"index.php?m=Api&a=article"

//活动评论
//http://kids.ujianli.com/index.php?m=Api&a=discuss
#define ACTIVITIES_COMMENT  @"index.php?m=Api&a=discuss"

//点赞
//http://kids.ujianli.com/index.php?m=Api&a=postInfo&tt=up
#define SET_UP  @"index.php?m=Api&a=postInfo&tt=up"

//点不赞
//http://kids.ujianli.com/index.php?m=Api&a=postInfo&tt=down
#define SET_DOWN  @"index.php?m=Api&a=postInfo&tt=down"

//提交评论
//http://kids.ujianli.com/index.php?m=Api&a=postInfo&tt=discuss
#define SUBMIT_COMMENT  @"index.php?m=Api&a=postInfo&tt=discuss"





