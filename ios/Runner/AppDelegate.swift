import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  /// Blur over the app while it is in the app switcher or the screen is
  /// being recorded or mirrored (iOS can't block screenshots).
  private var privacyView: UIView?
  private var isInactive = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenCaptureChanged),
      name: UIScreen.capturedDidChangeNotification,
      object: nil
    )
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationWillResignActive(_ application: UIApplication) {
    super.applicationWillResignActive(application)
    isInactive = true
    updatePrivacyView()
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    isInactive = false
    updatePrivacyView()
  }

  @objc private func screenCaptureChanged() {
    updatePrivacyView()
  }

  private func updatePrivacyView() {
    let hide = isInactive || UIScreen.main.isCaptured
    if hide, privacyView == nil, let window = window {
      let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
      blur.frame = window.bounds
      blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      window.addSubview(blur)
      privacyView = blur
    } else if !hide {
      privacyView?.removeFromSuperview()
      privacyView = nil
    }
  }
}
