#  Local Authentication

This's a demonstration repo in order to make it easier for others to implement **LocalAuthentication** sdk in your project, all comments and pulls requests are appreciated.

** Note **
Authenicating user using with FaceID required **NSFaceIDUsageDescription** in Info.plist.

### Sample Code
```
LocalAuthentication.shared.authenticateUserWithBioMetrics(kReasonMessage) { [weak self] (authenticationState) in
    guard let self = self else {
        return
    }
    switch authenticationState {
    case .success:
        self.showAlert("Successfully Authenticated")
    case .canceledByUser, .fallback, .canceledBySystem:
        break
    case .passcodeNotSet:
        self.showAlert(authenticationState.message(), block: { (action) in
            self.redirectUserToSetting()
        })
    default:
        self.showAlert(authenticationState.message())
    }
}
```
