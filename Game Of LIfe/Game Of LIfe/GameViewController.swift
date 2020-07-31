//
//  GameViewController.swift
//  Game Of LIfe
//
//  Created by Jesse Ruiz on 7/29/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    var dataSource: [Cell] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var pixelSize = 10 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var boardWidth: Int {
        return Int(floor(collectionView.frame.size.width/CGFloat(pixelSize)))
    }
    var boardHeight: Int {
        return Int(floor(collectionView.frame.size.height/CGFloat(pixelSize)))
    }
    var game: Game!

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var generationLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = Game(width: boardWidth, height: boardHeight)
        game.addStateObserver { [weak self] state in
            self?.display(state)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateGeneration), name: .generationChanged, object: nil)
    }
    
    func display(_ state: GameState) {
        self.dataSource = state.cells
    }
    
    // MARK: - Actions
    
    @IBAction func displayAboutInfo(_ sender: UIBarButtonItem) {
        let aboutInfoController = UIAlertController(title: "Learn about Conway's Game of Life", message: "The three options below go into different aspects of the game.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let rulesAction = UIAlertAction(title: "Rules", style: .default) { _ in
            self.showRules()
        }
        let CAAction = UIAlertAction(title: "Cellular Automata", style: .default) { _ in
            self.showCA()
        }
        let turingAction = UIAlertAction(title: "Turing Complete", style: .default) { _ in
            self.showTuring()
        }
        
        [cancelAction, rulesAction, CAAction, turingAction].forEach {
            aboutInfoController.addAction($0)
        }
        present(aboutInfoController, animated: true)
    }
    
    private func showRules() {
        let title = "The Rules of Conway's Game of Life"
        let message = """
        1) Any live cell with 2 or 3 live neighbors survives.
        2) Any dead cell with three live neighbors becomes a live cell.
        3) All other live cells die in the next generation. Similarly, all other dead cells stay dead.
        """
        let rulesController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let doneAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        rulesController.addAction(doneAction)
        present(rulesController, animated: true)
    }
    
    private func showCA() {
        let title = "Cellular Automata"
        let message = """
        This is a program that operates on data typically stored in a 2D grid.
        A simple set of rules describes how the value in a cell on the grid changes over time, often as the result of the states of that cell's neighbors.
        Each round of the simulation examines the current state of the grid, and then produces an entirely new grid consisting of the old state.
        This new grid becomes the "current" state of the simulation, and the process repeats. Each new grid is referred to as a generation.
        Practically speaking, CAs have been used in biological and chemical simulations and other areas of research, such as CA-based computer processors, and other numeric techniques.
        """
        let CAController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let doneAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        CAController.addAction(doneAction)
        present(CAController, animated: true)
    }
    
    private func showTuring() {
        let title = "Turing Complete"
        let message = """
        In computability theory, a system of data-manipulation rules (such as a computer's instruction set, a programming language, or a cellular automaton) is said to be Turing-complete or computationally universal if it can be used to simulate any Turing machine.
        This means that this system is able to recognize or decide other data-manipulation rule sets.
        Turing completeness is used as a way to express the power of such a data-manipulation rule set.
        Virtually all programming languages today are Turing-complete.
        The concept is named after English mathematician and computer scientist Alan Turing.
        """
        let turingController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let doneAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        turingController.addAction(doneAction)
        present(turingController, animated: true)
    }
    
    
    @IBAction func play(_ sender: UIBarButtonItem) {
            game.play { [weak self] state in
                self?.display(state)
        }
    }
    
    @IBAction func pause(_ sender: UIBarButtonItem) {
        game.stop { [weak self] state in
            self?.display(state)
        }
    }
    
    @IBAction func reset(_ sender: UIBarButtonItem) {
        game.reset { [weak self] state in
            self?.display(state)
        }
    }
    
    @IBAction func clear(_ sender: UIBarButtonItem) {
        game.clear { [weak self] state in
            self?.display(state)
        }
    }
    
    @IBAction func gridSize(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            pixelSize = 10
            collectionView.reloadData()
        case 1:
            pixelSize = 15
            collectionView.reloadData()
        case 2:
            pixelSize = 20
            collectionView.reloadData()
        default:
            break
        }
    }
    
    @objc private func updateGeneration() {
        generationLabel.text = "Generation \(game.generation)"
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource[indexPath.item].isAlive.toggle()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pixelSize, height: pixelSize)
    }
}
