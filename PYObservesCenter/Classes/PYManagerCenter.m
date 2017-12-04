//
//  PYManagerCenter.m
//  PYObserversCenter
//
//  Created by pengyue on 2017/11/30.
//

#import "PYManagerCenter.h"

@implementation PYManager

- (void)onManagerInit{}

- (void)onManagerDidEnterBackground {}

- (void)onManagerWillEnterForeground {}

- (void)onManagerUserDidLogin {}

- (void)onManagerDidLogout {}

- (void)onManagerMemoryWarning {}

@end

@interface PYManagerCenter ()
{
    NSMutableDictionary *_dicMrgs;
    NSRecursiveLock *_lock;
}
@end

@implementation PYManagerCenter

+ (instancetype)defaultCenter{
    static PYManagerCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[self alloc] init];
    });
    return center;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dicMrgs = [NSMutableDictionary dictionary];
        _lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (PYManager *)getManager:(Class)class
{
    if (![class isSubclassOfClass:[PYManager class]]) {
        return nil;
    }
    
    [_lock lock];
    
    NSString *key = NSStringFromClass(class);
    PYManager *mgr = _dicMrgs[key];
    
    if (mgr) {
        [_lock unlock];
        return mgr;
    }
    
    mgr = [[class alloc] init];
    [mgr onManagerInit];
    
    _dicMrgs[key] = mgr;
    [_lock unlock];
    
    return mgr;
}

- (void)applicationDidEnterBackground
{
    NSDictionary *tmpMrgs = [NSDictionary dictionaryWithDictionary:_dicMrgs];
    for (PYManager *mgr in [tmpMrgs allValues]) {
        [mgr onManagerDidEnterBackground];
    }
}

- (void)applicationWillEnterForeground
{
    NSDictionary *tmpMrgs = [NSDictionary dictionaryWithDictionary:_dicMrgs];
    for (PYManager *mgr in [tmpMrgs allValues]) {
        [mgr onManagerWillEnterForeground];
    }
}

- (void)applicationDidReceiveMemoryWarning
{
    NSDictionary *tmpMrgs = [NSDictionary dictionaryWithDictionary:_dicMrgs];
    for (PYManager *mgr in [tmpMrgs allValues]) {
        [mgr onManagerMemoryWarning];
    }
}

- (void)onUserDidLogin
{
    NSDictionary *tmpMrgs = [NSDictionary dictionaryWithDictionary:_dicMrgs];
    for (PYManager *mgr in [tmpMrgs allValues]) {
        [mgr onManagerUserDidLogin];
    }
}


- (void)onUserDidLogout
{
    NSDictionary *tmpMrgs = [NSDictionary dictionaryWithDictionary:_dicMrgs];
    for (PYManager *mgr in [tmpMrgs allValues]) {
        [mgr onManagerDidLogout];
        
        if (!mgr.isKeepLiveAlways) {
            NSString *key = NSStringFromClass([mgr class]);
            [_dicMrgs removeObjectForKey:key];
        }
    }
}


@end
