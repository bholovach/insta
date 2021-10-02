import Foundation

struct Stories: Codable {
    let downloadLinks: [Item]
}

struct Item: Codable {
    let url: String
    let mediaType: String
}
