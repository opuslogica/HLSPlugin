//
//  HLSPlayerPlugin.h
//  SenalRadionica
//
//  Created by Jaime Caicedo on 2/3/14.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>
#import <MediaPlayer/MediaPlayer.h>

@interface HLSPlugin : CDVPlugin {
}

@property(nonatomic, retain) NSString* mediaId;
@property(nonatomic, retain) NSString* resourcePath;

- (void)create:(CDVInvokedUrlCommand*)command;
- (void)getCurrentPositionAudio:(CDVInvokedUrlCommand*)command;
- (void)getDurationAudio:(CDVInvokedUrlCommand*)command;
- (void)startPlayingAudio:(CDVInvokedUrlCommand*)command;
- (void)pausePlayingAudio: (CDVInvokedUrlCommand*)command;
- (void)stopPlayingAudio:(CDVInvokedUrlCommand*)command;
- (void)releasePlayingAudio:(CDVInvokedUrlCommand*)command;
- (void)setVolume:(CDVInvokedUrlCommand*)command;
- (void)seekToAudio: (CDVInvokedUrlCommand*)command;

@property(strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end