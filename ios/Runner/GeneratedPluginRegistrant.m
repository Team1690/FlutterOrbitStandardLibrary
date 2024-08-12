//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_keyboard_visibility/FlutterKeyboardVisibilityPlugin.h>)
#import <flutter_keyboard_visibility/FlutterKeyboardVisibilityPlugin.h>
#else
@import flutter_keyboard_visibility;
#endif

#if __has_include(<pointer_interceptor_ios/PointerInterceptorIosPlugin.h>)
#import <pointer_interceptor_ios/PointerInterceptorIosPlugin.h>
#else
@import pointer_interceptor_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterKeyboardVisibilityPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterKeyboardVisibilityPlugin"]];
  [PointerInterceptorIosPlugin registerWithRegistrar:[registry registrarForPlugin:@"PointerInterceptorIosPlugin"]];
}

@end
