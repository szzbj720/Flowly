import Foundation

struct UserSettings: Codable {
    var themeColorHex: String  // e.g. "EEBA00"
    // Optionally, you can add other settings like a profile image (as Data)
    var profileImageData: Data?
}


