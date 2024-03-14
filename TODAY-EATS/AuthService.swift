import FirebaseCore
import FirebaseAuth
import CryptoKit
import AuthenticationServices



class AuthService: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    
    enum AuthState {
        case authenticated // Anonymously authenticated in Firebase.
        case signedIn // Authenticated in Firebase using one of service providers, and not anonymous.
        case signedOut // Not authenticated in Firebase.
    }
    
    @Published var signedIn: Bool = false
    @Published var signInSuccess: Bool = false // 로그인 성공 여부를 나타내는 새로운 상태 변수
    
    @Published var user: User?
    @Published var authState : AuthState = .signedOut
    
    private var authStateHandle: AuthStateDidChangeListenerHandle!

    // Unhashed nonce.
    var currentNonce: String?
    
    override init() {
        super.init()

        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                if UserDefaults.standard.bool(forKey: "login") {
                    self.authState = .signedIn
                    print("Auth state changed, is signed in")

                }else{
                    self.authState = .authenticated

                }

            } else {
                self.signedIn = false
                self.authState = .signedOut
                print("Auth state changed, is signed out")
            }
        }
    }
    // MARK: - 로그아웃

    func signOut() async throws {
        if let user = Auth.auth().currentUser {
            do {
                // TODO: Sign out from signed-in Provider.
                try Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "login")

            }
            catch let error as NSError {
                print("FirebaseAuthError: failed to sign out from Firebase, \(error)")
                throw error
            }
        }
    }
    // MARK: - 탈퇴하기
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
            
        }
        try await user.delete()

    }
    
    // MARK: - Password Account
    // Create, sign in, and sign out from password account functions...
    // 2.


//    // 2.
//    func removeAuthStateListener() {
//        Auth.auth().removeStateDidChangeListener(authStateHandle)
//    }
//
//    // 4.
//    func updateState(user: User?) {
//        self.user = user
//        let isAuthenticatedUser = user != nil
//        let isAnonymous = user?.isAnonymous ?? false
//
//        if isAuthenticatedUser {
//            self.authState = isAnonymous ? .authenticated : .signedIn
//        } else {
//            self.authState = .signedOut
//        }
//    }
//    
    //MARK: - Apple sign in
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    
    // Single-sign-on with Apple
       @available(iOS 13, *)
       func startSignInWithAppleFlow() {
          
           let nonce = randomNonceString()
           currentNonce = nonce
           let appleIDProvider = ASAuthorizationAppleIDProvider()
           let request = appleIDProvider.createRequest()
           request.requestedScopes = [.fullName, .email]
           request.nonce = sha256(nonce)

           let authorizationController = ASAuthorizationController(authorizationRequests: [request])
           authorizationController.delegate = self
           authorizationController.performRequests()
       }
       
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    self.signInSuccess = false // 로그인 실패 처리
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    self.signInSuccess = false // 로그인 실패 처리
                    return
                }

                // Initialize a Firebase credential.
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
                
                // Sign in with Firebase.
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    DispatchQueue.main.async { // 메인 스레드에서 UI 업데이트
                        if error != nil {
                            self.signInSuccess = false // 로그인 실패 처리
                            return
                        }
                        // User is signed in to Firebase with Apple.
                        print("login success")
                        if let user = Auth.auth().currentUser {
                            UserDefaults.standard.set(user.uid, forKey: "uid")
                            UserDefaults.standard.set(user.email, forKey: "email")
                            print(user.email)
                            print(user.uid)


                        }
                        UserDefaults.standard.set(true, forKey: "login")
                        self.signInSuccess = true // 로그인 성공 처리
                        self.authState = .signedIn // 로그인 상태 저장
                    }
                }
            }
        }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        DispatchQueue.main.async { // 메인 스레드에서 UI 업데이트
            self.signInSuccess = false // 로그인 실패 처리
            print("Sign in with Apple errored: \(error)")
        }
    }
}
