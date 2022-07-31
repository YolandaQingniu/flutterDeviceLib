/*
 * @Author: Yolanda 
 * @Date: 2020-01-16 16:55:37 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-19 15:24:44
 */

part of qnsdk;

/// [iOS project configuration]
/// iOS10.0 and above must have Bluetooth instructions in Info.plist, otherwise the system's Bluetooth function cannot be used
/// There is a pair in the Info.plist [Privacy - Bluetooth Peripheral Usage Description] [Privacy - Bluetooth Always Usage Description] button.
/// iOS13.0 and above must be configured with the authorization instructions for Bluetooth in Info.plist, otherwise it will be found to crash.

abstract class QNApi {
  static QNApi _instance = QNInternalApi();

  factory QNApi() => _instance;

  /// Initialize the SDK based on appid and verify the appid and configuration file
  /// This method can be called only once, not multiple times.
  ///
  ///  [appid] provided by the company to the client, verified by the local initialization packet
  ///  [fileContent] configuration file content
  Future<QNResult> initSDK(String appid, String fileContent);

  ///
  /// Set up listener of system Bluetooth status changes
  Future<QNResult> setBleStateListener(QNBleStateListener listener);

  /// Set the scan callback object. When there is a scan result, it will be returned in the set listener method. The SDK only supports one callback object. Repeating the settings will overwrite the previous result
  Future<QNResult> setBleDeviceDiscoveryListener(
      QNBleDeviceDiscoveryListener listener);

  /// Set the Bluetooth connection change listener, the SDK only supports one callback object, and repeating the settings will overwrite the previous results.
  Future<QNResult> setBleConnectionChangeListener(
      QNBleConnectionChangeListener listener);

  /// Set up the data transfer listener
  Future<QNResult> setScaleDataListener(QNScaleDataListener listener);

  /// Start scanning the Bluetooth device and return only to the device. Stops automatically when an error is encountered or Bluetooth is turned off.
  Future<QNResult> startBleDeviceDiscovery();

  /// Stop scanning the Bluetooth device. This method calls the system's stop scanning method. If the scanning is not started, you need to call the next stop scanning to ensure that there will be no more scanning object callback after calling this method.
  Future<QNResult> stopBleDeviceDiscovery();

  /// Connect a runcobo Bluetooth device. The connection process will be called back in QNBleConnectionChangeListener, and the measurement data will be called back in QNScaleDataListener
  ///
  /// [device] Bluetooth devices that need to be connected.
  /// [user] The user model used when connecting to the device, including the userId, and user profile
  Future<QNResult> connectDevice(QNBleDevice device, QNUser user);

  /// Disconnect the connected Light Cow Bluetooth device. The process of disconnecting will be called back in QNBleConnectionChangeListener
  ///
  /// [device] Requires a disconnected Bluetooth device
  Future<QNResult> disconnectDevice(QNBleDevice device);

  /// Get the current settings of the SDK
  Future<QNConfig> getConfig();

  /// When you modify the settings, you must call this method to save it will take effect
  Future<QNResult> saveConfig(QNConfig config);

  /// Converted to the value of the specified unit based on the weight of the supplied kg value
  double convertWeightWithTargetUnit(double weight, QNUnit unit);

  /// Generate measurement data based on stored data and user data
  Future<QNScaleData> generateScaleData(QNUser user, double weight,
      DateTime measureTime, String mac, String hmac);
}
