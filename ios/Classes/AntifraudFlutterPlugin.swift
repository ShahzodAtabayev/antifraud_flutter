import AntiFraud_Mobile_SDK
import Flutter
import UIKit

public class AntifraudFlutterPlugin: NSObject, FlutterPlugin {
    private var library: AntiFraudLibrary?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "antifraud_flutter", binaryMessenger: registrar.messenger())
        let instance = AntifraudFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(
        _ call: FlutterMethodCall, result: @escaping FlutterResult
    ) {
        switch call.method {
        case "initialize":
            guard let args = call.arguments as? [String: Any],
                let host = args["host"] as? String
            else {
                result(
                    FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid arguments passed", details: nil))
                return
            }
            initialize(host: host, result: result)
            return
        case "initialized":
            isInitialized(result: result)
            return
        case "verify_sms_code":
            guard let args = call.arguments as? [String: Any],
                let phoneNumber = args["phone_number"] as? String,
                let smsCode = args["code"] as? String
            else {
                result(
                    FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid arguments passed", details: nil))
                return
            }
            verifySmsCode(
                phoneNumber: phoneNumber, smsCode: smsCode, result: result)
            return
        case "detect_fraud":
            guard let args = call.arguments as? [String: Any],
                let smsCode = args["code"] as? String
            else {
                result(
                    FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid arguments passed", details: nil))
                return
            }
            detectFraud(smsCode: smsCode, result: result)
            return
            
        case "make_operation":
            makeOperation(result: result)
            return
        case "confirm_face":
            guard let args = call.arguments as? [String: Any],
                let document = args["document"] as? String,
                let birthDate = args["birth_date"] as? String
            else {
                result(
                    FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid arguments passed", details: nil))
                return
            }
            confirmFace(birthDate: birthDate, document: document, result: result)
            return
        case "logout":
            logout(result: result)
            return
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func initialize(host: String, result: @escaping FlutterResult) {
        library = AntiFraudLibrary(host: host)

        library?.initialization { response in
            switch response {
            case .success:
                result("SDK Initialized successfully")
            case .failure(let error):
                result(
                    FlutterError(
                        code: "INIT_ERROR", message: error.localizedDescription,
                        details: nil))
            @unknown default:
                result(
                    FlutterError(
                        code: "INIT_ERROR", message: "BASE_ERROR", details: nil)
                )
            }
        }
    }
    private func isInitialized(result: @escaping FlutterResult) {
        let isInitialized = library?.isInitialized()
        result(isInitialized ?? false)
    }

    private func verifySmsCode(
        phoneNumber: String, smsCode: String, result: @escaping FlutterResult
    ) {
        guard let library = library else {
            result(
                FlutterError(
                    code: "INIT_ERROR", message: "SDK is not initialized",
                    details: nil))
            return
        }
        library.verifySmsCode(phoneNumber: phoneNumber, smsCode: smsCode) {
            response in
            switch response {
            case .success:
                result("Verified successfully")
            case .failure(let error):
                result(
                    FlutterError(
                        code: "VERIFY_ERROR",
                        message: error.localizedDescription, details: nil))
            @unknown default:
                result(
                    FlutterError(
                        code: "INIT_ERROR", message: "BASE_ERROR", details: nil)
                )
            }

        }
    }

    private func confirmFace(
        birthDate: String, document: String, result: @escaping FlutterResult
    ) {
        guard let library = library else {
            result(
                FlutterError(
                    code: "INIT_ERROR", message: "SDK is not initialized",
                    details: nil))
            return
        }
        library.confirmFace(birthDate: birthDate, document: document) {
            response in
            switch response {
            case .success:
                result("Confirmed successfully")
            case .failure(let error):
                result(
                    FlutterError(
                        code: "CONFIRM_FACE_ERROR",
                        message: error.localizedDescription, details: nil))
            @unknown default:
                result(
                    FlutterError(
                        code: "INIT_ERROR", message: "BASE_ERROR", details: nil)
                )
            }

        }
    }

    private func detectFraud(smsCode: String, result: @escaping FlutterResult) {
        guard let library = library else {
            result(
                FlutterError(
                    code: "INIT_ERROR", message: "SDK is not initialized",
                    details: nil))
            return
        }
        library.detectFraud(smsCode: smsCode) { response in
            switch response {
            case .success:
                result("Transaction verified successfully")
            case .failure(let error):
                result(
                    FlutterError(
                        code: "DETECT_FRAUD_ERROR",
                        message: error.localizedDescription, details: nil))
            @unknown default:
                result(
                    FlutterError(
                        code: "INIT_ERROR", message: "BASE_ERROR", details: nil)
                )
            }
        }
    }

    private func makeOperation(result: @escaping FlutterResult) {
        guard let library = library else {
            result(
                FlutterError(
                    code: "INIT_ERROR", message: "SDK is not initialized",
                    details: nil))
            return
        }
        library.makeOperation { response in
            switch response {
            case .success:
                result("Session id update successfully")
            case .failure(let error):
                result(
                    FlutterError(
                        code: "MAKE_OPERATION_ERROR",
                        message: error.localizedDescription, details: nil))
            @unknown default:
                result(
                    FlutterError(
                        code: "INIT_ERROR", message: "BASE_ERROR", details: nil)
                )
            }

        }
    }

    private func logout(result: @escaping FlutterResult) {
        guard let library = library else {
            result(
                FlutterError(
                    code: "INIT_ERROR", message: "SDK is not initialized",
                    details: nil))
            return
        }
        library.logout { response in
            switch response {
            case .success:
                result("Logged out successfully")
            case .failure(let error):
                result(
                    FlutterError(
                        code: "LOGOUT_ERROR",
                        message: error.localizedDescription, details: nil))
            @unknown default:
                result(
                    FlutterError(
                        code: "INIT_ERROR", message: "BASE_ERROR", details: nil)
                )
            }
        }
    }
}
