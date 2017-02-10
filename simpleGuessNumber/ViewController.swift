//
//  ViewController.swift
//  simpleGuessNumber
//
//  Created by Byron Bacusoy Pinela on 27/1/17.
//  Copyright © 2017 Novex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //-------------------------FOR BACKGROUND-------------------------
    @IBOutlet weak var background: UIImageView!
    var pointStart = CGPoint(x: 0.0, y: 0.0)
    var pointEnd = CGPoint(x: 1.0, y: 1.0)
    var phase = 0
    let gradient = CAGradientLayer()

    func backgroundEffect()
    {
        getCurrentPhase()
        switch phase {
        case 1:
            phaseOne()
        case 2:
            phaseTwo()
        case 3:
            phaseThree()
        default:
            phaseFour()
        }
        fixBugDouble(Phase: phase)
        redrawBackground()
    }
    func getCurrentPhase()
    {
        if (pointStart.equalTo(CGPoint(x: 0.0, y: 0.0)) && pointEnd.equalTo(CGPoint(x: 1.0, y: 1.0))) {phase = 1}
        if (pointStart.equalTo(CGPoint(x: 1.0, y: 0.0)) && pointEnd.equalTo(CGPoint(x: 0.0, y: 1.0))) {phase = 2}
        if (pointStart.equalTo(CGPoint(x: 1.0, y: 1.0)) && pointEnd.equalTo(CGPoint(x: 0.0, y: 0.0))) {phase = 3}
        if (pointStart.equalTo(CGPoint(x: 0.0, y: 1.0)) && pointEnd.equalTo(CGPoint(x: 1.0, y: 0.0))) {phase = 4}
    }
    func phaseOne()
    {
        pointStart.x += 0.1
        pointEnd.x -= 0.1
    }
    func phaseTwo()
    {
        pointStart.y += 0.1
        pointEnd.y -= 0.1
    }
    func phaseThree()
    {
        pointStart.x -= 0.1
        pointEnd.x += 0.1
        
    }
    func phaseFour()
    {
        pointStart.y -= 0.1
        pointEnd.y += 0.1
    }
    func redrawBackground()
    {
        gradient.startPoint = pointStart
        gradient.endPoint = pointEnd
    }
    func fixBugDouble(Phase:Int)
    {//Parece ser que no se suma/resta 0.1, si no que un poco más. Así que nunca llegarán a ser exactamente 0.0 o 1.0
        switch Phase {
        case 1:
            if(pointEnd.x < 0.1) {pointStart.x = 1.0;pointEnd.x = 0.0}
        case 2:
            if (pointEnd.y < 0.1) {pointStart.y = 1.0;pointEnd.y = 0.0}
        case 3:
            if (pointStart.x < 0.1) {pointStart.x = 0.0; pointEnd.x = 1.0}
        default:
            if (pointStart.y < 0.1) {pointStart.y = 0.0; pointEnd.y = 1.0}
        }
    }
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
    @IBOutlet weak var titleLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var tryLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButtonYConstraint: NSLayoutConstraint!

    @IBOutlet weak var stackButtons: UIStackView!
    @IBOutlet weak var okButton: customButton!
    @IBOutlet weak var rightButton: customButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: customLabel!
    @IBOutlet weak var tryLabel: customLabel!
    @IBOutlet weak var numberLabel: UILabel!
    //--------------------------------------------------------------
    //FUNCIONES BUTTON
    //--------------------------------------------------------------
    @IBAction func okAction(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 1.0, animations: {
            self.okButton.alpha = 0.0
            self.okButton.isEnabled = false
            }) { (true) in
                self.tryLabelConstraint.constant = 5
                UIView.animate(withDuration: 1.0, animations: { 
                    self.tryLabel.alpha = 1.0
                    self.numberLabel.alpha = 1.0
                    
                    }, completion: { (true) in
                        self.stackButtons.alpha = 1.0
                        self.rightButton.alpha = 1.0
                        let aux = self.rightButton.center.x
                        self.stackButtons.center.x = 600
                        self.rightButton.center.x = 600
                        UIView.animate(withDuration: 0.3, animations: {
                            self.rightButton.center.x = aux
                            self.stackButtons.center.x = aux
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
            tryLabel.text = "Im the best"
            endGame()
        }
        
    }
    //--------------------------------------------------------------
    //FUNCIONES
    //--------------------------------------------------------------
    func endGame(){
        UIView.animate(withDuration: 1.0, animations: { 
            self.stackButtons.alpha = 0.0
            self.numberLabel.alpha = 0.0
            }) { (true) in
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.rightButtonYConstraint.constant = 5
                    self.view.layoutIfNeeded()
                })
                self.rightButton.setTitle("Otra?", for: .normal)
                self.otra = true
        }
        
    }
    func anotherOne(){
        getMinMax()
        intento = 0
        otra = false
        okButton.isEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.setAlphaTo0()
            self.view.layoutIfNeeded()
        }) { (true) in
            self.setInfo()
            self.rightButtonYConstraint.constant = self.buttonCorrectoYCONTS
            self.tryLabelConstraint.constant = self.guessLabelYCONST
            self.rightButton.setTitle("Correcto!", for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (true) in
                    UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseIn, animations: {
                        self.okButton.alpha = 1.0
                        self.infoLabel.alpha = 1.0
                        }, completion: nil)
                    
            })
        }
        
    }
    func calculateNum(){
        intento += 1
        if (intento != 10) {
            tryLabel.text = "\(intento)"
            avg = Int((max + min)/2)
            numberLabel.text = "\(avg)"
        }
        else{
            tryLabel.text = "YOU WIN!"
            endGame()
        }
    }
    func initGame() {
        setAlphaTo0()
        getMinMax()
        setInfo()
        titleAnimation()
    }
    
    func titleAnimation() {
        titleLabel.center.y = 1000
        UIView.animate(withDuration: 2.0, animations: {
            self.view.layoutIfNeeded()
        }) { (true) in
            self.titleLabelConstraint.constant = 5
            UIView.animate(withDuration: 1.5, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (true) in
                    self.appearTitleLabelOkButton()
            })
        }
    }
    
    func appearTitleLabelOkButton(){
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseIn, animations: {
            self.okButton.alpha = 1.0
            self.infoLabel.alpha = 1.0
            }, completion: nil)
    }
    
    func setAlphaTo0(){
        okButton.alpha = 0.0
        infoLabel.alpha = 0.0
        tryLabel.alpha = 0.0
        numberLabel.alpha = 0.0
        rightButton.alpha = 0.0
        stackButtons.alpha = 0.0
    }
    func setInfo(){
        infoLabel.text = "Piensa en un número entre el \(min) y el \(max) y lo adivinaré en menos de 10 intentos"
    }
    
    func getMinMax() {
        min = Int(arc4random_uniform(1000))
        max = Int(arc4random_uniform(1000))
        checkMinMax()
    }
    
    func checkMinMax(){
        if (min > max){
            let aux = max
            max = min
            min = aux
        }
        //Almenos con 100 numeros de diferencia
        if (max - min < 100){
            if (max > 500){
                min -= 100
            }
            else {
                max += 100
            }
        }
    }
    
    func initBackground()
    {
        gradient.frame = view.bounds
        gradient.colors = [UIColor.red.cgColor,UIColor.yellow.cgColor,UIColor.green.cgColor,UIColor.blue.cgColor]
        gradient.endPoint = pointEnd
        gradient.startPoint = pointStart
        background.layer.insertSublayer(gradient, at: 0)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(backgroundEffect), userInfo: nil, repeats: true)
    }
    
    func initApp()
    {
        initBackground()
        initGame()
    }
    
    
    //--------------------------------------------------------------
    //METODOS
    //--------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonCorrectoYCONTS = rightButtonYConstraint.constant
        guessLabelYCONST = tryLabelConstraint.constant
        initApp()
        
    }
    //--------------------------------------------------------------
}

