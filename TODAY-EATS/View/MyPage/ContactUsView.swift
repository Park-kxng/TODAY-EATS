//
//  ContactUsView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/15/24.
//

import SwiftUI
import MessageUI

struct ContactUsView: View {
    @State private var showingMailCompose = false
    @State private var mailComposeResult: Result<MFMailComposeResult, Error>? = nil
    
    var body: some View {
        MailComposeViewController(emailAddress: "justpark0209@gmail.com", result: self.$mailComposeResult)
            .navigationTitle("1:1 문의하기")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // 뒤로가기 버튼 숨기기
            .navigationBarItems(leading: BackButton(title: "이전"))
    }
}

struct MailComposeViewController: UIViewControllerRepresentable {
    var emailAddress: String
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator
        mailComposeVC.setToRecipients([emailAddress])
        mailComposeVC.toolbar.tintColor = UIColor.black
        mailComposeVC.setMessageBody("투데이츠에게 문의할 내용을 입력해주세요!", isHTML: false)
        return mailComposeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposeViewController
        
        init(_ parent: MailComposeViewController) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                controller.dismiss(animated: true)
            }
            guard error == nil else {
                self.parent.result = .failure(error!)
                return
            }
            self.parent.result = .success(result)
        }
    }
}

#Preview {
    ContactUsView()
}
