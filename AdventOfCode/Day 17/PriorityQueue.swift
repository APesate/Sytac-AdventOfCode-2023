//
//  PriorityQueue.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 17/12/2023.
//

import Foundation

struct PriorityQueue<Element> {
    private var heap: [Element]
    private let areSorted: (Element, Element) -> Bool

    init(sort: @escaping (Element, Element) -> Bool) {
        self.heap = []
        self.areSorted = sort
    }

    var isEmpty: Bool {
        return heap.isEmpty
    }

    mutating func enqueue(_ element: Element) {
        heap.append(element)
        siftUp(from: heap.count - 1)
    }

    mutating func dequeue() -> Element? {
        guard !heap.isEmpty else {
            return nil
        }
        heap.swapAt(0, heap.count - 1)
        let dequeued = heap.removeLast()
        siftDown(from: 0)
        return dequeued
    }

    private mutating func siftUp(from index: Int) {
        var childIndex = index
        let child = heap[childIndex]
        var parentIndex = self.parentIndex(ofChildAt: childIndex)

        while childIndex > 0 && areSorted(child, heap[parentIndex]) {
            heap[childIndex] = heap[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(ofChildAt: childIndex)
        }

        heap[childIndex] = child
    }

    private mutating func siftDown(from index: Int) {
        var parentIndex = index

        while true {
            let leftChildIndex = self.leftChildIndex(ofParentAt: parentIndex)
            let rightChildIndex = leftChildIndex + 1

            var optionalCandidateIndex: Int?

            if leftChildIndex < heap.count && areSorted(heap[leftChildIndex], heap[parentIndex]) {
                optionalCandidateIndex = leftChildIndex
            }

            if rightChildIndex < heap.count && areSorted(heap[rightChildIndex], heap[optionalCandidateIndex ?? parentIndex]) {
                optionalCandidateIndex = rightChildIndex
            }

            guard let candidateIndex = optionalCandidateIndex else {
                return
            }

            heap.swapAt(parentIndex, candidateIndex)
            parentIndex = candidateIndex
        }
    }

    private func parentIndex(ofChildAt index: Int) -> Int {
        (index - 1) / 2
    }

    private func leftChildIndex(ofParentAt index: Int) -> Int {
        (2 * index) + 1
    }
}
