import UIKit
import GoogleMaps

protocol MapViewControllerProtocol {
    func getLocation(location: MapViewModel.Location)
    func getAddress(location: MapViewModel.Location)
}

class MapViewController: UIViewController {
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var mapCenterPinImage: UIImageView!
    @IBOutlet private weak var pinImageVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addView: UIView!
    
    //timerView
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    //saveView
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var okLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!

    //confirmationView
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var timerSaveLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var diatanceLabel: UILabel!
    
    var timer:Timer = Timer()
    var seconds: Int = 0
    var typeRequest:MapViewModel.TypeRequest = .noRoute
    var isTest = true
    let starLocationTest = CLLocation(latitude: -16.384376, longitude: -71.550363)
    let finishLocationTest = CLLocation(latitude: -16.387243958956638, longitude: -71.54956296086311)
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var routesPersistence: [RoutePersistence] = []
    
    private var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    private let locationManager = CLLocationManager()
    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 1000
    private var route:MapViewModel.Route?
    private var presenter:MapViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MapViewPresenter(view: self)
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        mapView.delegate = self
        timerView.layer.cornerRadius = 24
        saveView.layer.cornerRadius = 24
        confirmationView.layer.cornerRadius = 24
        resetState()
    }
    
    @IBAction func starAction(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: true)
        stopLabel.textColor = UIColor.orange
        starLabel.textColor = UIColor.gray
        starButton.isEnabled = false
        stopButton.isEnabled = true
        typeRequest = .initLocation
        locationManager.requestLocation()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        timer.invalidate()
        starLabel.textColor = UIColor.orange
        stopLabel.textColor = UIColor.gray
        starButton.isEnabled = true
        stopButton.isEnabled = false
        typeRequest = .finishLocation
        locationManager.requestLocation()
    }
    
    @IBAction func storeAction(_ sender: Any) {
        saveView.hide()
        guard let route = route else {
            return
        }
        let routePerssitence = RoutePersistence(context: MapViewController.context)
        routePerssitence.setRoute(route: route)
        try! MapViewController.context.save()
        confirmationView.show()
    }
    
    fileprivate func resetState() {
        route = nil
        typeRequest = .noRoute
        seconds = 0
        saveView.hide()
        confirmationView.hide()
        timerView.hide()
        addView.show()
        addButton.show()
        locationManager.requestLocation()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        resetState()
    }
    
    @IBAction func okAction(_ sender: Any) {
        resetState()
    }
    
    @objc func timerEvent() {
        seconds = seconds + 1
        let timer = MapViewModel.Timer(mySeconds: seconds)
        timerLabel.text = timer.toString()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let navigationController = segue.destination as? UINavigationController,
            let controller = navigationController.topViewController as? TypesTableViewController
        else {
            return
        }
        controller.selectedTypes = searchedTypes
        controller.delegate = self
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        timerView.show()
        addButton.hide()
        addView.hide()
        let timer = MapViewModel.Timer(mySeconds: 0)
        timerLabel.text = timer.toString()
    }
    
    func showSaveRoute() {
        timerView.hide()
        saveView.show()
        guard let route = route else {
            return
        }
        guard let timer = route.timer else {
            return
        }
        timerSaveLabel.text = timer.toString()
        let distance = route.getDistanceKms().toString(decimal: 2)
        diatanceLabel.text = "\(distance) km"
    }
}

// MARK: - Actions
extension MapViewController {
    @IBAction func refreshPlaces(_ sender: Any) {
        fetchPlaces(near: mapView.camera.target)
    }
    
    func fetchPlaces(near coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        
        dataProvider.fetchPlaces(
            near: coordinate,
            radius: searchRadius,
            types: searchedTypes
        ) { places in
            places.forEach { place in
                let marker = PlaceMarker(place: place, availableTypes: self.searchedTypes)
                marker.map = self.mapView
            }
        }
    }
}

// MARK: - TypesTableViewControllerDelegate
extension MapViewController: TypesTableViewControllerDelegate {
    func typesController(_ controller: TypesTableViewController, didSelectTypes types: [String]) {
        searchedTypes = controller.selectedTypes.sorted()
        dismiss(animated: true)
        fetchPlaces(near: mapView.camera.target)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.requestLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard var location = locations.first else {
            return
        }
        
        if isTest {
            switch self.typeRequest {
            case .initLocation:
                location = starLocationTest
            case .finishLocation:
                location = finishLocationTest
            case .noRoute:
                break
            }
        }
        
        switch self.typeRequest {
        case .initLocation:
            self.presenter?.getLocation(coordinate: location.coordinate)
        case .finishLocation:
            self.presenter?.getLocation(coordinate: location.coordinate)
        case .noRoute:
            break
        }
        
        mapView.camera = GMSCameraPosition(
            target: location.coordinate,
            zoom: 15,
            bearing: 0,
            viewingAngle: 0)
        fetchPlaces(near: location.coordinate)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        presenter?.getAddress(coordinate: position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        addressLabel.lock()
        
        if gesture {
            mapCenterPinImage.fadeIn(0.25)
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let placeMarker = marker as? PlaceMarker else {
            return nil
        }
        guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else {
            return nil
        }
        
        infoView.nameLabel.text = placeMarker.place.name
        infoView.addressLabel.text = placeMarker.place.address
        
        return infoView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapCenterPinImage.fadeOut(0.25)
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        mapCenterPinImage.fadeIn(0.25)
        mapView.selectedMarker = nil
        return false
    }
}

extension MapViewController: MapViewControllerProtocol {
    func getLocation(location: MapViewModel.Location) {
        switch self.typeRequest {
        case .initLocation:
            let id = getId()
            route = MapViewModel.Route(id: id, source: location, destination: nil, timer: nil)
            self.typeRequest = .noRoute
        case .finishLocation:
            if let source = route?.source {
                let timer = MapViewModel.Timer(mySeconds: seconds)
                let id = getId()
                route = MapViewModel.Route(id: id, source: source, destination: location, timer: timer)
                self.showSaveRoute()
                self.typeRequest = .noRoute
            }
        case .noRoute:
            break
        }
        //UI
        getAddress(location: location)
    }
    func getAddress(location: MapViewModel.Location) {
        //UI
        self.addressLabel.unlock()
        self.addressLabel.text = location.address
        
        let labelHeight = self.addressLabel.intrinsicContentSize.height
        let topInset = self.view.safeAreaInsets.top
        self.mapView.padding = UIEdgeInsets(
            top: topInset,
            left: 0,
            bottom: labelHeight,
            right: 0)
        
        UIView.animate(withDuration: 0.25) {
            self.pinImageVerticalConstraint.constant = (labelHeight - topInset) * 0.5
            self.view.layoutIfNeeded()
        }
    }
}
