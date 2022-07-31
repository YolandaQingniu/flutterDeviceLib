/**
 * author: ch
 * date  : 2020-02-17 21:44:12
 * desc  : 转换工具类
 */
package com.example.qnsdk

import com.qn.device.out.*

class TransformerUtils {

    companion object {

        /**
         * 构造事件回调的返回Map
         */
        fun transFormerEventMap(eventNameString: String, dataMap: Map<Any, Any> = mutableMapOf())
                : MutableMap<Any, Any> {
            var resultMap = mutableMapOf<Any, Any>()
            resultMap[ArgumentName.methodName] = eventNameString
            resultMap[ArgumentName.data] = dataMap
            return resultMap
        }

        /**
         * 构建基础结果回调返回Map
         */
        fun transResultCallMap(code: Int, message: String): MutableMap<Any, Any> {
            var resultMap = mutableMapOf<Any, Any>()
            resultMap[ArgumentName.errorCode] = code
            resultMap[ArgumentName.errorMsg] = message
            return resultMap
        }

        /**
         * 构建QNBleDevice回调返回Map
         */
        fun transQNBleDeviceMap(qnBleDevice: QNBleDevice?): MutableMap<Any, Any> {
            var resultMap = mutableMapOf<Any, Any>()
            qnBleDevice?.let {
                resultMap[ArgumentName.mac] = it.mac
                resultMap[ArgumentName.name] = it.name
                resultMap[ArgumentName.modeId] = it.modeId
                resultMap[ArgumentName.bluetoothName] = it.bluetoothName
                resultMap[ArgumentName.rssi] = it.rssi
                resultMap[ArgumentName.isScreenOn] = it.isScreenOn
            }
            return resultMap
        }

        /**
         * 构建存储数据返回List<Map>
         */
        fun transStoreDataListMap(storedDataList: MutableList<QNScaleStoreData>?): List<Map<Any, Any>> {
            var resultListMap = mutableListOf<Map<Any, Any>>()
            storedDataList?.forEach {
                val map = mapOf<Any, Any>(
                        ArgumentName.weight to it.weight,
                        ArgumentName.measureTime to it.measureTime.time,
                        ArgumentName.mac to it.mac,
                        ArgumentName.hmac to it.hmac
                )
                resultListMap.add(map)
            }
            return resultListMap
        }

        /**
         * 构建测量数据返回Map
         */
        fun transQNScaleDataMap(qnScaleData: QNScaleData?): MutableMap<Any, Any> {
            var resultMap = mutableMapOf<Any, Any>()
            qnScaleData?.let {
                var qnUser = it.qnUser
                var itemDatas = it.allItem
                resultMap[ArgumentName.user] = mapOf(
                        ArgumentName.userId to qnUser.userId,
                        ArgumentName.height to qnUser.height,
                        ArgumentName.gender to qnUser.gender,
                        ArgumentName.birthday to qnUser.birthDay.time,
                        ArgumentName.athleteType to qnUser.athleteType,
                        ArgumentName.clothesWeight to qnUser.clothesWeight
                )
                resultMap[ArgumentName.measureTime] = it.measureTime.time
                resultMap[ArgumentName.hmac] = it.hmac
                resultMap[ArgumentName.allItemData] = transQNScaleItemDataListMap(itemDatas)

            }
            return resultMap
        }

        /**
         * 构建测量数据item返回List<Map>
         */
        public fun transQNScaleItemDataListMap(itemDatas: List<QNScaleItemData>): List<Map<Any, Any>> {
            var resultListMap = mutableListOf<Map<Any, Any>>()
            itemDatas?.forEach {
                val map = mapOf<Any, Any>(
                        ArgumentName.type to it.type,
                        ArgumentName.value to it.value,
                        ArgumentName.valueType to it.valueType,
                        ArgumentName.name to it.name
                )
                resultListMap.add(map)
            }
            return resultListMap
        }

        /**
         * 构建配置返回Map
         */
        fun transQNConfigMap(qnConfig: QNConfig?):MutableMap<Any, Any> {
            var resultMap = mutableMapOf<Any, Any>()
            qnConfig?.let {
                resultMap[ArgumentName.onlyScreenOn] = it.isOnlyScreenOn
                resultMap[ArgumentName.allowDuplicates] = it.isAllowDuplicates
                resultMap[ArgumentName.duration] = it.duration
                resultMap[ArgumentName.androidConnectOutTime] = it.connectOutTime
                resultMap[ArgumentName.unit] = it.unit
                resultMap[ArgumentName.androidSetNotCheckGPS] = it.isNotCheckGPS
            }

            return resultMap
        }


    }
}