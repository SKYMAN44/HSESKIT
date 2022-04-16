//
//  DynamicSegment+Helper.swift
//  HSE
//
//  Created by Дмитрий Соколов on 16.04.2022.
//

import Foundation

// MARK: - Helper Types
public extension DynamicSegments {
    public struct Configuration {
        private var currentChoice: [Node<Item>] = []
        private var options: Node<Item>
        private var treeHead: Node<Item>
        private(set) var currentItemIndex: Int = 0
        
        public var placeholders: [Item] {
            var node = treeHead
            var placeholders = [Item]()
            while(!node.children.isEmpty) {
                placeholders.append(node.childrenCategory)
                node = node.children[0]
            }
            return placeholders
        }
        
        public var viewModelForTopPart: [Item] {
            var result = [Item]()
            let arr2 = placeholders
            for i in 0...arr2.count - 1 {
                if(currentChoice.indices.contains(i)) {
                    var temp = currentChoice[i].value
                    temp.isChoosen = true
                    result.append(temp)
                } else {
                    result.append(arr2[i])
                }
            }
            return result
        }
        
        public var availableOptionsAtCurrentState: [Item] {
            let arr = options.children.map { $0.value }
            return arr
        }
        
        public var currentPath: [Item] {
            return currentChoice.map { $0.value }
        }
        
        public init(_ options: Node<Item>) {
            self.options = options
            self.treeHead = options
        }
        
        // fix
        public mutating func chooseOption(item: Item) -> Item? {
            if let option = options.children.first(where: { $0.value == item }) {
                if let index = currentChoice.firstIndex(where: { $0 == options }) {
                    if currentChoice.indices.contains(index + 1) {
                        rollBackToState(index + 1)
                        currentChoice[index + 1] = option
                        currentItemIndex = index + 1
                        options = option
                        return item
                    }
                }
                if(currentItemIndex > 0 && options == self.treeHead) {
                    rollBackToState(0)
                    currentChoice[0] = option
                    currentItemIndex = 1
                    options = option
                    return item
                }
                currentChoice.append(option)
                options = option
                currentItemIndex += 1
                
                return item
            }
            return nil
        }
        
        public mutating func rollBackToState(_ stateIndex: Int) {
            for i in stateIndex+1..<currentChoice.count {
                currentChoice.removeLast()
                currentItemIndex = i
            }
        }
        
        public mutating func seeOptionsForPrevSections(_ index: Int) {
            if index != 0 {
                options = currentChoice[index - 1]
            } else {
                options = treeHead
            }
        }
        
        public struct Item: Equatable, Hashable {
            var isChoosen: Bool = false
            let presentingName: String
            let id = UUID()
            
            public static func == (lhs: Item, rhs: Item) -> Bool {
                return lhs.id == rhs.id
            }
        }
    }
    
    // MARK: - Tree DS
    public struct Node<Value>: Equatable {
        let id = UUID()
        var value: Value
        var childrenCategory: Value
        var children: [Node]
        
        public init(_ value: Value, childrenCategory: Value) {
            self.value = value
            self.childrenCategory = childrenCategory
            self.children = []
        }

        public init(_ value: Value, childrenCategory: Value, children: [Node]) {
            self.init(value, childrenCategory: childrenCategory)
            self.children = children
        }
        
        public mutating func add(child: Node) {
            children.append(child)
        }
        
        public mutating func add(child: [Node]) {
            children.append(contentsOf: child)
        }
        
        public static func == (lhs: DynamicSegments.Node<Value>, rhs: DynamicSegments.Node<Value>) -> Bool {
            return lhs.id == rhs.id
        }
    }
}
