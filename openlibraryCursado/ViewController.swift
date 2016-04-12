//
//  ViewController.swift
//  openlibraryCursado
//
//  Created by Arturo Rivas on 12/4/16.
//  Copyright © 2016 Arturo Rivas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var títuloLabel: UILabel!
    @IBOutlet weak var autoresLabel: UILabel!
    @IBOutlet weak var portadaImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pulsoBuscar(sender: AnyObject) {
        let textField = sender as! UITextField
        
        let url = NSURL(string: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + textField.text!)
        
        do {
            let respuesta = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: url!)!, options: .MutableLeaves) as? [String: AnyObject]
            
            if respuesta != nil && !respuesta!.isEmpty {
                
                var autores = respuesta!["ISBN:\(textField.text!)"]!["authors"] as? [[String: String]]
                if autores != nil {
                    
                    autoresLabel.text = autores![0]["name"]!
                    autores?.removeAtIndex(0)
                    
                    for autor in autores! {
                        autoresLabel.text = "\(autoresLabel.text!), \(autor["name"]!)"
                    }
                }
                
                let título = respuesta!["ISBN:\(textField.text!)"]!["title"] as? String
                if título != nil {
                    títuloLabel.text = título!
                }
                
                let cover = respuesta!["ISBN:\(textField.text!)"]!["cover"] as? [String: String]
                
                if cover != nil {
                    let imagenUrl = cover!["medium"]! as String
                    
                    portadaImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imagenUrl)!)!)
                } else {
                    portadaImage.image = nil
                }

            } else {
                let alert = UIAlertController(title: "Error", message: "No hay ningún libro con ese ISBN", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        } catch {
            let alert = UIAlertController(title: "Error", message: "Hay problemas con la conexión a Internet. Inténtelo de nuevo más tarde.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}

