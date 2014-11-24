package org.opuslogica.plugins;

import java.io.IOException;

import io.vov.vitamio.LibsChecker;
import io.vov.vitamio.MediaPlayer;
import io.vov.vitamio.MediaPlayer.OnBufferingUpdateListener;
import io.vov.vitamio.MediaPlayer.OnErrorListener;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Binder;
import android.os.IBinder;
import android.util.Log;
import android.view.SurfaceView;

public class HLSPlayerService extends Service {

    private static MediaPlayer mMediaPlayer;

    private final static String TAG = HLSPlayerService.class.getSimpleName();

    // This is the object that receives interactions from clients. See
    // RemoteService for a more complete example.
    private final IBinder mBinder = new LocalBinder();

    /**
     * TODO: Set the path variable to a local audio file path.
     */
    private static final String PATH = "http://cdns840stu0010.multistream.net/rtvcRadionicalive/smil:rtvcRadionica.smil/playlist.m3u8";
    private String path = PATH;

    @Override
    public void onCreate() {
	Log.i(TAG, "HLSPlayer: onCreate: before super.onCreate();");
	super.onCreate();
	Log.i(TAG, "HLSPlayer: onCreate: after super.onCreate();");

	if (!io.vov.vitamio.LibsChecker.checkVitamioLibs(this))
            return;

	Log.i(TAG, "HLSPlayer: onCreate: after checking libs");
    }

    public String getPath() {
	return path;
    }

    public void setPath(String path) {
	this.path = path;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
	Log.i(TAG, "Received start id " + startId + ": " + intent);

	if (mMediaPlayer != null){
	    Log.i(TAG, "HLSPlayer: onStartCommand: already have a MediaPlayer");
	    return START_STICKY;
	}

	if (isNetworkOnline()) {
	    Log.i(TAG, "HLSPlayer: onStartCommand: Connecting to the Internet");
	    try {
		Log.i(TAG, "HLSPlayer: onStartCommand: start playing for " + path);

		mMediaPlayer = new MediaPlayer(getApplicationContext());
		mMediaPlayer.setDataSource(path);
		mMediaPlayer.setAdaptiveStream(true);
		mMediaPlayer.setBufferSize(1024 * 512);
		mMediaPlayer.prepare();

		mMediaPlayer.setOnErrorListener(onErrorListener);
		mMediaPlayer.setOnBufferingUpdateListener(new OnBufferingUpdateListener() {
			@Override
			public void onBufferingUpdate(MediaPlayer mp, int percent) {
			    // TODO Auto-generated method stub

			    Log.i(TAG, "HLSPlayer: onStartCommand: amount buffered so far: " + percent + "%");
			    if (percent >= 20 && !isPlaying()) {
				Log.i(TAG, "HLSPlayer: onStartCommand: starting to play because more than 20% buffered.");
				mMediaPlayer.start();
			    }
			}
		    });
	    } catch (IllegalArgumentException e) {
		e.printStackTrace();
	    } catch (SecurityException e) {
		e.printStackTrace();
	    } catch (IllegalStateException e) {
		e.printStackTrace();
	    } catch (IOException e) {
		e.printStackTrace();
	    }
	} else {
	    Log.e(TAG, "HLSPlayer: onStartCommand: the network is offline.  Play something to that effect?");
	}

	// We want this service to continue running until it is explicitly
	// stopped, so return sticky.
	return START_STICKY;
    }

    private OnErrorListener onErrorListener = new OnErrorListener() {
	    @Override
	    public boolean onError(MediaPlayer mp, int what, int extra) {
		Log.e(TAG, "HLSPlayer: OnErrorListener: Got some error in the player.");
		return true;
	    }
	};

    private boolean isNetworkOnline() {
	ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
	NetworkInfo netInfo = cm.getActiveNetworkInfo();
	if (netInfo != null && netInfo.isConnectedOrConnecting()) {
	    return true;
	}
	return false;
    }

    private void stopMediaPlayer(){
	if (mMediaPlayer != null) {
	    if (mMediaPlayer.isPlaying()) {
		mMediaPlayer.stop();
		mMediaPlayer.release();
		mMediaPlayer = null;
	    } else {
		mMediaPlayer.stop();
		mMediaPlayer.release();
		mMediaPlayer = null;
	    }
	}
    }

    public void stopStreaming() {
	stopMediaPlayer();
    }

    @Override
    public void onDestroy() {
	Log.i(TAG, "HLSPlayer: onDestroy: Destroying the player.");
	stopMediaPlayer();
	super.onDestroy();
    }

    public boolean isPlaying(){
	if (mMediaPlayer != null && mMediaPlayer.isPlaying()) {
	    return true;
	} else {
	    return false;
	}
    }

    public void setVolume(float volume){
	mMediaPlayer.setVolume(volume, volume);
    }

    @Override
    public IBinder onBind(Intent arg0) {
	return mBinder;
    }

    /**
     * Class for clients to access. Because we know this service always runs in
     * the same process as its clients, we don't need to deal with IPC.
     */
    public class LocalBinder extends Binder {
	public HLSPlayerService getService() {
	    return HLSPlayerService.this;
	}
    }
}
