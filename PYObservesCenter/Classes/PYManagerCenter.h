//
//  PYManagerCenter.h
//  PYObserversCenter
//
//  Created by pengyue on 2017/11/30.
//

#import <Foundation/Foundation.h>

@interface PYManager : NSObject
/**
 如果为YES,这个Manager将不会在用户登录之后被销毁,反之则会被销毁,默认值为NO
 */
@property (nonatomic, assign) BOOL isKeepLiveAlways;

// 提供给子类去实现的方法
- (void)onManagerInit;
- (void)onManagerDidEnterBackground;
- (void)onManagerWillEnterForeground;
- (void)onManagerUserDidLogin;
- (void)onManagerDidLogout;
- (void)onManagerMemoryWarning;

@end

@interface PYManagerCenter : NSObject

+ (instancetype)defaultCenter;

- (PYManager *)getManager:(Class)class;

- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;
- (void)applicationDidReceiveMemoryWarning;
- (void)onUserDidLogin;
- (void)onUserDidLogout;

@end

#define GET_MANAGER(mgrClass) ((mgrClass *)[[PYManagerCenter defaultCenter] getManager:[mgrClass class]])
