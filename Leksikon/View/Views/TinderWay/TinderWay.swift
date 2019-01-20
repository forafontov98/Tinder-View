//
//  TinderWay.swift
//  Leksikon
//
//  Created by Владислав Форафонтов on 19/01/2019.
//  Copyright © 2019 Владислав Форафонтов. All rights reserved.
//

import UIKit

protocol TinderWayDelegate {
    /// Вызывается, когда двигаем ячейку
    /// - Parameter offset: перемещение ячейки относительно центра
    func motion(card: TinderCell, offset: CGPoint)
    
    /** Вызывается, когда карточка уходит вправо */
    func toRight(card: TinderCell)
    
    /** Вызывается, когда карточка уходит влево */
    func toLeft(card: TinderCell)
    
    /** Вызывается, когда карточка возвращается к центру */
    func toCenter(card: TinderCell)
    
    /** Вызывается при двойном тапе по области TinderWay */
    func doubleTapped(card: TinderCell)
}


protocol TinderWayDataSource {
    /** Возвращает количество ячеек */
    func numberOfItems() -> Int
    
    /** Возвращает экземпляр класса UIView в качесвте ячейки для id */
    func cell(_ id: Int) -> UIView
}

/** Класс ленты ячеек, как у тиндера. Обладает возможностью свайпа с реализованной анимацией, как у тиндера, с двойным тапом */
@IBDesignable
class TinderWay: UIView {
    
    var delegate: TinderWayDelegate?
    var dataSource: TinderWayDataSource? {
        didSet {
            numberOfItems = dataSource!.numberOfItems()
            
            fillCells()
            
            divisor = (frame.width / 2) / 0.4
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.pan(recognizer:)))
            addGestureRecognizer(panGesture)
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap(recognizer:)))
            doubleTap.numberOfTapsRequired = 2
            addGestureRecognizer(doubleTap)
        }
    }
    
    /** Ссылки на ячейки. cells[0] - ближняя к пользователю, cells[2] - дальняя */
    private var cells: [TinderCell] = []
    
    /** id текущей ячейки */
    private var currentID = 0
    
    /** Общее количество ячеек */
    private var numberOfItems = 0
    
    /** Показатель, от которого зависит rotate ячейки */
    private var divisor: CGFloat!
    
    /** Разница в размерах ячеек, scale */
    @IBInspectable var scale: CGFloat = 0.1
    
    /** Количество видимых ячеек сзади */
    @IBInspectable var visibleCellsCount = 3
    
    /** Насколько ячейки отстают друг от друга вверх */
    @IBInspectable var topOffset: CGFloat = 7.0
    
    /** Duration анимаций */
    @IBInspectable var duration: Double = 0.3
    
    /** Функция заполняет ячейками массив cells в первый раз */
    private func fillCells() {
        
        if let dataSource = dataSource {
            var id = 0
            
            while id < min(visibleCellsCount, numberOfItems) {
                
                let currentScale = 1.0 - scale * CGFloat(id)
                var currentCenter = CGPoint(x: frame.width / 2, y: frame.height / 2)
                
                let cell = TinderCell(view: dataSource.cell(id), scale: currentScale)
                
                if id != 0 {
                    let offset = (cell.nativeSize.height - cell.scaleSize.height) / 2 + topOffset * CGFloat(id)
                    currentCenter.y -= offset
                }
                
                cells.append(cell)
                
                cell.scale = currentScale
                cell.center = currentCenter
                
                self.insertSubview(cell.view, at: 0)
                
                id += 1
            }
        }
    }
    
    /** Реализует функционал, когда убирается верхняя ячейка, сзади добавляется новая и все они двигаются на место ушедшей ячейки */
    private func pop() {
        cells.removeFirst().view.removeFromSuperview()
        
        if currentID < numberOfItems {
            currentID += 1
        }
        
        /* добавляем новую карточку сзади */
        if currentID < numberOfItems - (visibleCellsCount - 1) {
            let scale = cells.last!.scale
            let cell = TinderCell(view: dataSource!.cell(currentID + (visibleCellsCount - 1)), scale: scale!)
            
            cell.scale = scale
            cell.center = CGPoint(x: cells.last!.center.x, y: cells.last!.center.y + 20.0)
            
            cells.append(cell)
            self.insertSubview(cell.view, at: 0)
            
            UIView.animate(withDuration: duration) {
                cell.center.y -= 20.0
            }
        }
        
        /* анимируем, передвигаем все карточки вперед */
        for (id, cell) in cells.enumerated() {
            
            if id == cells.count - 1 && cells.count > visibleCellsCount - 1 {continue}
            
            let newScale = 1.0 - scale * CGFloat(id)
            var currentCenter = CGPoint(x: frame.width / 2, y: frame.height / 2)
            
            if id != 0 {
                let offset = (cell.nativeSize.height - cell.scaleSize.height) / 2 + topOffset * CGFloat(id - 1)
                currentCenter.y -= offset
            }
            
            UIView.animate(withDuration: duration) {
                
                cell.scale = newScale
                cell.center = currentCenter
            }
        }
    }
    
    
    /** Действие вызывается при двойном тапе по TinderWay*/
    @objc func doubleTap(recognizer: UITapGestureRecognizer) {
        if let card = cells.first {
            delegate?.doubleTapped(card: card)
        }
    }

    
    /** Действие вызывается при ведении пальцем по TinderWay. Здесь реализуется анимация ячейки */
    @objc func pan(recognizer: UIPanGestureRecognizer) {
        guard let card = cells.first else {
            return
        }
        
        let point = recognizer.translation(in: self)
        let xFromCenter = card.center.x - self.center.x
        let yFromCenter = card.center.y - self.center.y
        
        delegate?.motion(card: card, offset: CGPoint(x: xFromCenter, y: yFromCenter))
        
        card.center = CGPoint(x: frame.width / 2 + point.x, y: frame.height / 2 + point.y)
        
        for (id, cell) in cells.enumerated() {
            if id == 0 {continue}
            
            let scale = cell.scale + min(max(0.0, abs(xFromCenter) / 8000.0), self.scale)
            cell.currentScale = scale
        }
        
        let scale =  min(150 / abs(xFromCenter), 1.0)
        card.view.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor).scaledBy(x: scale, y: scale)
        
        if recognizer.state == .ended {
            if card.center.x < 120 {
                
                toLeft()
                return
                
            } else if card.center.x > (frame.width - 120) {
                
                toRight()
                return
            }
            
            UIView.animate(withDuration: duration) {
                self.delegate?.toCenter(card: card)
                
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                card.view.alpha = 1.0
                card.view.transform = CGAffineTransform.identity
                
            }
        }
    }

    
    /** Анимация карточки влево */
    func toLeft() {
        
        guard let card = cells.first else {return}
        
        delegate?.toLeft(card: card)

        UIView.animate(withDuration: 0.2, animations: {
            card.center = CGPoint(x: card.center.x - 200.0, y: card.center.y)
            card.view.transform = CGAffineTransform(rotationAngle: -200.0 / self.divisor)
            card.view.alpha = 0
            
        }) { (_) in
            self.pop()
        }
    }
    
    
    /** Анимация карточки вправо */
    func toRight() {
        
        guard let card = cells.first else {return}

        delegate?.toRight(card: card)

        UIView.animate(withDuration: 0.2, animations: {
            card.center = CGPoint(x: card.center.x + 200.0, y: card.center.y)
            card.view.transform = CGAffineTransform(rotationAngle: 200.0 / self.divisor)
            card.view.alpha = 0
            
        }) { (_) in
            self.pop()
        }
    }
    
    
    /** Возвращает текущую, верхнюю карточку, если такая есть. Иначе nil */
    func currentCard() -> TinderCell? {
        if let card = cells.first {
            return card
        }
        
        return nil
    }
    
    
    /** На карточку назад */
    func back() {
        
    }
}
