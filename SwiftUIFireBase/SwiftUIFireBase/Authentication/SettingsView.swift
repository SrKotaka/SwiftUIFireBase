//
//  SettingsView.swift
//  SwiftUIFireBase
//
//  Created by FELIPE LUVIZOTTO DE CASTRO on 17/05/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject{
    func signOut() throws{
        try AuthenticationManager.shared.signOut()
    }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List{
            Button("Log out"){
                Task{
                    do{
                        try viewModel.signOut()
                        showSignInView = true
                    } catch{
                        print(error)
                    }
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Preview: PreviewProvider{
    static var previews: some View{
        NavigationStack{
            SettingsView(showSignInView: .constant(false))
        }
    }
}
