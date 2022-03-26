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
    var selectedNode: SCNNode?
    
    // MARK: - Methods
    /// Add an object in f20 cm in ront of camera
    /// - Parameter node: node of the object to add
    func addNodeInFront(_ node: SCNNode) {
        // Get current camera frame
        guard let frame = sceneView.session.currentFrame else { return }
        
        // Get transform property of the camera
        let transform = frame.camera.transform
        
        // Create translation matrix
        var translation = matrix_identity_float4x4
        
        // Translate by 20 cm on z axis
        translation.columns.3.z = -0.2
        
        //Rotate by  pi / 2 onz axis
        translation.columns.0.x = 0
        translation.columns.1.x = -1
        translation.columns.0.y = 1
        translation.columns.1.y = 0
        
        // Assign transform to the node
        node.simdTransform = matrix_multiply(transform, translation)
        
        // Add node to the scene
        addNodeToSceneRoot(node)
    }
    
    func addNodeToSceneRoot(_ node: SCNNode) {
        // Clone the node for creating separate copies of the project
        let clonedNode = node.clone()
        // Add the cloned node to the scene
        sceneView.scene.rootNode.addChildNode(clonedNode)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOptions" {
            let optionsViewController = segue.destination as! OptionsContainerViewController
            optionsViewController.delegate = self
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first, let selectedNode = selectedNode else { return }
        
        switch objectMode {
        case .freeform:
            addNodeInFront(selectedNode)
        case .plane:
            break
        case .image:
            break
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
        selectedNode = node
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
