# There are N network nodes, labelled 1 to N.
#
# Given times, a list of travel times as directed edges times[i] = (u, v, w), where u is the source node, v is the target node, and w is the time it takes for a signal to travel from source to target.
#
# Now, we send a signal from a certain node K. How long will it take for all nodes to receive the signal? If it is impossible, return -1.
#
# Note:
# N will be in the range [1, 100].
# K will be in the range [1, N].
# The length of times will be in the range [1, 6000].
# All edges times[i] = (u, v, w) will have 1 <= u, v <= N and 1 <= w <= 100.

module ALDiGraph
    class Vertex
        attr_accessor :val, :dist, :prev

        def initialize(val)
            @val = val
            @dist = Float::INFINITY
            @prev = nil
        end
    end

    class Graph
        attr_accessor :graph

        def initialize
            @graph = {}
        end

        def add_vertex(v)
            @graph[v] = {
                vertex: ALDiGraph::Vertex.new(v),
                adjacents: []
            } if @graph[v].nil?
        end

        def num_vertices
            @graph.keys.length
        end

        def remove_vertex(v)
            deleted = @graph.delete(v)
            @graph.each_value do |al|
                al[:adjacents].delete_if { |adj| adj[0] == v }
            end
            deleted
        end

        def add_edge(v1, v2, w)
            return if @graph[v1].nil? || @graph[v2].nil?
            v1_adjacents = @graph[v1][:adjacents]
            e = v1_adjacents.find { |adj| adj[0] == v2 }
            e ? e[1] = w : v1_adjacents << [v2, w]
        end

        def get_edge_value(v1, v2)
            @graph[v1][:adjacents].find { |adj| adj[0] == v2 }[1]
        end

        def remove_edge(v1, v2)
            return if @graph[v1].nil? || @graph[v2].nil?
            @graph[v1][:adjacents].delete_if { |adj| adj[0] == v2 }
        end

        def print
            p @graph
        end
    end
end

class MinHeap
    attr_accessor :heap

    def initialize(nums = [])
        @heap = nums
        heapify
    end

    def empty?
        @heap.empty?
    end

    def peek
        @heap[0]
    end

    def insert(num)
        @heap << num
        sift_up
    end

    def extract_min
        @heap[0], @heap[@heap.length - 1] = @heap[@heap.length - 1], @heap[0]
        val = @heap.pop
        sift_down
        val
    end

    def heapify
        i = 0
        while i < @heap.length
            j = i
            while j > 0
                parent_i = (j - 1) / 2
                if @heap[j].dist < @heap[parent_i].dist
                    @heap[j], @heap[parent_i] = @heap[parent_i], @heap[j]
                    j = parent_i
                else
                    break
                end
            end
            i += 1
        end
    end

    private

    def sift_up
        i = @heap.length - 1
        while i > 0
            parent_i = (i - 1) / 2
            if @heap[i].dist < @heap[parent_i].dist
                @heap[i], @heap[parent_i] = @heap[parent_i], @heap[i]
                i = parent_i
            else
                break
            end
        end
    end

    def sift_down
        return if @heap.length < 2
        i = 0
        while i <= (@heap.length - 2) / 2
            left_i = i * 2 + 1
            right_i = i * 2 + 2
            smaller_i = @heap[right_i].nil? || (@heap[left_i].dist < @heap[right_i].dist) ? left_i : right_i
            if @heap[smaller_i].dist < @heap[i].dist
                @heap[smaller_i], @heap[i] = @heap[i], @heap[smaller_i]
                i = smaller_i
            else
                break
            end
        end
    end
end

def relax(graph, v1, v2)
    new_dist = v1.dist + graph.get_edge_value(v1.val, v2.val)
    if new_dist < v2.dist
        v2.dist = new_dist
        v2.prev = v1
    end
end

# @param {Integer[][]} times
# @param {Integer} n
# @param {Integer} k
# @return {Integer}
def network_delay_time(times, n, k)
    graph = ALDiGraph::Graph.new
    times.each do |t|
        graph.add_vertex(t[0])
        graph.add_vertex(t[1])
        graph.add_edge(t[0], t[1], t[2])
    end
    return -1 if graph.num_vertices != n
    unvisited = MinHeap.new
    graph.graph.each_key do |key|
        graph.graph[key][:vertex].dist = 0 if key == k
        unvisited.insert(graph.graph[key][:vertex])
    end

    while !unvisited.empty?
        curr = unvisited.extract_min
        graph.graph[curr.val][:adjacents].each do |adj|
            relax(graph, curr, graph.graph[adj[0]][:vertex])
        end
        unvisited.heapify
    end

    max = 0
    graph.graph.each_key do |key|
        max = graph.graph[key][:vertex].dist if graph.graph[key][:vertex].dist > max
    end
    max == Float::INFINITY ? -1 : max
end

# graph = ALDiGraph::Graph.new
# graph.add_vertex(1)
# graph.add_vertex(2)
# graph.add_vertex(3)
# graph.add_vertex(4)
# graph.add_edge(2, 1, 1)
# graph.add_edge(2, 3, 1)
# graph.add_edge(3, 4, 1)
# graph.print

# heap = MinHeap.new([4, 6, 2, 8, 1, 3])
# p heap.heap
# heap.insert(5)
# p heap.heap
# heap.pop
# p heap.heap
