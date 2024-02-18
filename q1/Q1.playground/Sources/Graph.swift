import Foundation

public class Node {
    let id: String
    var children: [Node]
    
    init(id: String, children: [Node] = []) {
        self.id = id
        self.children = children
    }
}

public class Graph {
    public var nodes: [Node]
    
    public init(vertices: Int, nodes: [Node]) {
        self.nodes = nodes
    }
    
    public func findAll(from s: Node, to d: Node) -> [[String]] {
        var isVisited: Set<String> = Set()
        var path = [s.id]
        var results: [[String]] = []
        find(u: s, d: d, isVisited: &isVisited, path: &path, store: &results)
        return results
    }
    
    private func find(u: Node, d: Node, isVisited: inout Set<String>, path: inout [String], store: inout [[String]], shortest: Bool = false) {
        if u.id == d.id {
            store.append(path)
            return
        }
        isVisited.insert(u.id)
        // loop child level
        for i in u.children {
            if !isVisited.contains(i.id) {
                // early exit loop when finding shortest path
                if shortest, store.count > 0,
                    (path.count + 1) >= (store.min(by: { $0.count < $1.count }) ?? []).count {
                    continue
                }
                path.append(i.id)
                // go search deeper level
                find(u: i, d: d, isVisited: &isVisited, path: &path, store: &store, shortest: shortest)
                path.removeLast()
                    
            }
        }
        isVisited.remove(u.id)
    }
    
    public func findShortest(from s: Node, to d: Node) -> [String] {
        var isVisited: Set<String> = Set()
        var path = [s.id]
        var results: [[String]] = []
        
        find(u: s, d: d, isVisited: &isVisited, path: &path, store: &results, shortest: true)
        
        return results.min(by: { $0.count < $1.count }) ?? []
    }
}

extension Graph {
    // MARK: Q1
    public var nodeA: Node {
        get { return nodes.first(where: { $0.id == "A"})! }
    }
    public var nodeH: Node {
        get { return nodes.first(where: { $0.id == "H"})! }
    }
    public static func q1() -> Graph {
        let a = Node(id: "A")
        let b = Node(id: "B")
        let c = Node(id: "C")
        let d = Node(id: "D")
        let e = Node(id: "E")
        let f = Node(id: "F")
        let g = Node(id: "G")
        let h = Node(id: "H")

        a.children = [b, d, h]
        b.children = [a, c, d]
        c.children = [b, d, f]
        d.children = [a, b, c, e]
        e.children = [d, f, h]
        f.children = [c, e, g]
        g.children = [f, h]
        h.children = [a, g]

        let gh = Graph(vertices: 8, nodes: [a, b, c, d, e, f, g, h])
        return gh
    }
}
