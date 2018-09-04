import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    struct ResponseData: Decodable {
        var locatie: [Locatie]
    }
    struct Locatie : Decodable {
        var title: String
        var lat: Double
        var long: Double
    }
    
    func loadJson(filename fileName: String) -> [Locatie]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.locatie
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    @IBOutlet weak var myMapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let data = loadJson(filename: "locaties")
        
        //center coordinate = hoofdplaats van Julie's House (kraanlei 13)
        myMapView.centerCoordinate = CLLocationCoordinate2D(latitude: 51.0568383, longitude: 3.7217368)
        
        //hoe ver uitgezoomed?
        myMapView.region = MKCoordinateRegionMakeWithDistance(myMapView.centerCoordinate, 100000, 100000)
        
        //annotation voor de hoofdplaats
        let annotation = MKPointAnnotation()
        annotation.coordinate = myMapView.centerCoordinate
        annotation.title = "Julie's House"
        annotation.subtitle = "Onze hoofdbakkerij"
        myMapView.addAnnotation(annotation)
        
        //alle andere verkooppunten via JSON
        data?.forEach { locatie in
            let plek = CityLocation(title: locatie.title, coordinate: CLLocationCoordinate2D(latitude: locatie.lat, longitude:locatie.long))
            myMapView.addAnnotation(plek)
        }
    }
}
