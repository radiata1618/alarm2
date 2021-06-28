package com.example.alarm2


import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.annotation.TargetApi
import android.app.AlarmManager
import android.app.PendingIntent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
//import android.support.v7.app.AppCompatActivity
import android.util.Log
//import kotlinx.android.synthetic.main.activity_main.*
import java.util.*

class MainActivity : FlutterActivity() {

    private val REQUEST_CODE = 100
    private lateinit var alarmManager: AlarmManager
    private lateinit var pendingIntent: PendingIntent

    var OVERLAY_PERMISSION_REQ_CODE = 1000

    fun checkPermission() {
        if (!Settings.canDrawOverlays(this)) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            startActivityForResult(intent, OVERLAY_PERMISSION_REQ_CODE)
        }
    }

    private val CHANNEL = "samples.flutter.dev/runAlarm"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            val resultInt = runAlarm(call.method)
            if (resultInt != -1) {
                result.success(resultInt)
            } else {
                result.error("UNAVAILABLE", "Battery level not available.", null)
            }
        }
    }
    private fun runAlarm(setTime : String): Int {

        checkPermission();

        // Creating the pending intent to send to the BroadcastReceiver
        alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, MyAlarmReceiver::class.java)
        pendingIntent = PendingIntent.getBroadcast(this, REQUEST_CODE, intent, PendingIntent.FLAG_UPDATE_CURRENT)

        Log.d("MyApp", "通りました")
        Log.d("MyApp", "dddd"+setTime.toString())

        //Set alarm time のサンプル
        val alarmTimeAtUTC: Long = System.currentTimeMillis() + setTime.toLong()

        alarmManager.setAlarmClock(
            AlarmManager.AlarmClockInfo(alarmTimeAtUTC, pendingIntent),
            pendingIntent
        )

        //サンプル終了
        // Starts the alarm manager
        /*
        alarmManager.setExact(
            AlarmManager.ELAPSED_REALTIME,
            setTime.toLong(),
            pendingIntent
        )
        一旦だめだった
        */
/*
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = System.currentTimeMillis()
        calendar.set(Calendar.HOUR_OF_DAY, 23)
        calendar.set(Calendar.MINUTE, 02)

 */
        /*
        val alarm_time: Long = calendar.getTimeInMillis()
        val clockInfo: AlarmManager.AlarmClockInfo = AlarmClockInfo(alarm_time, null)

        Log.d("MyApp", "Alarm time"+alarm_time.toString())
        */

/*
        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            setTime.toLong(),
            pendingIntent
        )

 */
/*
        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            setTime.toLong(),
            pendingIntent
        )
        //設定後すぐに実行してしまう


 */


        //alarmManager.setAlarmClock(setTime.toLong(),pendingIntent)
        //alarmManager.setAlarmClock(AlarmClockInfo(alarm_time, null), pendingIntent)
        /*
        alarmManager.setExact(
            AlarmManager.ELAPSED_REALTIME,
            setTime.toLong(),
            pendingIntent
        )

         */

        //TO DO　引数でもらってきた時間をセット
/*
        alarmManager.setRepeating(
            AlarmManager.ELAPSED_REALTIME,
            20000,
            10000,
            pendingIntent
        )
*/
        return 1;
    }
/*
    override fun onDestroy() {
        super.onDestroy()
        // Cancels the pendingIntent if it is no longer needed after this activity is destroyed.
        alarmManager.cancel(pendingIntent)
    }
*/

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == OVERLAY_PERMISSION_REQ_CODE) {
            if (!Settings.canDrawOverlays(this)) {
                Log.d("debug", "SYSTEM_ALERT_WINDOW permission not granted...")
                // SYSTEM_ALERT_WINDOW permission not granted...
                // nothing to do !
            }
        }
    }
}