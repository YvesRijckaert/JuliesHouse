import UIKit
import Alamofire

class CakeDetailViewController: UIViewController {
    var cake: Cake?
    
    //outlets van op je storyboard om content in te vullen
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var cakeDescription: UILabel!
    @IBOutlet weak var cakeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:1.00, green:1.00, blue:0.98, alpha:1.0)
        //de title bovenaan = cake naam
        navigationItem.title = cake?.name
        //cake image
        cakeImageView.image = cake?.image
        //cake description
        cakeDescription.text = cake?.description
        //if let structuur om optional NSNumber variable te tonen als string
        if let kostprijs = cake?.amount {
            amount.text = "€\(String(describing: kostprijs))"
        }
    }
    
    //functie als je op de button klikt om iets te bestellen
    @IBAction func buyButtonPressed(_ sender: Any) {
        //de cake_id van de API = cake id dat we hier binnen krijgen in de detail pagina
        let parameters = [
            "cake_id": cake!.id,
        ]
        //haal de orders op van de API via Alamofire
        //we gaan een nieuwe order plaatsen dus = POST
        //VERANDER HIER NAAR IP ADRES VOOR TESTEN OP I-DEVICE
        Alamofire.request("http://127.0.0.1:4000/orders", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else { return self.alertError() }
                guard let status = response.result.value as? [String: Bool],
                let successful = status["status"] else { return self.alertError() }
                successful ? self.alertSuccess() : self.alertError()
        }
    }
    
    //error weergeven
    func alertError() {
        return self.alert(
            title: "Bestelling mislukt!",
            message: "Het lukte niet om jouw bestelling te maken, probeer opnieuw."
        )
    }
    
    //success melding weergeven
    func alertSuccess() {
        return self.alert(
            title: "Bestelling succesvol",
            message: "Je hebt een bestelling geplaatst."
        )
    }
    
    //de alert functie voor zowel error als success
    func alert(title: String, message: String) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //ga terug naar de list view van de cakes als je klikt op de oké knop
        alertCtrl.addAction(UIAlertAction(title: "Oké", style: .cancel) { action in
            self.navigationController?.popViewController(animated: true)
        })
        present(alertCtrl, animated: true, completion: nil)
    }
}
