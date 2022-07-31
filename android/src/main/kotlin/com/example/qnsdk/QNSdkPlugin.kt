/**
 * author : ch
 * date   : 2020-02-17 11:44:12
 * desc   : Android插件实现类
 */

package com.example.qnsdk

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.qingniu.qnble.utils.QNLogUtils
import com.qn.device.constant.CheckStatus
import com.qn.device.constant.UserGoal
import com.qn.device.constant.UserShape
import com.qn.device.out.QNBleDevice;
import com.qn.device.listener.QNBleConnectionChangeListener
import com.qn.device.listener.QNBleDeviceDiscoveryListener
import com.qn.device.listener.QNScaleDataListener
import com.qn.device.constant.QNDeviceType

import com.qn.device.out.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*


public class QNSdkPlugin : FlutterPlugin, MethodCallHandler, QNSdkApi, EventChannel.StreamHandler {


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        deviceList = HashSet<QNBleDevice>()
        context = flutterPluginBinding.applicationContext
        qnBleApi = QNBleApi.getInstance(flutterPluginBinding.applicationContext)
        val channel = MethodChannel(flutterPluginBinding.getBinaryMessenger(), ArgumentName.channelName)
        channel.setMethodCallHandler(this)
        val eventChannel = EventChannel(flutterPluginBinding.getBinaryMessenger(), ArgumentName.eventName)
        eventChannel.setStreamHandler(this)
        //QNLogUtils.setLogEnable(true)
    }


    companion object {

        lateinit var qnBleApi: QNBleApi
        lateinit var context: Context
        lateinit var eventSink: EventChannel.EventSink

        lateinit var deviceList: HashSet<QNBleDevice>

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            deviceList = HashSet<QNBleDevice>()
            context = registrar.context()
            qnBleApi = QNBleApi.getInstance(context)
            val channel = MethodChannel(registrar.messenger(), ArgumentName.channelName)
            channel.setMethodCallHandler(QNSdkPlugin())
            val eventChannel = EventChannel(registrar.messenger(), ArgumentName.eventName)
            eventChannel.setStreamHandler(QNSdkPlugin())
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        events?.let { eventSink = it }
    }

    override fun onCancel(arguments: Any?) {
        // eventSink = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        qnBleApi = QNBleApi.getInstance(context)
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
                var androidConnectOutTime: Int? = call.argument(ArgumentName.androidConnectOutTime)
                var unit = call.argument<Int>(ArgumentName.unit)
                var androidSetNotCheckGPS: Boolean? = call.argument<Boolean>(ArgumentName.androidSetNotCheckGPS)
                if (null == onlyScreenOn) onlyScreenOn = false
                if (null == allowDuplicates) allowDuplicates = false
                if (null == androidConnectOutTime) androidConnectOutTime = 10000
                if (null == androidSetNotCheckGPS) androidSetNotCheckGPS = true
                if (null == duration) duration = 0
                if (null == unit) unit = 0
                saveConfig(onlyScreenOn, allowDuplicates, duration, androidConnectOutTime.toLong(), unit, androidSetNotCheckGPS, result)
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
                if(qnBleDevice!=null) {
                    deviceList.add(qnBleDevice);
                }
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

            override fun onStartInteracting(qnBleDevice: QNBleDevice?) {

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

           /**
            * qnsdkX-2.x added. 
            */
           override fun onScaleEventChange(qnBleDevice: QNBleDevice?, scaleEvent: Int) {
                eventSink?.let {
                    it.success(TransformerUtils.transFormerEventMap(EventName.onScaleEventChange,
                            mapOf(ArgumentName.device to TransformerUtils.transQNBleDeviceMap(qnBleDevice),
                                    ArgumentName.scaleEvent to scaleEvent)))
                }
            }

            override fun readSnComplete(qnBleDevice: QNBleDevice?, sn: String ) {
            }

        })
        result.success(TransformerUtils.transResultCallMap(CheckStatus.OK.code, CheckStatus.OK.msg))
    }

    override fun startBleDeviceDiscovery(result: Result) {
        deviceList.clear();
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
        var qnBleDevice: QNBleDevice? = findDevice(mac)
        if(qnBleDevice == null){
            qnBleDevice = qnBleApi.buildFlutterDevice(modeId, mac)
        }
        //Log.i("CUSTOM","Device type = ${qnBleDevice!!.getDeviceType()}");
        if (qnBleDevice!!.isSupportWifi()){
            if (qnBleDevice!!.getDeviceType() == QNDeviceType.SCALE_BLE_DEFAULT) {
                //普通双模秤
                //Log.i("CUSTOM","wifi SCALE_BLE_DEFAULT");
            } else if (qnBleDevice!!.getDeviceType() == QNDeviceType.USER_SCALE) { // 支持wifi的用户秤，即wsp秤
                //Log.i("CUSTOM","USER_SCALE");
            } else if (qnBleDevice!!.getDeviceType() == QNDeviceType.HEIGHT_SCALE) { // 身高一体机
                //Log.i("CUSTOM","HEIGHT_SCALE");
            }
        }else{
            // SCALE_BROADCAST
            if (qnBleDevice!!.getDeviceType() == QNDeviceType.SCALE_BROADCAST && !qnBleDevice.getOneToOne()) {
                //Log.i("CUSTOM","SCALE_BROADCAST");
            } else if (qnBleDevice!!.getDeviceType() == QNDeviceType.SCALE_KITCHEN) { // SCALE_KITCHEN
                //Log.i("CUSTOM","SCALE_KITCHEN");
            } else if (qnBleDevice!!.getDeviceType() == QNDeviceType.USER_SCALE) { // 不支持wifi的用户秤，目前有va秤
                //Log.i("CUSTOM","USER_SCALE");
            } else { //SCALE_BLE_DEFAULT
                //Log.i("CUSTOM","SCALE_BLE_DEFAULT ");
            }
        }

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
                result.error(code.toString(), msg, "")
            }
        }
        qnBleApi.connectDevice(qnBleDevice!!, qnUser) { code, msg ->
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
                result.error(code.toString(), msg, "")
            }
        }
        var qnScaleStoreData = QNScaleStoreData()
        qnScaleStoreData.setUser(qnUser)
        qnScaleStoreData.buildStoreData(weight!!, Date(measureTime!!), mac, hmac) { code, message ->
            if (code != 0) {
                result.error(code.toString(), message, "")
            } else {
                val qnScaleData = qnScaleStoreData.generateScaleData()
                result.success(mapOf(ArgumentName.allItemData to
                        TransformerUtils.transQNScaleItemDataListMap(qnScaleData.allItem),
                        ArgumentName.hmac to hmac))
            }
        }

    }

    override fun setBleStateListener(result: Result) {
        qnBleApi.setBleStateListener { bleState ->
            eventSink?.let {
                it.success(TransformerUtils.transFormerEventMap(EventName.onBleSystemState,
                        mapOf(ArgumentName.state to bleState.ordinal)))
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


    fun findDevice( mac: String): QNBleDevice? {
        for(obj in deviceList){
             if (obj is QNBleDevice){
                val scanResult: QNBleDevice = obj as QNBleDevice
                if(scanResult.getMac() == mac){
                    return obj;
                }
            }
        }
        return null;
    }
}