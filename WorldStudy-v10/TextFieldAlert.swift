//
//  TextFieldAlert.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/23/25.
//

import SwiftUI
import UIKit

struct TextFieldAlert {
    var title: String
    var message: String?
    var placeholder: String = ""
    var action: (String?) -> Void
}

//UIKit 브리지
struct TextFieldWrapper: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let alert: TextFieldAlert

    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard context.coordinator.alertShown == false, isPresented else { return }

        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = alert.placeholder
            textField.isSecureTextEntry = true
        }

        alertController.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
            isPresented = false
        })

        alertController.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            let text = alertController.textFields?.first?.text
            alert.action(text)
            isPresented = false
        })

        context.coordinator.alertShown = true
            uiViewController.present(alertController, animated: true) {
                context.coordinator.alertShown = false
            }
        }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator {
        var alertShown = false
    }
}
