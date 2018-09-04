import UIKit
import Alamofire

class OrdersTableViewController: UITableViewController {
    var orders: [Order] = []
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:1.00, green:1.00, blue:0.98, alpha:1.0)
        navigationItem.title = "Bestellingen"
        //haal de orders al 1 keer op bij het opstarten
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
    
    //haal de orders op via Alamofire
    func fetchOrders(completion: @escaping([Order]?) -> Void) {
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
    
    //klik op het kruisje rechts bovenaan
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //table view methods
    
    //aantal secties
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //aantal rijen = aantal orders
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    //content opvullen van de cellen met identifier order in storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //je kan niet klikken op de tableView
        tableView.allowsSelection = false
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for: indexPath)
        //haal de juiste order op
        let order = orders[indexPath.row]
        //de titel van de order
        cell.textLabel?.text = order.cake.name
        //de image van de order
        cell.imageView?.image = order.cake.image
        //de detail text van de order met status erbij
        cell.detailTextLabel?.text = "€\(order.cake.amount) - \(order.status.rawValue)"
        return cell
    }
    
    //hoe hoog / groot is de cell?
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
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
