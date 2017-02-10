//
//  ViewController.swift
//  simpleGuessNumber
//
//  Created by Byron Bacusoy Pinela on 27/1/17.
//  Copyright © 2017 Novex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //--------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        initApp()
    }
    func initApp(){
        initBackground()
        initGame()
    }
    //--------------------------------------------------------------
    //----------------------------GAME------------------------------
    //--------------------------------------------------------------
    //VARIABLES
    //--------------------------------------------------------------
    var maxNumber = 0
    var minNumber = 0
    var avgNumber = 0
    var tryNumber = 0
    var isAnotherOneText = false
    var constantRightButtonConstraintY: CGFloat!
    var constantTryLabelConstraintY: CGFloat!
    //--------------------------------------------------------------
    //OBJETOS
    //--------------------------------------------------------------
    @IBOutlet weak var stackButtons: UIStackView!
    @IBOutlet weak var okButton: customButton!
    @IBOutlet weak var rightButton: customButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: customLabel!
    @IBOutlet weak var tryLabel: customLabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var titleLabelConstraintY: NSLayoutConstraint!
    @IBOutlet weak var tryLabelConstraintY: NSLayoutConstraint!
    @IBOutlet weak var rightButtonConstraintY: NSLayoutConstraint!
    //--------------------------------------------------------------
    //BUTTONSFUNCTIONS
    //--------------------------------------------------------------
    @IBAction func okButtonAction(_ sender: AnyObject) {
        infoToGameAnimation()
        calculateNum()
    }
    @IBAction func highButtonAction(_ sender: AnyObject) {
        minNumber = avgNumber
        calculateNum()
    }
    @IBAction func lessButtonAction(_ sender: AnyObject) {
        maxNumber = avgNumber
        calculateNum()
    }
    @IBAction func rightButtonAction(_ sender: AnyObject) {
        if (isAnotherOneText) {endToInfoAnimation()}
        else {endGame(userWins: false)}
    }
    //--------------------------------------------------------------
    //FUNCIONES
    //--------------------------------------------------------------
    func initGame() {
        getConstantConstraints()
        prepareGame()
        startToInfoAnimation()
    }
    func endGame(userWins:Bool){
        setEndGameText(win: userWins)
        gameToEndAnimation()
    }
    //--------------------------------------------------------------
    func startToInfoAnimation() {
        titleLabel.center.y = 1000
        UIView.animate(withDuration: 2.0, animations: {
            self.moveTitleLabelToCenter()}){
                (true) in
                UIView.animate(withDuration: 1.5, animations: {
                    self.moveTitleLabeToTop()},completion: {
                        (true) in
                        self.appearInfoLabelOkButton()
                })
        }
    }
    func infoToGameAnimation() {
        UIView.animate(withDuration: 1.0, animations: {
            self.desappearOKButton()}) {
                (true) in
                self.moveTryLabel()
                self.appearGameTemplate()
        }
    }
    func gameToEndAnimation(){
        UIView.animate(withDuration: 1.0, animations: {
            self.desappearStackButtonsNumberLabel()}){
                (true) in
                UIView.animate(withDuration: 1.0, animations: {
                    self.moveRightButton()})
                    self.setRightButtonTextAnotherOne()
        }
    }
    func endToInfoAnimation() {
        UIView.animate(withDuration: 1.5, animations: {
            self.setAlphaTo0ButTitle()
        }) { (true) in
            self.prepareGame()
            self.appearInfoLabelOkButton()

        }
    }
    //--------------------------------------------------------------
    func prepareGame() {
        getMinMaxNumbers()
        setInfo()
        setDefaultValues()
        setAlphaTo0ButTitle()
    }
    func calculateNum(){
        tryNumber += 1
        if (tryNumber < 11) {
            setNumberAndTry()
        }
        else{
            endGame(userWins: true)
        }
    }
    func checkMinMax(){
        if (minNumber > maxNumber){
            let aux = maxNumber
            maxNumber = minNumber
            minNumber = aux
        }
        //Almenos con 100 numeros de diferencia
        if (maxNumber - minNumber < 100){
            if (maxNumber > 500){
                minNumber -= 100
            }
            else {
                maxNumber += 100
            }
        }
    }
    //--------------------------------------------------------------
    func setInfo(){
        infoLabel.text = "Piensa en un número entre el \(minNumber) y el \(maxNumber) y lo adivinaré en menos de 10 intentos"
    }
    func setDefaultValues(){
        tryNumber = 0
        okButton.isEnabled = true
        setRightButtonTextRight()
        setConstraintToConstant()
    }
    func setAlphaTo0ButTitle(){
        okButton.alpha = 0.0
        infoLabel.alpha = 0.0
        tryLabel.alpha = 0.0
        numberLabel.alpha = 0.0
        rightButton.alpha = 0.0
        stackButtons.alpha = 0.0
    }
    func setEndGameText(win:Bool){
        if(win){tryLabel.text = "YOU WIN!"}
        else {tryLabel.text = "Im the best"}
    }
    func setNumberAndTry(){
        avgNumber = Int((maxNumber + minNumber)/2)
        numberLabel.text = "\(avgNumber)"
        tryLabel.text = "\(tryNumber)"
    }
    func setRightButtonTextRight(){
        self.rightButton.setTitle("Correcto!", for: .normal)
        isAnotherOneText = false
    }
    func setRightButtonTextAnotherOne() {
        self.rightButton.setTitle("Otra?", for: .normal)
        self.isAnotherOneText = true
    }
    func setConstraintToConstant() {
        self.rightButtonConstraintY.constant = self.constantRightButtonConstraintY
        self.tryLabelConstraintY.constant = self.constantTryLabelConstraintY
    }
    func getMinMaxNumbers() {
        minNumber = Int(arc4random_uniform(1000))
        maxNumber = Int(arc4random_uniform(1000))
        checkMinMax()
    }
    func getConstantConstraints(){
        constantRightButtonConstraintY = rightButtonConstraintY.constant
        constantTryLabelConstraintY = tryLabelConstraintY.constant
    }
    //--------------------------------------------------------------
    func moveTitleLabelToCenter(){
        view.layoutIfNeeded()
    }
    func moveTitleLabeToTop() {
        titleLabelConstraintY.constant = 5
        view.layoutIfNeeded()
    }
    func moveRightButton() {
        rightButtonConstraintY.constant = 5
        view.layoutIfNeeded()
    }
    func moveTryLabel() {
        tryLabelConstraintY.constant = 5
    }
    func appearInfoLabelOkButton(){
        UIView.animate(withDuration: 1.5) {
            self.okButton.alpha = 1.0
            self.infoLabel.alpha = 1.0
        }
    }
    func appearGameTemplate(){
        UIView.animate(withDuration: 1.0, animations: {
            self.appearTryLabelNumberLabel()}, completion: {
                (true) in
                self.appearStackButtons()
        })
    }
    func appearTryLabelNumberLabel() {
        tryLabel.alpha = 1.0
        numberLabel.alpha = 1.0
    }
    func appearStackButtons(){
        stackButtons.alpha = 1.0
        rightButton.alpha = 1.0
        let aux = rightButton.center.x
        stackButtons.center.x = 600
        rightButton.center.x = 600
        UIView.animate(withDuration: 0.3, animations: {
            self.rightButton.center.x = aux
            self.stackButtons.center.x = aux
        })
    }
    func desappearOKButton(){
        okButton.alpha = 0.0
        okButton.isEnabled = false
    }
    func desappearStackButtonsNumberLabel(){
        stackButtons.alpha = 0.0
        numberLabel.alpha = 0.0
    }
    //--------------------------------------------------------------
    //-------------------------BACKGROUND---------------------------
    //--------------------------------------------------------------
    //VARIABLES
    //--------------------------------------------------------------
    @IBOutlet weak var background: UIImageView!
    let gradient = CAGradientLayer()
    var pointStart = CGPoint(x: 0.0, y: 0.0)
    var pointEnd = CGPoint(x: 1.0, y: 1.0)
    var currentPhase = 0
    //--------------------------------------------------------------
    //FUNCIONES
    //--------------------------------------------------------------
    func initBackground(){
        createGradient()
        createBackground()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(backgroundEffect), userInfo: nil, repeats: true)
    }
    //--------------------------------------------------------------
    func createGradient(){
        gradient.frame = view.bounds
        gradient.colors = [UIColor.red.cgColor,UIColor.yellow.cgColor,UIColor.green.cgColor,UIColor.blue.cgColor]
        redrawBackground()
    }
    func createBackground(){
        background.layer.insertSublayer(gradient, at: 0)
    }
    //--------------------------------------------------------------
    func backgroundEffect(){
        getCurrentPhase()
        switch currentPhase {
        case 1:
            phaseOne()
        case 2:
            phaseTwo()
        case 3:
            phaseThree()
        default:
            phaseFour()
        }
        fixBugDouble(Phase: currentPhase)
        redrawBackground()
    }
    func getCurrentPhase(){
        if (pointStart.equalTo(CGPoint(x: 0.0, y: 0.0)) && pointEnd.equalTo(CGPoint(x: 1.0, y: 1.0))) {currentPhase = 1}
        if (pointStart.equalTo(CGPoint(x: 1.0, y: 0.0)) && pointEnd.equalTo(CGPoint(x: 0.0, y: 1.0))) {currentPhase = 2}
        if (pointStart.equalTo(CGPoint(x: 1.0, y: 1.0)) && pointEnd.equalTo(CGPoint(x: 0.0, y: 0.0))) {currentPhase = 3}
        if (pointStart.equalTo(CGPoint(x: 0.0, y: 1.0)) && pointEnd.equalTo(CGPoint(x: 1.0, y: 0.0))) {currentPhase = 4}
    }
    func phaseOne(){
        pointStart.x += 0.1
        pointEnd.x -= 0.1
    }
    func phaseTwo(){
        pointStart.y += 0.1
        pointEnd.y -= 0.1
    }
    func phaseThree(){
        pointStart.x -= 0.1
        pointEnd.x += 0.1
        
    }
    func phaseFour(){
        pointStart.y -= 0.1
        pointEnd.y += 0.1
    }
    func fixBugDouble(Phase:Int){
        //Parece ser que no se suma/resta 0.1, si no que un poco más. Así que nunca llegarán a ser exactamente 0.0 o 1.0
        switch Phase {
        case 1:
            if(pointEnd.x < 0.1) {pointStart.x = 1.0;pointEnd.x = 0.0}
        case 2:
            if (pointEnd.y < 0.1) {pointStart.y = 1.0;pointEnd.y = 0.0}
        case 3:
            if (pointStart.x < 0.1) {pointStart.x = 0.0;pointEnd.x = 1.0}
        default:
            if (pointStart.y < 0.1) {pointStart.y = 0.0;pointEnd.y = 1.0}
        }
    }
    func redrawBackground(){
        gradient.startPoint = pointStart
        gradient.endPoint = pointEnd
    }
    //--------------------------------------------------------------
}

