import UIKit
struct Cake {
    let id: String
    let name: String
    let description: String
    let amount: NSNumber
    let image: UIImage
    init(data: [String: Any]) {
        self.id = data["id"] as! String
        self.name = data["name"] as! String
        self.amount = data["amount"] as! NSNumber
        self.description = data["description"] as! String
        self.image = data["image"] as! UIImage
    }
}
