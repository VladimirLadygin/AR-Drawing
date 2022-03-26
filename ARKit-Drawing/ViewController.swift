import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // MARK: - Outlets
    @IBOutlet var sceneView: ARSCNView!
    
    // MARK: - properties
    let configuration = ARWorldTrackingConfiguration()
    
    enum ObjectPlacementMode {
        case freeform, plane, image
    }
    
    var objectMode: ObjectPlacementMode = .freeform
    /// The node for the currently selected by the user
    var selectNode: SCNNode?
    
    // MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOptions" {
            let optionsViewController = segue.destination as! OptionsContainerViewController
            optionsViewController.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    // MARK: - Actions
    @IBAction func changeObjectMode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            objectMode = .freeform
        case 1:
            objectMode = .plane
        case 2:
            objectMode = .image
        default:
            break
        }
    }
    
    
}
// MARK: - optionsViewContrillerDelegate
extension ViewController: OptionsViewControllerDelegate {
    
    func objectSelected(node: SCNNode) {
        dismiss(animated: true, completion: nil)
        selectNode = node
    }
    
    func togglePlaneVisualization() {
        dismiss(animated: true, completion: nil)
    }
    
    func undoLastObject() {
        
    }
    
    func resetScene() {
        dismiss(animated: true, completion: nil)
    }
}
