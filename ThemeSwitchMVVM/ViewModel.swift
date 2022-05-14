import Foundation
import UIKit

class ViewModel
{
    enum Theme { case light, dark }
    
    // MARK: Modifiable Properties
    
    @Bindable
    public var theme: Theme {
        didSet {
            buttonText = theme == .dark ? "Dark Button" : "Light Button"
    }}
    
    @Bindable
    public var searchText: String {
        didSet {
            if (searchText.isEmpty)
            {
                tableFilterData = tableData
                return
            }
            let caseInsensitiveText = searchText.lowercased()
            tableFilterData = tableData.filter({ $0.lowercased().contains(caseInsensitiveText) })
    }}
    
    @Bindable
    public var textFieldSliderValue: Float {
        didSet {
            let maxLength = Int(Float(textFieldText.count) * textFieldSliderValue)
            if (textFieldTextShown?.count == maxLength) { return }
            textFieldTextShown = String(textFieldText.prefix(maxLength))
    }}
    
    @Bindable
    public var textFieldStepper: Int {
        didSet {
            textFieldProgressValue = Float(textFieldText.count) / Float(textFieldStepper)
            textFieldStepperString = "Text Field Full Mana: \(textFieldStepper)"
    }}
    
    public var textFieldText: String {
        didSet {
            textFieldProgressValue = Float(textFieldText.count) / Float(textFieldStepper)
            textFieldSliderValue = 1.0
            textFieldTextShown = textFieldText
        }}
    
    // MARK: Table Data
    
    private var tableData: [String] = ["Apple", "Mango", "Banana", "Avocado", "Orange", "Watermelon",
                                       "Durian", "Coconut", "Berries", "Citrus", "Dates", "Grape"]
    
    
    // MARK: Autocomputed Properties from Modifiable
    
    @Bindable
    private(set) var tableFilterData: [String]! {
        didSet {
            progressValue = Float(tableFilterData.count) / Float(tableData.count)
    }}
    
    @Bindable
    private(set) var labelText: String!
    
    @Bindable
    private(set) var buttonText: String! {
        didSet {
            if (buttonText.contains("Dark")) { textFieldPlaceholder = "Batman Rises" }
            else { textFieldPlaceholder = "Vampire Hiding" }
    }}
    
    @Bindable
    private(set) var progressValue: Float! {
        didSet {
            if      (progressValue >= 1.00) { labelText = "Let's Go Full Power!" }
            else if (progressValue >= 0.75) { labelText = "I'm Stronger Now!"}
            else if (progressValue >= 0.50) { labelText = "Lets Keep It Coming" }
            else if (progressValue >= 0.25) { labelText = "I'm Charging Up!" }
            else                            { labelText = "I Have No Energy"}
    }}
    
    @Bindable
    private(set) var textFieldPlaceholder: String!
    
    @Bindable
    private(set) var textFieldTextShown: String!
    
    @Bindable
    private(set) var textFieldStepperString: String!
    
    @Bindable
    private(set) var textFieldProgressValue: Float!
    
    // MARK: Functionality
    
    init()
    {
        theme = .dark
        searchText = ""
        textFieldText = ""
        textFieldStepper = 10
        textFieldSliderValue = 1
        ({ theme = theme })()
        ({ searchText = searchText })()
        ({ textFieldText = textFieldText })()
        ({ textFieldStepper = textFieldStepper })()
        ({ textFieldSliderValue = textFieldSliderValue })()
    }
    
    func triggerProgression(_ value: Float)
    {
        if (progressValue >= 1.0 && theme == .light) { return }
        if (progressValue <= 0.0 && theme == .dark)  { return }
        var newValue = theme == .dark ? progressValue - value : progressValue + value
        if (newValue > 1.0) { newValue = 1.0 }
        if (newValue < 0.0) { newValue = 0.0 }
        progressValue = newValue
    }
}
