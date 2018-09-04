import Foundation
struct Order {
    let id: String
    let cake: Cake
    var status: OrderStatus
}
enum OrderStatus: String {
    case afwachting = "In afwachting"
    case aanvaard = "Aanvaard"
    case onderweg = "Onderweg"
    case aangekomen = "Aangekomen"
}
