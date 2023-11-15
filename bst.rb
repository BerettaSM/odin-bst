class TreeNode
    include Comparable
    attr_accessor :data, :left, :right

    def <=>(other)
        data <=> other.data
    end

    def initialize(data, left=nil, right=nil)
        @data = data
        @left = left
        @right = right
    end
end

class Tree
    attr_accessor :root

    def initialize(array)
        treated_array = array.sort.uniq
        @root = build_tree(treated_array)
    end

    private

    def build_tree(array)
        return nil if array.nil? || array.empty?
        mid = array.length / 2
        root = TreeNode.new(array[mid])
        root.left = build_tree(array[0, mid])
        root.right = build_tree(array[mid+1..])
        return root
    end
end
