/**
 * author : ch
 * date   : 2020-02-17 11:44:12
 * desc   : Android插件实现类
 */

package com.example.qnsdk

import android.content.Context
import androidx.annotation.NonNull
import com.yolanda.health.qnblesdk.constant.CheckStatus
import com.yolanda.health.qnblesdk.constant.UserGoal
import com.yolanda.health.qnblesdk.constant.UserShape
import com.yolanda.health.qnblesdk.listener.QNBleConnectionChangeListener
import com.yolanda.health.qnblesdk.listener.QNBleDeviceDiscoveryListener
import com.yolanda.health.qnblesdk.listener.QNScaleDataListener
import com.yolanda.health.qnblesdk.out.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*


public class QNSdkPlugin : FlutterPlugin, MethodCallHandler, QNSdkApi, EventChannel.StreamHandler {


    private var eventSink: EventChannel.EventSink? = null


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), ArgumentName.channelName)
        channel.setMethodCallHandler(QNSdkPlugin())
    }

    companion object {

        lateinit var qnBleApi: QNBleApi

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), ArgumentName.channelName)
            channel.setMethodCallHandler(QNSdkPlugin())
            val eventChannel = EventChannel(registrar.messenger(), ArgumentName.eventName)
            eventChannel.setStreamHandler(QNSdkPlugin())
            qnBleApi = QNBleApi.getInstance(registrar.context())
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        events?.let { eventSink = it }
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            MethodName.initSdk -> {
                var appid = call.argument<String>(ArgumentName.appid)
                val fileContent = call.argument<String>(ArgumentName.fileContent)
                initSDK(appid, fileContent, result)
            }
            MethodName.setBleStateListener -> {
                setBleStateListener(result)
            }
            MethodName.setBleDeviceDiscoveryListener -> {
                setBleDeviceDiscoveryListener(result)
            }
            MethodName.setBleConnectionChangeListener -> {
                setBleConnectionChangeListener(result)
            }
            MethodName.setScaleDataListener -> {
                setScaleDataListener(result)
            }
            MethodName.startBleDeviceDiscovery -> {
                startBleDeviceDiscovery(result)
            }
            MethodName.stopBleDeviceDiscovery -> {
                stopBleDeviceDiscovery(result)
            }
            MethodName.connectDevice -> {
                var device = call.argument<Map<String, Any>>(ArgumentName.device)
                var user = call.argument<Map<String, Any>>(ArgumentName.user)
                connectDevice(device, user, result)
            }
            MethodName.disconnectDevice -> {
                var mac: String? = call.argument<String>(ArgumentName.mac)
                var modeId: String? = call.argument<String>(ArgumentName.modeId)
                val qnBleDevice: QNBleDevice = qnBleApi.buildFlutterDevice(modeId, mac)
                disconnectDevice(qnBleDevice, result)
            }
            MethodName.getConfig -> {
                getConfig(result)
            }
            MethodName.saveConfig -> {
                var onlyScreenOn = call.argument<Boolean>(ArgumentName.onlyScreenOn)
                var allowDuplicates = call.argument<Boolean>(ArgumentName.allowDuplicates)
                var duration = call.argument<Int>(ArgumentName.duration)
                var androidConnectOutTime = call.argument<Long>(ArgumentName.androidConnectOutTime)
                var unit = call.argument<Int>(ArgumentName.unit)
                var androidSetNotCheckGPS = call.argument<Boolean>(ArgumentName.androidSetNotCheckGPS)
                saveConfig(onlyScreenOn, allowDuplicates, duration, androidConnectOutTime, unit, androidSetNotCheckGPS, result)
            }
            MethodName.generateScaleData -> {
                var user = call.argument<Map<String, Any>>(ArgumentName.user)
                var measureTime = call.argument<Long>(ArgumentName.measureTime)
                var mac = call.argument<String>(ArgumentName.mac)
                var hmac = call.argument<String>(ArgumentName.hmac)
                var weight = call.argument<Double>(ArgumentName.weight)
                generateScaleData(user, measureTime, mac, hmac, weight, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun initSDK(appid: String?, fileContent: String?, result: Result) {
        qnBleApi.initSdk(appid, fileContent, true) { code, message ->
            result.success(TransformerUtils.transResultCallMap(code, message))
        }
    }

    override fun setBleDeviceDiscoveryListener(result: Result) {
        qnBleApi.setBleDeviceDiscoveryListener(object : QNBleDeviceDiscoveryListener {
            override fun onDeviceDiscover(qnBleDevice: QNBleDevice?) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onDeviceDiscover,
                            mapOf(ArgumentName.device to TransformerUtils.transQNBleDeviceMap(qnBleDevice))))
                }
            }

            override fun onStopScan() {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onStopScan))
                }

            }


            override fun onScanFail(code: Int) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onScanFail,
                            mapOf(ArgumentName.scanFailCode to code)))
                }

            }

            override fun onStartScan() {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onStartScan))
                }
            }

            override fun onBroadcastDeviceDiscover(qnBleBroadcastDevice: QNBleBroadcastDevice?) {
                //暂时不需要实现
            }

            override fun onKitchenDeviceDiscover(qnBleKitchenDevice: QNBleKitchenDevice?) {
                //暂时不需要实现
            }

        })
        result.success(TransformerUtils.transResultCallMap(CheckStatus.OK.code, CheckStatus.OK.msg))
    }

    override fun setBleConnectionChangeListener(result: Result) {
        qnBleApi.setBleConnectionChangeListener(object : QNBleConnectionChangeListener {
            override fun onConnecting(qnBleDevice: QNBleDevice?) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onConnecting))
                }
            }

            override fun onConnectError(qnBleDevice: QNBleDevice?, errorCode: Int) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onConnectError,
                            mapOf(ArgumentName.errorCode to errorCode)))
                }
            }

            override fun onConnected(qnBleDevice: QNBleDevice?) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onConnected))
                }
            }

            override fun onServiceSearchComplete(qnBleDevice: QNBleDevice?) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onServiceSearchComplete))
                }
            }

            override fun onDisconnected(qnBleDevice: QNBleDevice?) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onDisconnected))
                }
            }

            override fun onDisconnecting(qnBleDevice: QNBleDevice?) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onDisconnecting))
                }
            }

        })
        result.success(TransformerUtils.transResultCallMap(CheckStatus.OK.code, CheckStatus.OK.msg))
    }

    override fun setScaleDataListener(result: Result) {
        qnBleApi.setDataListener(object : QNScaleDataListener {
            override fun onScaleStateChange(qnBleDevice: QNBleDevice?, status: Int) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onScaleStateChange,
                            mapOf(ArgumentName.device to TransformerUtils.transQNBleDeviceMap(qnBleDevice),
                                    ArgumentName.scaleState to status)))
                }
            }

            override fun onGetStoredScale(qnBleDevice: QNBleDevice?, storedDataList: MutableList<QNScaleStoreData>?) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onGetStoredScale,
                            mapOf(ArgumentName.device to TransformerUtils.transQNBleDeviceMap(qnBleDevice),
                                    ArgumentName.storedDataList to TransformerUtils.transStoreDataListMap(storedDataList))))
                }
            }

            override fun onGetElectric(qnBleDevice: QNBleDevice?, electric: Int) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onGetElectric,
                            mapOf(ArgumentName.device to TransformerUtils.transQNBleDeviceMap(qnBleDevice),
                                    ArgumentName.electric to electric)))
                }
            }

            override fun onGetUnsteadyWeight(qnBleDevice: QNBleDevice?, weight: Double) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onGetUnsteadyWeight,
                            mapOf(ArgumentName.device to TransformerUtils.transQNBleDeviceMap(qnBleDevice),
                                    ArgumentName.weight to weight)))
                }
            }

            override fun onGetScaleData(qnBleDevice: QNBleDevice?, qnScaleData: QNScaleData?) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onGetScaleData,
                            mapOf(ArgumentName.device to TransformerUtils.transQNBleDeviceMap(qnBleDevice),
                                    ArgumentName.scaleData to TransformerUtils.transQNScaleDataMap(qnScaleData))))
                }
            }

        })
        result.success(TransformerUtils.transResultCallMap(CheckStatus.OK.code, CheckStatus.OK.msg))
    }

    override fun startBleDeviceDiscovery(result: Result) {
        qnBleApi.startBleDeviceDiscovery { code, message ->
            result.success(TransformerUtils.transResultCallMap(code, message))
        }
    }

    override fun stopBleDeviceDiscovery(result: Result) {
        qnBleApi.stopBleDeviceDiscovery { code, message ->
            result.success(TransformerUtils.transResultCallMap(code, message))

        }
    }

    override fun connectDevice(device: Map<String, Any>?, user: Map<String, Any>?, result: Result) {
        var mac: String = device!![ArgumentName.mac] as String
        var modeId: String = device!![ArgumentName.modeId] as String
        val qnBleDevice: QNBleDevice = qnBleApi.buildFlutterDevice(modeId, mac)
        var qnUser: QNUser = qnBleApi.buildUser(
                user!![ArgumentName.userId] as String,
                user!![ArgumentName.height] as Int,
                user!![ArgumentName.gender] as String,
                Date(user!![ArgumentName.birthday] as Long),
                user!![ArgumentName.athleteType] as Int,
                UserShape.SHAPE_NONE,
                UserGoal.GOAL_NONE,
                user!![ArgumentName.clothesWeight] as Double
        ) { code, msg ->
            if (code != 0) {
                result.error(code as String, msg, "")
            }
        }
        qnBleApi.connectDevice(qnBleDevice, qnUser) { code, msg ->
            result.success(TransformerUtils.transResultCallMap(code, msg))
        }
    }

    override fun disconnectDevice(qnBleDevice: QNBleDevice, result: Result) {
        qnBleApi.disconnectDevice(qnBleDevice) { code, message ->
            result.success(TransformerUtils.transResultCallMap(code, message))
        }
    }

    override fun getConfig(result: Result) {
        val qnConfig = qnBleApi.config
        result.success(TransformerUtils.transQNConfigMap(qnConfig))
    }

    override fun generateScaleData(user: Map<String, Any>?, measureTime: Long?, mac: String?, hmac: String?, weight: Double?, result: Result) {
        var qnScaleStoreData = QNScaleStoreData()
        var qnUser: QNUser = qnBleApi.buildUser(
                user!![ArgumentName.userId] as String,
                user!![ArgumentName.height] as Int,
                user!![ArgumentName.gender] as String,
                Date(user!![ArgumentName.birthday] as Long),
                user!![ArgumentName.athleteType] as Int,
                UserShape.SHAPE_NONE,
                UserGoal.GOAL_NONE,
                user!![ArgumentName.clothesWeight] as Double
        ) { code, msg ->
            if (code != 0) {
                result.error(code as String, msg, "")
            }
        }
        qnScaleStoreData.setUser(qnUser)
        qnScaleStoreData.buildStoreData(weight!!, Date(measureTime!!), mac, hmac) { code, message ->
            if (code != 0) {
                result.error(code as String, message, "")
            } else {
                val qnScaleData = qnScaleStoreData.generateScaleData()
                result.success(mapOf(ArgumentName.allItemData to
                        TransformerUtils.transQNScaleItemDataListMap(qnScaleData.allItem)))
            }
        }

    }

    override fun setBleStateListener(result: Result) {
        qnBleApi.setBleStateListener { bleState ->
            eventSink?.let {
                it.success(TransformerUtils.transFormerEventMap(EventName.onBleSystemState,
                        mapOf(ArgumentName.state to bleState)))
            }
        }
        result.success(TransformerUtils.transResultCallMap(CheckStatus.OK.code, CheckStatus.OK.msg))
    }

    override fun saveConfig(onlyScreenOn: Boolean?, allowDuplicates: Boolean?, duration: Int?,
                            androidConnectOutTime: Long?, unit: Int?, androidSetNotCheckGPS: Boolean?,
                            result: Result) {
        var qnConfig = qnBleApi.config
        qnConfig.isOnlyScreenOn = onlyScreenOn!!
        qnConfig.isAllowDuplicates = allowDuplicates!!
        qnConfig.duration = duration!!
        qnConfig.connectOutTime = androidConnectOutTime!!
        qnConfig.unit = unit!!
        qnConfig.isNotCheckGPS = androidSetNotCheckGPS!!
        qnConfig.save { code, msg ->
            result.success(TransformerUtils.transResultCallMap(code, msg))
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }


}
