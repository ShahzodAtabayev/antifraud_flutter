package uz.tbm.antifraud_flutter.antifraud_flutter

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import uz.tbm.antifraudmobilesdk.AntiFraudLibrary

/** AntifraudFlutterPlugin */
class AntifraudFlutterPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var sdk: AntiFraudLibrary? = null // SDK instance

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "antifraud_flutter")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> {
                val host = call.argument<String>("host") ?: ""
                initializeSDK(call.context(), host, result)
            }

            "verify_sms_code" -> {
                val code = call.argument<String>("code") ?: ""
                val phoneNumber = call.argument<String>("phone_number") ?: ""
                verifySMSCode(code, phoneNumber, result)
            }

            "confirm_face" -> {
                val document = call.argument<String>("document") ?: ""
                val birthDate = call.argument<String>("birth_date") ?: ""
                confirmFace(document, birthDate, result)
            }

            "detect_fraud" -> {
                val code = call.argument<String>("code") ?: ""
                detectFraud(code, result)
            }

            "make_operation" -> makeOperation(result)

            "logout" -> logout(result)

            else -> result.notImplemented()
        }
    }

    private fun initializeSDK(
        context: Context,
        host: String,
        result: MethodChannel.Result
    ) {
        try {
            sdk = AntiFraudLibrary(
                host = host,
                context = context,
            )
            sdk!!.initialize { r ->
                r.onSuccess {
                    Log.d("AntifraudFlutterPlugin", "SDK initialized successfully")
                    result.success("SDK initialized successfully")
                }
                r.onFailure {
                    Log.e("AntifraudFlutterPlugin", "SDK initialization failed: ${it.message}")
                    result.error("INIT_ERROR", it.message, null)
                }
            }
        } catch (e: Exception) {
            Log.e("AntifraudFlutterPlugin", "Error initializing SDK: ${e.message}")
            result.error("INIT_ERROR", e.message, null)
        }
    }

    private fun verifySMSCode(code: String, phoneNumber: String, result: MethodChannel.Result) {
        if (!isSDKInitialized(result)) return
        sdk!!.verifySmsCode(code = code, phoneNumber = phoneNumber) { r ->
            r.onSuccess {
                Log.d("AntifraudFlutterPlugin", "SMS code verified successfully")
                result.success("Code verified successfully")
            }
            r.onFailure {
                Log.e("AntifraudFlutterPlugin", "SMS verification failed: ${it.message}")
                result.error("VERIFY_ERROR", it.message, null)
            }
        }
    }


    private fun confirmFace(document: String, birthDate: String, result: MethodChannel.Result) {
        if (!isSDKInitialized(result)) return
        sdk!!.confirmFace(document = document, birthDate = birthDate) { r ->
            r.onSuccess {
                Log.d("AntifraudFlutterPlugin", "Confirm face successfully")
                result.success("Confirm face successfully")
            }
            r.onFailure {
                Log.e("AntifraudFlutterPlugin", "Confirm face verification failed: ${it.message}")
                result.error("VERIFY_ERROR", it.message, null)
            }
        }
    }

    private fun detectFraud(code: String, result: MethodChannel.Result) {
        if (!isSDKInitialized(result)) return
        sdk!!.detectFraud(code = code) { r ->
            r.onSuccess {
                Log.d("AntifraudFlutterPlugin", "Detect fraud successfully")
                result.success("Detect fraud successfully")
            }
            r.onFailure {
                Log.e("AntifraudFlutterPlugin", "SMS verification failed: ${it.message}")
                result.error("DETECT_FRAUD_ERROR", it.message, null)
            }
        }
    }

    private fun logout(result: MethodChannel.Result) {
        if (!isSDKInitialized(result)) return
        sdk!!.logout { r ->
            r.onSuccess {
                Log.d("AntifraudFlutterPlugin", "Logout successful")
                result.success("Logout successful")
            }
            r.onFailure {
                Log.e("AntifraudFlutterPlugin", "Logout failed: ${it.message}")
                result.error("LOGOUT_ERROR", it.message, null)
            }
        }
    }

    private fun makeOperation(result: MethodChannel.Result) {
        if (!isSDKInitialized(result)) return
        sdk!!.makeOperation { r ->
            r.onSuccess {
                Log.d("AntifraudFlutterPlugin", "Make Operation successful")
                result.success("Make Operation successful")
            }
            r.onFailure {
                Log.e("AntifraudFlutterPlugin", "Make Operation failed: ${it.message}")
                result.error("MAKE_OPERATION_ERROR", it.message, null)
            }
        }
    }

    private fun isSDKInitialized(result: MethodChannel.Result): Boolean {
        return if (sdk == null || sdk?.isInitialized() != true) {
            Log.e("AntifraudFlutterPlugin", "SDK is not initialized")
            result.error("INIT_ERROR", "SDK is not initialized. Please initialize first.", null)
            false
        } else {
            true
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}