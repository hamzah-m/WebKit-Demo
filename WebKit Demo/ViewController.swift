//
//  ViewController.swift
//  WebKit Demo
//
//  Created by Hamzah Mugharbil on 8/11/17.
//  Copyright © 2017 Hamzah Mugharbil. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {

    // set some initial paths
    let startingDirectory = "/Users/Hamzah/Downloads/Ex_Files_CC_Swift_06/Exercise Files/06_02/website/"
    let originalPage = "graphic-design.htm"
    let pageToCreate = "graphic-design-updated.htm"
    let csvFiles = ["_assets/first_semester.csv", "_assets/second_semester.csv"]
    
    @IBOutlet weak var webView: WebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // URL for original HTML
        let pageURL = URL(fileURLWithPath: "/Users/Hamzah/Downloads/Ex_Files_CC_Swift_06/Exercise Files/06_02/website/programs/graphic-design.htm")
        
        // load URL into webview
        webView.mainFrame.load(URLRequest(url: pageURL))
    }

    func createTableFromCSV(_ csvPath: String) -> DOMElement {
        
        // load csv file
        let csvURL = URL(fileURLWithPath: csvPath)
        var semesterData: String = ""
        
        do{
            semesterData = try String(contentsOf: csvURL, encoding: String.Encoding.utf8)
        } catch {
            print("Error: \(error)")
        }
        
        // split into multiple lines
        //  - create a table row for each line
        let newLineIndicators = CharacterSet.newlines
        let arrayOfLines = semesterData.components(separatedBy: newLineIndicators) as! [String]
        
        // create the table element
        let DOMdoc = webView.mainFrameDocument
        let table = DOMdoc?.createElement("table")
        
        for i in 0..<arrayOfLines.count {
            // create one row for each line
            let row = DOMdoc?.createElement("tr")
            let cellData = arrayOfLines[i].components(separatedBy: ",")
            
            for eachCell in cellData {
                var cell: DOMElement
                if i == 0 {
                    cell = DOMdoc!.createElement("th")
                } else {
                    cell = DOMdoc!.createElement("td")
                }
                // provide some text for cells
                cell.appendChild(DOMdoc?.createTextNode(eachCell))
                row?.appendChild(cell)
            }
            // add the row to the table
            table?.appendChild(row)
        }
        return table!
        
        // for each line, split by commas
        //  - create a table cell for each piece of data
        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        // get the page as a DOM document
        let DOMdocument = webView.mainFrameDocument
        let mainContentSection = DOMdocument?.getElementById("mainContent")
        
        for file in csvFiles {
            let csvPath = startingDirectory.appending(file)
            
            let newTable = createTableFromCSV(csvPath)
            mainContentSection?.appendChild(newTable)
        }
        
        // save updated page
        // create full save path
        let saveURL = URL(fileURLWithPath: startingDirectory.appending(pageToCreate))
        
        let editedHTMLdata = DOMdocument?.webArchive.mainResource.data
        do{
            try editedHTMLdata?.write(to: saveURL, options: .atomic)
        } catch {
            print("Error: \(error)")
        }
        
        
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

