import SwiftUI

struct UserProfile: View {
    // Step 5: Presentation environment
    @Environment(\.presentationMode) var presentation

    // Step 4: Fetching user data
    let firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    let lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    let email = UserDefaults.standard.string(forKey: kEmail) ?? ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Personal information")
                .font(.title)
                .bold()

            Image("profile-image-placeholder")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .shadow(radius: 10)

            Text("First Name: \(firstName)")
            Text("Last Name: \(lastName)")
            Text("Email: \(email)")

            Button("Logout") {
                // Step 5: Log out
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }
            .foregroundColor(.red)

            Spacer()
        }
        .padding()
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
