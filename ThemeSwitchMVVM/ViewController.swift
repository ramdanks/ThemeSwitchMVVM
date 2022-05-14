import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var labelTextField: UILabel!
    @IBOutlet weak var stepperTextField: UIStepper!
    @IBOutlet weak var textFieldProgress: UIProgressView!
    
    private var viewModel: ViewModel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource                    = self
        searchBar.delegate                      = self
        viewModel                               = ViewModel()
        slider.value                            = viewModel.textFieldSliderValue
        stepperTextField.value                  = Double(viewModel.textFieldStepper)
        viewModel.$labelText.bind               { [unowned self] in label.text = $0 }
        viewModel.$buttonText.bind              { [unowned self] in button.setTitle($0, for: .normal) }
        viewModel.$progressValue.bind           { [unowned self] in progress.progress = $0 ?? 0 }
        viewModel.$textFieldPlaceholder.bind    { [unowned self] in textField.placeholder = $0 }
        viewModel.$textFieldTextShown.bind      { [unowned self] in textField.text = $0 }
        viewModel.$textFieldStepperString.bind  { [unowned self] in labelTextField.text = $0 }
        viewModel.$textFieldProgressValue.bind  { [unowned self] in textFieldProgress.progress = $0 ?? 0 }
        viewModel.$tableFilterData.bind         { [unowned self] _ in DispatchQueue.main.async { self.tableView.reloadData() } }
    }
    
    @IBAction func onButtonPressed(_ sender: UIButton)
    {
        viewModel.triggerProgression(0.1)
    }
    
    @IBAction func onThemeChanged(_ sender: UISegmentedControl)
    {
        viewModel.theme = sender.selectedSegmentIndex == 0 ? .dark : .light
    }
    
    @IBAction func onEditingChanged(_ sender: UITextField)
    {
        viewModel.textFieldText = sender.text ?? ""
    }
    
    @IBAction func onSliderChanged(_ sender: UISlider)
    {
        viewModel.textFieldSliderValue = sender.value
    }
    
    @IBAction func onStepperChanged(_ sender: UIStepper)
    {
        viewModel.textFieldStepper = Int(sender.value)
    }
}

extension ViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        viewModel.searchText = searchText
    }
}

extension ViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.tableFilterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = viewModel.tableFilterData[indexPath.row]
        return cell
    }
}
