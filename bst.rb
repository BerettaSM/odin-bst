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

    def insert(value, target=@root)
        return TreeNode.new(value) if target.nil?

        if value == target.data
            return target
        elsif value > target.data
            target.right = insert(value, target.right)
        else
            target.left = insert(value, target.left)
        end

        return target
    end

    def find(value, target=@root)
        return nil if target.nil?
        return find(value, target.left) if value < target.data
        return find(value, target.right) if value > target.data
        return target
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
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
