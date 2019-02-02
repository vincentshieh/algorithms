# K Closest Points to Origin
#
# We have a list of points on the plane.  Find the K closest points to the origin (0, 0).
#
# (Here, the distance between two points on a plane is the Euclidean distance.)
#
# You may return the answer in any order.  The answer is guaranteed to be unique (except for the order that it is in.)
#
#
#
# Example 1:
#
# Input: points = [[1,3],[-2,2]], K = 1
# Output: [[-2,2]]
# Explanation:
# The distance between (1, 3) and the origin is sqrt(10).
# The distance between (-2, 2) and the origin is sqrt(8).
# Since sqrt(8) < sqrt(10), (-2, 2) is closer to the origin.
# We only want the closest K = 1 points from the origin, so the answer is just [[-2,2]].

# Example 2:
#
# Input: points = [[3,3],[5,-1],[-2,4]], K = 2
# Output: [[3,3],[-2,4]]
# (The answer [[-2,4],[3,3]] would also be accepted.)
#
#
# Note:
#
# 1 <= K <= points.length <= 10000
# -10000 < points[i][0] < 10000
# -10000 < points[i][1] < 10000

def quick_select_helper(points, start_i, end_i, k)
    return points.take(k) if points.length < 2 || start_i >= end_i
    pivot = start_i
    i = start_i + 1
    part_i = start_i + 1
    pivot_dist = Math.sqrt(points[pivot][0]**2 + points[pivot][1]**2)
    while i < end_i
        dist = Math.sqrt(points[i][0]**2 + points[i][1]**2)
        if dist < pivot_dist
            part_i += 1
            points[i], points[part_i - 1] = points[part_i - 1], points[i]
        end
        i += 1
    end
    points[pivot], points[part_i - 1] = points[part_i - 1], points[pivot]
    if part_i < k
        return quick_select_helper(points, part_i, end_i, k)
    elsif part_i > k
        return quick_select_helper(points, start_i, part_i, k)
    end
    points.take(k)
end

def k_closest(points, k)
    return points if k == points.length
    quick_select_helper(points, 0, points.length, k)
end
