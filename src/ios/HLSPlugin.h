//
//  HLSPlayerPlugin.h
//  SenalRadionica
//
//  Created by Jaime Caicedo on 2/3/14.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface HLSPlugin : CDVPlugin {
}

- (void)create:(CDVInvokedUrlCommand*)command;
- (void)startPlayingAudio:(CDVInvokedUrlCommand*)command;
- (void)getCurrentPositionAudio:(CDVInvokedUrlCommand*)command;
- (void)stopPlayingAudio:(CDVInvokedUrlCommand*)command;
- (void)setVolume:(CDVInvokedUrlCommand*)command;

@end
