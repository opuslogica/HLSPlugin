HLSPlugin
=========

HLS Plugin Phonegap for iOS
---------------------------

We're starting with Jaime's plugin, and completing it so that it works on both iOS and android.
The android component requires the vitamio library, which you have to compile elsewhere (in eclipse, for example)
and then add the jar to the application that you're building.

However, you should use the vitamio branch if you're interested in all that.

Example
-------

Here's an example of using the plugin for "m3u8" URLs, but not for other types:

```
  this.initialize = function(url) {
    console.log("PLAYER-SERVICE: INITIALIZE: called with url: ", url);
    backend = Media;

    /* If this is a file of URLs to the actual data (i.e., HLS), then use the HLS plugin. */
    if (url.search("m3u8") != -1) backend = HLSPlugin;

    if (player) {
      try { player.release(); }
      catch(x) { console.log("PLAYER-SERVICE: Error releasing player: ", x); }
      player = null;
    }

    media_url = url;
    player = new backend(
      url,
      function() { console.log("MEDIA PLAYBACK SUCCESS!"); },
      function() { console.log("MEDIA PLAYBACK FAILURE!"); },
      function(statusCode) { console.log("MEDIA PLAYBACK Status:", statusCode); }
    );
  };
```
