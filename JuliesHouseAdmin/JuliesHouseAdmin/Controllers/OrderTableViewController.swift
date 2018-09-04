import UIKit
import Alamofire

class OrdersTableViewController: UITableViewController {
    var orders: [Order] = []
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Bestellingen"
        //haal de orders 1 keer op bij het opstarten
        self.getOrders()
        //haal de orders elke 4 seconden opnieuw op
        self.timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { (timer) in
            self.getOrders()
        })
    }
    
    func getOrders() {
        fetchOrders { orders in
            self.orders = orders!
            self.tableView.reloadData()
        }
    }
    
    //haal orders op van de API via Alamofire
    private func fetchOrders(completion: @escaping([Order]?) -> Void) {
        //VERANDER HIER NAAR IP ADRES VOOR TESTEN OP I-DEVICE
        Alamofire.request("http://127.0.0.1:4000/orders").validate().responseJSON { response in
            guard response.result.isSuccess else { return completion(nil) }
            guard let rawOrders = response.result.value as? [[String: Any]?] else { return completion(nil) }
            let orders = rawOrders.compactMap { ordersDict -> Order? in
            guard let orderId = ordersDict!["id"] as? String,
            let orderStatus = ordersDict!["status"] as? String,
            var cake = ordersDict!["cake"] as? [String: Any] else { return nil }
            cake["image"] = UIImage(named: cake["image"] as! String)
            return Order(
                id: orderId,
                cake: Cake(data: cake),
                status: OrderStatus(rawValue: orderStatus)!
            )
            }
            completion(orders)
        }
    }
    
    //table methods
    
    //aantal sections is 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //aantal rijen = aantal orders
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    //content opvullen met de juiste order a.d.h.v. identifier order via storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for: indexPath)
        let order = orders[indexPath.row]
        cell.textLabel?.text = order.cake.name
        cell.imageView?.image = order.cake.image
        cell.detailTextLabel?.text = "€\(order.cake.amount) - \(order.status.rawValue)"
        return cell
    }
    
    //hoe hoog / groot is een cell?
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    //als je klikt op een cell kan je de status veranderen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //haal de juiste order op (diegene waarop geklikt werd)
        let order: Order = orders[indexPath.row]
        
        //info bericht
        let alertCtrl = UIAlertController(
            title: "Wijzig bestelling",
            message: "Wijzig de status van de bestelling op basis van de voortgang.",
            preferredStyle: .actionSheet
        )
        //afwachting button
        alertCtrl.addAction(createActionForStatus(.afwachting, order: order))
        //aanvaard button
        alertCtrl.addAction(createActionForStatus(.aanvaard, order: order))
        //onderweg button
        alertCtrl.addAction(createActionForStatus(.onderweg, order: order))
        //aangekomen button
        alertCtrl.addAction(createActionForStatus(.aangekomen, order: order))
        //cancel button
        alertCtrl.addAction(createActionForStatus(nil, order: nil))
        //toon de alert control
        present(alertCtrl, animated: true, completion: nil)
    }
    
    
    //
    func createActionForStatus(_ status: OrderStatus?, order: Order?) -> UIAlertAction {
        //als de alertitle nil is dan is de title cancel, anders is het de raw value van de status
        let alertTitle = status == nil ? "Cancel" : status?.rawValue
        //de alertstyle is UIAlertActionStyle en als de alertstatus nil is dan is het cancel, anders is het default
        let alertStyle: UIAlertActionStyle = status == nil ? .cancel : .default
        //de title is alertTitle en style is alertStle
        let action = UIAlertAction(title: alertTitle, style: alertStyle) { action in
            if status != nil {
                self.setStatus(status!, order: order!)
            }
        }
        if status != nil {
            action.isEnabled = status?.rawValue != order?.status.rawValue
        }
        return action
    }
    
    
    func setStatus(_ status: OrderStatus, order: Order) {
        updateOrderStatus(status, order: order) { successful in
            guard successful else { return }
            guard let index = self.orders.index(where: {$0.id == order.id}) else { return }
            self.orders[index].status = status
            self.tableView.reloadData()
        }
    }
    
    //update the order to the API
    func updateOrderStatus(_ status: OrderStatus, order: Order, completion: @escaping(Bool) -> Void) {
        //VERANDER HIER NAAR IP ADRES VOOR TESTEN OP I-DEVICE
        let url = "http://127.0.0.1:4000/orders/" + order.id
        let params = ["status": status.rawValue]
        Alamofire.request(url, method: .put, parameters: params).validate().responseJSON { response in
            guard response.result.isSuccess else { return completion(false) }
            guard let data = response.result.value as? [String: Bool] else { return completion(false) }
            completion(data["status"]!)
        }
    }
    
    //verwijderen van bestellingen
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cakeId = orders[indexPath.row].id
            //VERANDER HIER NAAR IP ADRES VOOR TESTEN OP I-DEVICE
            Alamofire.request("http://127.0.0.1:4000/orders/\(cakeId)", method: .delete)
                .responseJSON { response in
                    guard response.result.error == nil else {
                        print("error calling DELETE on /todos/1")
                        print(response.result.error!)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.reloadData()
                        return
                    }
                    print("DELETE ok")
            }
        }
    }
}
