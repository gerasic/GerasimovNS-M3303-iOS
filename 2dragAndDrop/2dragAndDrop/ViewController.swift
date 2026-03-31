//
//  ViewController.swift
//  2dragAndDrop
//
//  Created by gera on 26.03.2026.
//

import UIKit

class ViewController: UIViewController {
    private let cardView = UIView()
    
    private let personalZoneView = UIView()
    private let businessZoneView = UIView()
    
    private let personalLabel = UILabel()
    private let businessLabel = UILabel()

    private var cardStartCenter = CGPoint(x: 0, y: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()

        setupGesture()
        // Do any additional setup after loading the view.
    }

    private func setupViews() {
        view.backgroundColor = .white
        
        cardView.backgroundColor = .systemRed
        cardView.backgroundColor = .systemBlue
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 8
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        personalZoneView.backgroundColor = .systemGray6
        personalZoneView.layer.cornerRadius = 16
        personalZoneView.layer.borderWidth = 2
        personalZoneView.layer.borderColor = UIColor.systemGray3.cgColor
        personalZoneView.translatesAutoresizingMaskIntoConstraints = false
        
        businessZoneView.backgroundColor = .systemGray6
        businessZoneView.layer.cornerRadius = 16
        businessZoneView.layer.borderWidth = 2
        businessZoneView.layer.borderColor = UIColor.systemGray3.cgColor
        businessZoneView.translatesAutoresizingMaskIntoConstraints = false
        
        personalLabel.text = "Personal"
        personalLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        personalLabel.textAlignment = .center
        personalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        businessLabel.text = "Business"
        businessLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        businessLabel.textAlignment = .center
        businessLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cardView)
        view.addSubview(personalZoneView)
        view.addSubview(businessZoneView)
        
        personalZoneView.addSubview(personalLabel)
        businessZoneView.addSubview(businessLabel)
        
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
           cardView.widthAnchor.constraint(equalToConstant: 140),
           cardView.heightAnchor.constraint(equalToConstant: 90),
           cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
           
           personalZoneView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
           personalZoneView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
           personalZoneView.widthAnchor.constraint(equalToConstant: 150),
           personalZoneView.heightAnchor.constraint(equalToConstant: 120),
           
           businessZoneView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
           businessZoneView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
           businessZoneView.widthAnchor.constraint(equalToConstant: 150),
           businessZoneView.heightAnchor.constraint(equalToConstant: 120),
           
           personalLabel.centerXAnchor.constraint(equalTo: personalZoneView.centerXAnchor),
           personalLabel.centerYAnchor.constraint(equalTo: personalZoneView.centerYAnchor),

           businessLabel.centerXAnchor.constraint(equalTo: businessZoneView.centerXAnchor),
           businessLabel.centerYAnchor.constraint(equalTo: businessZoneView.centerYAnchor)
       ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if cardStartCenter == .zero {
            cardStartCenter = cardView.center
        }
    }

    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        cardView.addGestureRecognizer(panGesture)
        cardView.isUserInteractionEnabled = true
    }

    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            cardView.center = CGPoint(
                x: cardView.center.x + translation.x,
                y: cardView.center.y + translation.y
            )
            gesture.setTranslation(.zero, in: view)
            
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.3) {
                self.cardView.center = self.cardStartCenter
            }
            
        default:
            break
        }
    }

}

