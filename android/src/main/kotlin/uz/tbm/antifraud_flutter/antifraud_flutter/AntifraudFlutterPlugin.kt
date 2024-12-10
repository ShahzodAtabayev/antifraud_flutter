package uz.tbm.antifraud_flutter.antifraud_flutter

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import uz.tbm.antifraudmobilesdk.AntiFraudLibrary
import uz.tbm.antifraudmobilesdk.model.public.AntiFraudConfiguration

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
                val tokenType = call.argument<String>("token_type") ?: ""
                val accessToken = call.argument<String>("access_token") ?: ""
                initializeSDK(call.context(), host, tokenType, accessToken, result)
            }

            "verify_sms_code" -> {
                val code = call.argument<String>("code") ?: ""
                val phoneNumber = call.argument<String>("phone_number") ?: ""
                verifySMSCode(code, phoneNumber, result)
            }

            "logout" -> logout(result)

            "refresh_token" -> {
                val token = call.argument<String>("token") ?: ""
                refreshToken(token, result)
            }

            else -> result.notImplemented()
        }
    }

    private fun initializeSDK(
        context: Context,
        host: String,
        tokenType: String,
        accessToken: String,
        result: MethodChannel.Result
    ) {
        try {
            sdk = AntiFraudLibrary(
                host = host,
                context = context,
                contentResolver = context.contentResolver
            )
            val config = AntiFraudConfiguration(tokenType = tokenType, accessToken = accessToken)
            sdk!!.initialize(config) { r ->
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

    private fun refreshToken(token: String, result: MethodChannel.Result) {
        if (!isSDKInitialized(result)) return
        sdk!!.refreshToken(token).fold(
            onSuccess = {
                Log.d("AntifraudFlutterPlugin", "Token refreshed successfully")
                result.success("Token refreshed successfully")
            },
            onFailure = {
                Log.e("AntifraudFlutterPlugin", "Token refresh failed: ${it.message}")
                result.error("REFRESH_TOKEN_ERROR", it.message, null)
            }
        )
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