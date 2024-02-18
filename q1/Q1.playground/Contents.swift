print("Q1.")
let g = Graph.q1()
print("a. Write a function that returns all the possible paths between A­-H.")
let paths: [[String]] = g.findAll(from: g.nodeA, to: g.nodeH)
for (index, val) in paths.enumerated() {
    print("\(index + 1): \(val)")
}
print("b. Write a function that returns the least number of hops (shortest path) between A­-H.")
print(g.findShortest(from: g.nodeA, to: g.nodeH))
