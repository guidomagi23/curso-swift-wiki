//
//  ViewController.swift
//  web
//
//  Created by Guido Magi on 31/05/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var textField: UITextField!
    
    var palabra:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func btBuscar(_ sender: Any) {

        palabra = textField.text!
        
        let urlCompleto = "https://es.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles=\(palabra!.replacingOccurrences(of: " ", with: "%20"))"
        
        
        let objetoUrl = URL(string:urlCompleto)
        
        let tarea = URLSession.shared.dataTask(with: objetoUrl!) { (datos,respuesta,error) in
            
            if error != nil {
                print(error!)
            } else {
                do{
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                    
                    let querySubJson = json["query"] as! [String:Any]
                    let pagesSubJson = querySubJson["pages"] as! [String:Any]
                    let pageId = pagesSubJson.keys
                    let primerLlave = pageId.first!
                    let idSubJson = pagesSubJson[primerLlave] as! [String:Any]
                    let extractStringHtml = idSubJson["extract"] as! String
                    
                    DispatchQueue.main.sync(execute: {
                        self.webView.loadHTMLString(extractStringHtml, baseURL: nil)
                    })
                    
                }catch{
                    print("El procedimiento del JSON tuvo un error")
                }
            }
        }
        tarea.resume()
    }
    
}

