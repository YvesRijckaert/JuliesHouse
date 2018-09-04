import UIKit
import Alamofire

class CakeListTableViewController: UITableViewController {
    var cakes: [Cake] = []
    var timer: Timer?

    //outlet van winkelkarretje
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:1.00, green:1.00, blue:0.98, alpha:1.0)
        navigationItem.title = "Taarten"
        //haal de taarten op voor de eerste ker
        self.getMenu()
        //haal de taarten elke 4 seconden opnieuw op
        self.timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { (timer) in
            self.getMenu()
        })
    }
    
    
    func getMenu() {
        fetchInventory { cakes in
            guard cakes != nil else { return }
            self.cakes = cakes!
            self.tableView.reloadData()
        }
    }
    
    //ophalen van de API via Alamofire
    func fetchInventory(completion: @escaping ([Cake]?) -> Void) {
        //VERANDER HIER NAAR IP ADRES VOOR TESTEN OP I-DEVICE
        Alamofire.request("http://127.0.0.1:4000/inventory", method: .get)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else { return completion(nil) }
                guard let rawMenu = response.result.value as? [[String: Any]?] else { return completion(nil) }
                let menu = rawMenu.compactMap { cakeDict -> Cake? in
                    var data = cakeDict!
                    data["image"] = UIImage(named: cakeDict!["image"] as! String)
                    return Cake(data: data)
                }
                completion(menu)
        }
    }
    
    //overgang voor klikken op orders knop
    @IBAction func ordersButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "orders", sender: nil)
    }
    
    //table view methods
    
    //aantal sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //aantal rijen = aantal cakes
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cakes.count
    }
    
    //de content opvullen van de cell via identifier in storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cake", for: indexPath) as! CakeTableViewCell
        cell.name.text = cakes[indexPath.row].name
        cell.imageView?.image = cakes[indexPath.row].image
        cell.amount.text = "€\(cakes[indexPath.row].amount)"
        cell.descriptionText.text = cakes[indexPath.row].description
        return cell
    }
    
    //hoe hoog / groot is de cell?
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    //als je klikt op de cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cakeDetail", sender: self.cakes[indexPath.row] as Cake)
    }

    //checken of het CakeDetailViewController is, zo ja dan stuur je de juiste cake mee
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cakeDetail" {
            guard let vc = segue.destination as? CakeDetailViewController else { return }
            vc.cake = sender as? Cake
        }
    }
}
