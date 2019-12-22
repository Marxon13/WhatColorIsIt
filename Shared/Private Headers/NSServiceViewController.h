//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Jun  9 2015 22:53:21).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2014 by Steve Nygard.
//

#import <AppKit/NSViewController.h>

#pragma mark Blocks

typedef void (^CDUnknownBlockType)(void); // return type and parameters are unknown

@class NSServiceViewControllerAuxiliary, NSString, NSViewServiceBridge, NSViewServiceMarshal, NSWindow;

@interface NSServiceViewController : NSViewController
{
    NSServiceViewControllerAuxiliary *_aux;
}

+ (id)serviceBundle;
+ (void)deferBlockOntoMainThread:(CDUnknownBlockType)arg1;
+ (void)withHostProcessIdentifier:(int)arg1 invoke:(CDUnknownBlockType)arg2;
+ (struct __CFString *)privateRunLoopMode;
+ (id)serviceViewControllerForWindow:(id)arg1;
+ (id)listenerEndpoint;
+ (BOOL)setAccessibilityParent:(long long)arg1 forWindow:(id)arg2;
+ (id)allocWithZone:(struct _NSZone *)arg1;
+ (BOOL)currentAppIsViewService;
+ (id)hostAppDescription:(int)arg1;
+ (unsigned int)_windowForContextID:(unsigned int)arg1 fromViewService:(int)arg2 error:(id *)arg3;
+ (unsigned int)declinedEventMask;
- (void)_windowFrameWillChange;
- (void)_windowFrameDidChange;
- (void)_didDisassociateFromHostWindow;
- (void)_didAssociateWithHostWindow;
- (BOOL)_shouldNormalizeAppearance;
- (struct CGRect)_serviceWindowFrameForRemoteViewFrame:(struct CGRect)arg1;
- (void)_setHostSDKVersion:(unsigned int)arg1;
@property(readonly) unsigned int hostSDKVersion;
@property NSViewServiceMarshal *marshal;
@property(readonly) NSWindow *serviceWindow;
- (id)initWithWindow:(id)arg1;
- (void)_endPrivateEventLoop;
- (void)hostWindowReceivedEventType:(unsigned long long)arg1;
- (void)setAccessoryViewSize:(struct CGSize)arg1;
- (void)forgetAccessoryView;
@property(readonly) unsigned int callsToSetViewCount;
@property(readonly) BOOL mostRecentCallToSetViewWasNonNil;
- (void)setView:(id)arg1;
@property(readonly) BOOL valid;
- (BOOL)invalid;
- (void)invalidate;
- (void)_invalidateRendezvousWindowControllers;
- (void)childWindowDidInvalidate:(id)arg1 dueToError:(id)arg2;
- (id)nibBundle;
- (id)nibName;
- (void)advanceToRunPhase;
- (void)retreatToConfigPhase;
- (unsigned long long)awakeFromRemoteView;
@property(readonly) NSViewServiceBridge *bridge;
- (void)dealloc;
- (void)deallocOnAppKitThread;
- (void)_retainMarshal;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;
- (BOOL)respondsToAction:(SEL)arg1 forTarget:(id)arg2;
- (id)remoteViewControllerProxyWithErrorHandler:(CDUnknownBlockType)arg1;
- (id)remoteViewControllerProxy;
- (id)exportedObject;
- (id)exportedInterface;
- (id)remoteViewControllerInterface;
- (BOOL)isLayerCentric;
@property(readonly) struct CGSize sizeHint;
@property(readonly) NSString *remoteViewIdentifier;
- (void)whileMouseIsDisassociatedFromMouseCursorPosition:(CDUnknownBlockType)arg1;
- (void)associateMouseAndMouseCursorPosition:(BOOL)arg1 completion:(CDUnknownBlockType)arg2;
- (id)requestResize:(struct CGSize)arg1 animation:(CDUnknownBlockType)arg2 completion:(CDUnknownBlockType)arg3;
- (id)_requestResize:(struct CGSize)arg1 hostShouldAnimate:(BOOL)arg2 animation:(CDUnknownBlockType)arg3 completion:(CDUnknownBlockType)arg4;
- (BOOL)remoteViewSizeChanged:(struct CGSize)arg1 transaction:(id)arg2;
- (BOOL)remoteViewSizeChanged:(struct CGSize)arg1 transactions:(id)arg2;
@property(readonly) BOOL adjustLayoutInProgress;
- (void)adjustLayout:(CDUnknownBlockType)arg1 animation:(CDUnknownBlockType)arg2 completion:(CDUnknownBlockType)arg3;
- (void)_animateLayout:(CDUnknownBlockType)arg1 forWindow:(id)arg2 withNewFittingSize:(struct CGSize)arg3 completion:(CDUnknownBlockType)arg4;
- (void)defaultResizeBehavior;
@property(readonly) struct CGSize remoteViewSize;
@property(readonly) BOOL makesExplicitResizeRequests;
@property(readonly) BOOL allowsImplicitResizeRequests;
- (BOOL)_explicitSizeRequestInhibitsImplicitSizeRequests;
@property(readonly) BOOL allowsWindowFrameOriginChanges;
- (unsigned long long)filterStyleMask:(unsigned long long)arg1;
- (unsigned long long)acceptableStyleMask;
- (id)leastRecentError;
- (void)errorOccurred:(id)arg1;
- (void)deferBlockOntoMainThread:(CDUnknownBlockType)arg1;
- (void)withHostContextInvoke:(CDUnknownBlockType)arg1;
- (unsigned int)declinedEventMask;

@end

