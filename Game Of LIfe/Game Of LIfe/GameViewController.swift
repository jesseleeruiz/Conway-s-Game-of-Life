//
//  GameViewController.swift
//  Game Of LIfe
//
//  Created by Jesse Ruiz on 7/29/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Properties
    var dataSource: [Cell] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    let pixelSize = 15
    var boardWidth: Int {
        return Int(floor(collectionView.frame.size.width/CGFloat(pixelSize)))
    }
    var boardHeight: Int {
        return Int(floor(collectionView.frame.size.height/CGFloat(pixelSize)))
    }
    var game: Game!

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = Game(width: boardWidth, height: boardHeight)
        game.addStateObserver { [weak self] state in
            self?.display(state)
        }
    }
    
    func display(_ state: GameState) {
        self.dataSource = state.cells
    }
    
    // MARK: - Actions
    @IBAction func rewind(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func play(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func pause(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func fastForward(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func advance(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func reset(_ sender: UIBarButtonItem) {
    }
    
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCollectionViewCell", for: indexPath) as? SquareCollectionViewCell else { return UICollectionViewCell() }
        cell.configureWithState(dataSource[indexPath.item].isAlive)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pixelSize, height: pixelSize)
    }
}
