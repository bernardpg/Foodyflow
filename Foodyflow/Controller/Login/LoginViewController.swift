//
//  LoginViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/28/22.
//

import UIKit
import SnapKit
import AuthenticationServices
import FirebaseAuth
import Firebase
import FirebaseFirestore
import CryptoKit

class LoginViewController: UIViewController {
    
    private lazy var appleButton = UIButton()
    private lazy var googleButton = UIButton()
    private lazy var appOutsideIcon = UIView()
    private lazy var appIcon = UIImageView()
    
    lazy var licenseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.isUserInteractionEnabled = true
        
        let stringValue = "By continuing, you agree to our Privacy Police and Apple EULA"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColor(color: UIColor.FoodyFlow.lightOrange, forText: "Privacy Police")
        attributedString.setColor(color: UIColor.FoodyFlow.lightOrange, forText: "EULA")
        label.attributedText = attributedString
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel))
        label.addGestureRecognizer(tap)
        return label
    }()

 //   private lazy var licenseLabel
    
    var userManager = UserManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSignInWithAppleButton()
        observeAppleIDState()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        view.backgroundColor = UIColor.FoodyFlow.darkOrange
        
    }
    
    func setSignInWithAppleButton() {
        
        view.addSubview(appOutsideIcon)
        appOutsideIcon.snp.makeConstraints { make in
//            make.top.equalTo(view).offset(200)
//            make.bottom.equalTo(googleButton.snp.top).offset(151)
//            make.leading.equalTo(view).offset(109)
            make.centerY.equalTo(view).offset(-50)
            make.centerX.equalTo(view)
//            make.trailing.equalTo(view).offset(90)
            make.width.equalTo(400)
            make.height.equalTo(400)
            
        }
        
        appOutsideIcon.lkCornerRadius = 20
        
        appOutsideIcon.addSubview(appIcon)
        appIcon.snp.makeConstraints { make in
            make.edges.equalTo(appOutsideIcon).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        appIcon.image = UIImage(named: "Frame")
        
        view.addSubview(googleButton)
        googleButton.isHidden = true 
        googleButton.lkCornerRadius = 20
        googleButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(100)
            make.width.equalTo(271)
            make.height.equalTo(53)
        }
        googleButton.backgroundColor = .systemBlue
        
        let signInWithAppleBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn,
                                                              authorizationButtonStyle: chooseAppleButtonStyle())
        view.addSubview(signInWithAppleBtn)
        signInWithAppleBtn.snp.makeConstraints { make in
            make.top.equalTo(googleButton.snp.bottom).offset(17)
            make.centerX.equalTo(googleButton.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        signInWithAppleBtn.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
//        appleButton.setImage(UIImage(named: "appleidButton"), for: .normal)
        
        self.view.addSubview(licenseLabel)
        licenseLabel.snp.makeConstraints { make in
            make.top.equalTo(signInWithAppleBtn.snp.bottom).offset(10)
            make.centerX.equalTo(signInWithAppleBtn.snp.centerX)
            make.width.equalTo(271)
            make.height.equalTo(50)
            /*
             let signInWithAppleBtn =
             ASAuthorizationAppleIDButton(authorizationButtonType: .signIn,
                                                                   authorizationButtonStyle: chooseAppleButtonStyle())
             */
        }
        
    }
    
    func observeAppleIDState() {
        
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
                                               object: nil,
                                               queue: nil) { (notification: Notification) in
            CustomFunc.customAlert(title: "使用者登入或登出",
                                   message: "",
                                   vc: self,
                                   actionHandler: nil)
        }
    }
    
    @objc func createVC() {
        let createVC = CreatePersonViewController()
        present(createVC, animated: true)
    }
    
    @objc private func tapLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = licenseLabel.text else { return }
        let privacyRange = (text as NSString).range(of: "Privacy Police")
        let standardRange = (text as NSString).range(of: "EULA")
        
        var webVC: WebViewController
        if gesture.didTapAttributedTextInLabel(label: licenseLabel, inRange: privacyRange) {
            webVC = WebViewController(urlString: "https://www.privacypolicies.com/live/f47437a1-9d69-4959-bebe-f50c1928bcaf")
        } else if gesture.didTapAttributedTextInLabel(label: licenseLabel, inRange: standardRange) {
            webVC = WebViewController(urlString: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")
        } else {
            return
        }
        self.present(webVC, animated: true, completion: nil)
    }

    
    func chooseAppleButtonStyle() -> ASAuthorizationAppleIDButton.Style {
        return (UITraitCollection.current.userInterfaceStyle == .light) ? .black : .white // 淺色模式就顯示黑色的按鈕，深色模式就顯示白色的按鈕
    }
    // MARK: - Sign in with Apple 登入
    fileprivate var currentNonce: String?
    
    @objc func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
           authorizationController.delegate = self
           authorizationController.presentationContextProvider = self
           authorizationController.performRequests()
        
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        while ( remainingLength > 0 ) {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes( kSecRandomDefault, 1, &random )
                if ( errorCode != errSecSuccess ) {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if (remainingLength == 0) {
                    return
                }

                if (random < charset.count) {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        // 登入成功
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                CustomFunc.customAlert(title: "",
                                       message: "Unable to fetch identity token",
                                       vc: self,
                                       actionHandler: nil)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                CustomFunc.customAlert(title: "",
                                       message: "Unable to serialize token from data\n\(appleIDToken.debugDescription)",
                                       vc: self,
                                       actionHandler: nil)
                return
            }
            // 產生 Apple ID 登入的 Credential
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString, rawNonce: nonce)
            // 與 Firebase Auth 進行串接
            firebaseSignInWithApple(credential: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 登入失敗，處理 Error
        switch error {
        case ASAuthorizationError.canceled:
            CustomFunc.customAlert(title: "使用者取消登入", message: "", vc: self, actionHandler: nil)
            break
        case ASAuthorizationError.failed:
            CustomFunc.customAlert(title: "授權請求失敗", message: "", vc: self, actionHandler: nil)
            break
        case ASAuthorizationError.invalidResponse:
            CustomFunc.customAlert(title: "授權請求無回應", message: "", vc: self, actionHandler: nil)
            break
        case ASAuthorizationError.notHandled:
            CustomFunc.customAlert(title: "授權請求未處理", message: "", vc: self, actionHandler: nil)
            break
        case ASAuthorizationError.unknown:
            CustomFunc.customAlert(title: "授權失敗，原因不知", message: "", vc: self, actionHandler: nil)
            break
        default:
            break
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
// 在畫面上顯示授權畫面
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

extension LoginViewController {
    // MARK: - 透過 Credential 與 Firebase Auth 串接
    func firebaseSignInWithApple(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            guard error == nil else {
                CustomFunc.customAlert(title: "",
                                       message: "\(String(describing: error!.localizedDescription))",
                                       vc: self,
                                       actionHandler: nil)
                return
            }
            let userID = Auth.auth().currentUser?.uid
            let userEmail = Auth.auth().currentUser?.email
            let userInfo = UserInfo.init(userID: userID ?? "",
                                         userName: "Ryan",
                                         userEmail: userEmail ?? "" ,
                                         userPhoto: "",
                                            signInType: "",
                                         personalRefrige: [],
                                         personalLikeRecipe: [],
                                         personalDoRecipe: [], blockLists: [])
            
            self.userManager.fetchUserInfo(fetchUserID: userID!) { result in
                switch result {
                case.success:
                      print("success")
                    
                case .failure:
                    self.userManager.addUserInfo(user: userInfo)
                    print("error")
                }
            }
            
            let db = Firestore.firestore().collection("User")
            
//            guard let userID = userID else { return }
            
            db.whereField("userID", isEqualTo: userID ).getDocuments { (querySnapshot, error) in
                if let doc = querySnapshot?.documents.first {
                    print("ok")
                } else {
                    self.userManager.addUserInfo(user: userInfo)
                }
            }
            
            CustomFunc.customAlert(title: "登入成功！", message: "", vc: self, actionHandler: self.getFirebaseUserInfo)
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - Firebase 取得登入使用者的資訊
    func getFirebaseUserInfo() {
        let currentUser = Auth.auth().currentUser
        guard let user = currentUser else {
            CustomFunc.customAlert(title: "無法取得使用者資料！", message: "", vc: self, actionHandler: nil)
            return
        }
        let uid = user.uid
        let email = user.email
        
        CustomFunc.customAlert(title: "使用者資訊", message: "UID：\(uid)\nEmail：\(email!)", vc: self, actionHandler: nil)
    }
}

class CustomFunc {
    /// 提示框
    /// - Parameters:
    ///   - title: 提示框標題
    ///   - message: 提示訊息
    ///   - vc: 要在哪一個 UIViewController 上呈現
    ///   - actionHandler: 按下按鈕後要執行的動作，沒有的話就填 nil
    class func customAlert(title: String, message: String,
                           vc: UIViewController,
                           actionHandler: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "關閉",
                                            style: .default) { _ in
                actionHandler?()
            }
            alertController.addAction(closeAction)
            vc.present(alertController, animated: true)
        }
    }

    // MARK: - 取得送出/更新留言的當下時間
    class func getSystemTime() -> String {
        let currectDate = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        return dateFormatter.string(from: currectDate)
    }
}
