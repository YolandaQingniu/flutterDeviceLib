/**
 * author : ch
 * date   : 2020-02-17 11:24:12
 * desc   : 插件需要实现的接口
 */
package com.example.qnsdk

import com.qn.device.out.QNBleDevice
import io.flutter.plugin.common.MethodChannel.Result

interface QNSdkApi {

    fun initSDK(appid: String?, fileContent: String?, result: Result)

    fun setBleStateListener(result: Result)

    fun setBleDeviceDiscoveryListener(result: Result)

    fun setBleConnectionChangeListener(result: Result)

    fun setScaleDataListener(result: Result)

    fun startBleDeviceDiscovery(result: Result)

    fun stopBleDeviceDiscovery(result: Result)

    fun connectDevice(device: Map<String, Any>?, user: Map<String, Any>?, result: Result)

    fun disconnectDevice(qnBleDevice: QNBleDevice, result: Result)

    fun getConfig(result: Result)

    fun saveConfig(onlyScreenOn: Boolean?, allowDuplicates: Boolean?, duration: Int?,androidConnectOutTime:Long?, unit: Int?, androidSetNotCheckGPS: Boolean?, result: Result)

    fun generateScaleData(user: Map<String, Any>?, measureTime: Long?, mac: String?, hmac: String?, weight: Double?, result: Result)
}