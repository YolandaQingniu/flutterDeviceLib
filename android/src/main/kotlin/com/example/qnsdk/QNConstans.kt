/**
 * author : ch
 * date   : 2020-02-17 10:44:12
 * desc   : 常量类
 */

package com.example.qnsdk

class MethodName {

    companion object {
        const val initSdk = "flutter_initSdk"
        const val setBleStateListener = "flutter_setBleStateListener"
        const val setBleDeviceDiscoveryListener = "flutter_setBleDeviceDiscoveryListener"
        const val startBleDeviceDiscovery = "flutter_startBleDeviceDiscovery"
        const val stopBleDeviceDiscovery = "flutter_stopBleDeviceDiscovery"
        const val connectDevice = "flutter_connectDevice"
        const val disconnectDevice = "flutter_disconnectDevice"
        const val setBleConnectionChangeListener = "flutter_setBleConnectionChangeListener"
        const val setScaleDataListener = "flutter_setScaleDataListener"
        const val getConfig = "flutter_getConfig"
        const val saveConfig = "flutter_saveConfig"
        const val convertWeightWithTargetUnit = "flutter_convertWeightWithTargetUnit"
        const val generateScaleData = "flutter_generateScaleData"
    }

}

class EventName {

    companion object {
        const val onBleSystemState = "flutter_onBleSystemState"
        const val onGetUnsteadyWeight = "flutter_onGetUnsteadyWeight"
        const val onGetScaleData = "flutter_onGetScaleData"
        const val onGetStoredScale = "flutter_onGetStoredScale"
        const val onGetElectric = "flutter_onGetElectric"
        const val onScaleStateChange = "flutter_onScaleStateChange"
        const val onDeviceDiscover = "flutter_onDeviceDiscover"
        const val onStartScan = "flutter_onStartScan"
        const val onStopScan = "flutter_onStopScan"
        const val onScanFail = "flutter_onScanFail"
        const val onConnecting = "flutter_onConnecting"
        const val onConnected = "flutter_onConnected"
        const val onServiceSearchComplete = "flutter_onServiceSearchComplete"
        const val onDisconnecting = "flutter_onDisconnecting"
        const val onDisconnected = "flutter_onDisconnected"
        const val onConnectError = "flutter_onConnectError"
        //qnsdkX-2.X
        const val onScaleEventChange = "flutter_onScaleEventChange"


    }
}

class ArgumentName {

    companion object {
        const val channelName = "yolanda.flutter.io/channe"
        const val eventName = "yolanda.flutter.io/event"
        const val methodName = "method"
        const val errorCode = "errorCode"
        const val errorMsg = "errorMsg"
        const val device = "device"
        const val mac = "mac"
        const val name = "name"
        const val modeId = "modeId"
        const val bluetoothName = "bluetoothName"
        const val rssi = "rssi"
        const val isScreenOn = "isScreenOn"
        const val onlyScreenOn = "onlyScreenOn"
        const val allowDuplicates = "allowDuplicates"
        const val duration = "duration"
        const val unit = "unit"
        const val iOSShowPowerAlertKey = "iOSShowPowerAlertKey"
        const val androidConnectOutTime = "androidConnectOutTime"
        const val androidSetNotCheckGPS = "androidSetNotCheckGPS"
        const val scaleData = "scaleData";
        const val user = "user"
        const val measureTime = "measureTime"
        const val hmac = "hmac"
        const val allItemData = "allItemData"
        const val type = "type"
        const val value = "value"
        const val valueType = "valueType"
        const val weight = "weight"
        const val userId = "userId"
        const val height = "height"
        const val gender = "gender"
        const val birthday = "birthday"
        const val athleteType = "athleteType"
        const val clothesWeight = "clothesWeight"
        const val appid = "appid"
        const val fileContent = "fileContent"
        const val state = "state"
        const val data = "data"
        const val storedDataList = "storedDataList"
        const val electric = "electric"
        const val scaleState = "scaleState"
        const val scanFailCode = "scanFailCode"
        //qnsdkX-2.X
        const val scaleEvent = "scaleEvent"
    }


}