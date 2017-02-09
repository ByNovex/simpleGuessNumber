//
//  ViewController.swift
//  simpleGuessNumber
//
//  Created by Byron Bacusoy Pinela on 27/1/17.
//  Copyright © 2017 Novex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //-------------------------FOR GRADIENT-------------------------
    @IBOutlet weak var background: UIImageView!
    var indX = 0.0;
    var indY = 0.0;
    var indXE = 1.0;
    var indYE = 1.0;
    let gradient = CAGradientLayer()
    var aux = false
    var i = 0
    func changeGradient(){
        //GUARRADA!
        
        //Para conseguir el ejecto de "circulo" hay que subir X, subir Y, bajar X y bajar Y. En este orden.
        //Y con el EndPoint la inversa. Bajar X, bajar Y, subir X, subir Y.
        if (i < 10) {//Subimos X y bajamos eX
            indX += 0.1
            indXE -= 0.1
            i += 1
            
            if (i == 10){indXE = 0.0}
            gradient.endPoint = CGPoint(x: indXE, y: indYE)
            gradient.startPoint = CGPoint(x: indX, y: indY)
            
            //            coord.text = "\(indX) \(indY)"
            //            coordE.text = "\(indXE) \(indYE)"
            
        }
        else if (i < 20){//Subimos Y y bajamos eY
            indY += 0.1
            indYE -= 0.1
            i += 1
            
            if (i == 20){indYE = 0.0}
            gradient.endPoint = CGPoint(x: indXE, y: indYE)
            gradient.startPoint = CGPoint(x: indX, y: indY)
            
            //            coord.text = "\(indX) \(indY)"
            //            coordE.text = "\(indXE) \(indYE)"
            
        }
        else if (i < 30){//Bajamos X y subimos eX
            indX -= 0.1
            indXE += 0.1
            i += 1
            
            if (i == 30){indX = 0.0}
            gradient.endPoint = CGPoint(x: indXE, y: indYE)
            gradient.startPoint = CGPoint(x: indX, y: indY)
            //            coord.text = "\(indX) \(indY)"
            //            coordE.text = "\(indXE) \(indYE)"
            
            
        }
        else if (i < 40){//Bajamos Y y subimos eY
            indY -= 0.1
            indYE += 0.1
            i += 1
            
            if (i == 40) {
                i = 0;
                indY = 0.0
            }
            
            gradient.endPoint = CGPoint(x: indXE, y: indYE)
            gradient.startPoint = CGPoint(x: indX, y: indY)
            //            coord.text = "\(indX) \(indY)"
            //            coordE.text = "\(indXE) \(indYE)"
            
        }
        
    }
    //--------------------------------------------------------------
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    //--------------------------------------------------------------
    //VARIABLES
    //--------------------------------------------------------------
    var max = 0
    var min = 0
    var avg = 0
    var intento = 0
    var otra = false
    var buttonCorrectoYCONTS: CGFloat!
    var guessLabelYCONST: CGFloat!
    //--------------------------------------------------------------
    //OBJETOS
    //--------------------------------------------------------------
    @IBOutlet weak var guessNumberY: NSLayoutConstraint!
    @IBOutlet weak var guessLabelY: NSLayoutConstraint!
    @IBOutlet weak var correctoButtonY: NSLayoutConstraint!

    @IBOutlet weak var stackOut: UIStackView!

    @IBOutlet weak var buttonOK: customButton!
    @IBOutlet weak var mayorButton: customButton!
    @IBOutlet weak var menorButton: customButton!
    @IBOutlet weak var correctoButton: customButton!
    
    @IBOutlet weak var guessNumberTitle: UILabel!
    @IBOutlet weak var infoLabel: customLabel!
    @IBOutlet weak var guessLabel: customLabel!
    @IBOutlet weak var numberLabel: UILabel!
    //--------------------------------------------------------------
    //FUNCIONES BUTTON
    //--------------------------------------------------------------
    @IBAction func okAction(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 1.0, animations: {
            self.buttonOK.alpha = 0.0
            self.buttonOK.isEnabled = false
            }) { (true) in
                self.guessLabelY.constant = 5
                UIView.animate(withDuration: 1.0, animations: { 
                    self.guessLabel.alpha = 1.0
                    self.numberLabel.alpha = 1.0
                    
                    }, completion: { (true) in
                        self.mayorButton.alpha = 1.0
                        self.menorButton.alpha = 1.0
                        self.stackOut.alpha = 1.0
                        self.correctoButton.alpha = 1.0
                        let aux = self.correctoButton.center.x
                        self.stackOut.center.x = 600
                        self.correctoButton.center.x = 600
                        UIView.animate(withDuration: 0.3, animations: {
                            self.correctoButton.center.x = aux
                            self.stackOut.center.x = aux
                        })
                })
            }
        
        calculateNum()
        }
    @IBAction func mayorAction(_ sender: AnyObject) {
        min = avg
        calculateNum()
    }
    @IBAction func menorButton(_ sender: AnyObject) {
        max = avg
        calculateNum()
    }
    @IBAction func correctioAction(_ sender: AnyObject) {
        if (otra) {
            anotherOne()
        }
        else{
            guessLabel.text = "Im the best"
            endGame()
        }
        
    }
    //--------------------------------------------------------------
    //FUNCIONES
    //--------------------------------------------------------------
    func endGame(){
        UIView.animate(withDuration: 1.0, animations: { 
            self.stackOut.alpha = 0.0
            self.numberLabel.alpha = 0.0
            }) { (true) in
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.correctoButtonY.constant = 5
                    self.view.layoutIfNeeded()
                })
                self.correctoButton.setTitle("Otra?", for: .normal)
                self.otra = true
        }
        
    }
    func anotherOne(){
        comprobarMinMax()
        intento = 0
        otra = false
        buttonOK.isEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha0()
            self.view.layoutIfNeeded()
        }) { (true) in
            self.setInfo()
            self.correctoButtonY.constant = self.buttonCorrectoYCONTS
            self.guessLabelY.constant = self.guessLabelYCONST
            self.correctoButton.setTitle("Correcto!", for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (true) in
                    UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseIn, animations: {
                        self.buttonOK.alpha = 1.0
                        self.infoLabel.alpha = 1.0
                        }, completion: nil)
                    
            })
        }
        
    }
    func calculateNum(){
        intento += 1
        if (intento != 10) {
            guessLabel.text = "\(intento)"
            avg = Int((max + min)/2)
            numberLabel.text = "\(avg)"
        }
        else{
            guessLabel.text = "YOU WIN!"
            endGame()
        }
    }
    func initGame() {
        alpha0()
        comprobarMinMax()
        setInfo()
        intento = 0
        //Piensa que al tener "autolayout" siempre se hará el autolayout. Esto quiere decir que 
        //por mucho que cambiemos el posicionamiento de un layout, se volverá a poner en su lugar
        //Este "lugar" esta marcado por los constraints.
        //Lo que si que podemos hacer es provocar nosotros este "autolayout"
        //La funcion layouIfNeeded() hace esto. Le ponemos una animación y se hará en el tiempo que dure la animación.
        guessNumberTitle.center.y = 1000 //Hacemos esto para echar el layout abajo
        UIView.animate(withDuration: 1.5, animations: {
            self.view.layoutIfNeeded() //con esto volvera a donde le marque la constraint
            }) { (true) in
                self.guessNumberY.constant = 5 //movemos la constraint hacia arriba
                UIView.animate(withDuration: 1.5, animations: { 
                    self.view.layoutIfNeeded()//se movera hacia la nueva posicion de constraint
                    //que quede claro que si no hacemos esto lo que pasara es que el layout se teletransportará hacia la "posicion" 5
                    }, completion: { (true) in
                        UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseIn, animations: {
                            self.buttonOK.alpha = 1.0
                            self.infoLabel.alpha = 1.0
                            }, completion: nil)
                        
                })
        }
    }
    func alpha0(){
        buttonOK.alpha = 0.0
        infoLabel.alpha = 0.0
        guessLabel.alpha = 0.0
        numberLabel.alpha = 0.0
        mayorButton.alpha = 0.0
        menorButton.alpha = 0.0
        correctoButton.alpha = 0.0
    }
    func setInfo(){
        infoLabel.text = "Piensa en un número entre el \(min) y el \(max) y lo adivinaré en menos de 10 intentos"
    }
    func comprobarMinMax() {
        //Miramos quien es mayor y menor; y almenos con 100 numeros de diferencia
        min = Int(arc4random_uniform(1000))
        max = Int(arc4random_uniform(1000))
        if (min > max){
            let aux = max
            max = min
            min = aux
        } //else min <= max
        
        
        if (max - min < 100){
            if (max > 500){
                min -= 100
            }
            else {
                max += 100
            }
        }
    }
    //--------------------------------------------------------------
    //METODOS
    //--------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonCorrectoYCONTS = correctoButtonY.constant
        guessLabelYCONST = guessLabelY.constant
        
        gradient.frame = view.bounds
        
//        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor, UIColor.white.cgColor]
        gradient.colors = [UIColor.red.cgColor,UIColor.yellow.cgColor,UIColor.green.cgColor,UIColor.blue.cgColor]
//        gradient.colors = [UIColor.init(red: 0.502, green: 0.0, blue: 0.251, alpha: 1.0).cgColor,
//                          UIColor.init(red: 0.502, green: 0.0, blue: 0.0, alpha: 1.0).cgColor,
//                          UIColor.init(red: 0.406, green: 0.0, blue: 0.0, alpha: 1.0).cgColor,
//                          UIColor.init(red: 0.502, green: 0.0, blue: 0.0, alpha: 1.0).cgColor,
//                          UIColor.init(red: 0.502, green: 0.0, blue: 0.251, alpha: 1.0).cgColor]

        gradient.startPoint = CGPoint(x: indX, y: indY)
        gradient.endPoint = CGPoint(x: indXE, y: indYE)
        background.layer.insertSublayer(gradient, at: 0)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(changeGradient), userInfo: nil, repeats: true)
        initGame()

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //--------------------------------------------------------------
}

