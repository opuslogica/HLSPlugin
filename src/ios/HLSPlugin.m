/* HLSPlayerPlugin.m
   Created by Jaime Caicedo on 2/3/14.
*/

#import "HLSPlugin.h"
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

static MPMoviePlayerController *moviePlayer = nil;

@implementation HLSPlugin
@synthesize mediaId;
@synthesize resourcePath;
@synthesize moviePlayer;

- (void)create:(CDVInvokedUrlCommand*)command {
  
  self.mediaId      = [command.arguments objectAtIndex:0];
  self.resourcePath = [command.arguments objectAtIndex:1];
  
  NSLog(@"HLSPlugin created path-> %@    id-> %@", self.resourcePath, self.mediaId);
  
  CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)getCurrentPositionAudio:(CDVInvokedUrlCommand*)command{
	NSLog(@"%@", @"HLSPlugin getCurrentPosition");
  
  [self.commandDelegate
   sendPluginResult: [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                                       messageAsDouble: moviePlayer.currentPlaybackTime]
        callbackId: command.callbackId];
}

- (void) getDurationAudio: (CDVInvokedUrlCommand*) command {
  NSLog(@"%@", @"HLSPlugin getDuration");
  
  [self.commandDelegate
   sendPluginResult: [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                                       messageAsDouble: moviePlayer.duration]
   callbackId: command.callbackId];
}


- (void) startPlayingAudio: (CDVInvokedUrlCommand*) command {
  NSLog(@"%@", @"HLSPlugin startPlayingAudio");
  
  @synchronized(self) {
    if (moviePlayer == nil) {
      //audioPlayer = [[STKAudioPlayer alloc] init];
      NSURL* url = [NSURL URLWithString:self.resourcePath];
      
      moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
      moviePlayer.shouldAutoplay = YES;
      
      [moviePlayer play];
      return;
    }
    else if (moviePlayer.playbackState != MPMoviePlaybackStatePlaying) {
      NSLog(@"%@",@"Resume ");
      [moviePlayer play];
    }
  }
  
  [self.commandDelegate sendPluginResult: [CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                              callbackId: command.callbackId];
  
}

- (void)pausePlayingAudio: (CDVInvokedUrlCommand*)command{
  NSLog(@"%@", @"HLSPlugin pausePlayingAudio");
  
  if (moviePlayer.playbackState != MPMoviePlaybackStatePaused) {
    NSLog (@"Pause");
    [moviePlayer pause];
  }
  
  [self.commandDelegate sendPluginResult: [CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                              callbackId: command.callbackId];
}

- (void) stopPlayingAudio: (CDVInvokedUrlCommand*) command {
  NSLog(@"%@", @"HLSPlugin stopPlayinAudio");
  
  if (moviePlayer.playbackState != MPMoviePlaybackStatePaused)
  {
    NSLog(@"Stop");
    [moviePlayer stop];
    moviePlayer.currentPlaybackTime = 0;
    
  }
  
  [self.commandDelegate sendPluginResult: [CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                              callbackId: command.callbackId];
}

- (void) releasePlayingAudio:(CDVInvokedUrlCommand*)command{
  NSLog(@"%@", @"HLSPlugin stopPlayinAudio");
  
  NSLog(@"Release");
  [moviePlayer stop];
  moviePlayer = nil;
  
}

- (void) setVolume: (CDVInvokedUrlCommand*) command {
  
  NSString* mmediaId = [command.arguments objectAtIndex:0];
  NSNumber* volume   = [command.arguments objectAtIndex:1];
  
  NSLog(@"HLSPlayer setting Volume %@  mediaId %@", volume, mmediaId);
  
  //audioPlayer.volume = [volume intValue];
  
  //[moviePlayer ]
  
  [[MPMusicPlayerController applicationMusicPlayer] setVolume:volume.floatValue];
  
  [self.commandDelegate sendPluginResult: [CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                              callbackId: command.callbackId];
  
}

- (void)seekToAudio: (CDVInvokedUrlCommand*)command{
  NSLog(@"%@", @"HLSPlugin seekToAudio");
  
  NSString* mmediaId = [command.arguments objectAtIndex:0];
  NSNumber* position = [command.arguments objectAtIndex:1]; // double-able
  
  moviePlayer.currentPlaybackTime = position.doubleValue;
  
  [self.commandDelegate sendPluginResult: [CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                              callbackId: command.callbackId];
}

@end
