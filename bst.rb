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

    def to_s
        string = "TreeNode (data=#{@data}"
        string += "#{@left ? ", left="+@left.data.to_s : nil}"
        string += "#{@right ? ", right="+@right.data.to_s : nil})"
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

    def delete(value, target=@root)
        return nil if target.nil?

        if value < target.data
            target.left = delete(value, target.left)
        elsif value > target.data
            target.right = delete(value, target.right)
        else
            # When the node is found, if any of its child slots is empty,
            # We safely return the opposite child.

            # If the opposite child is also missing, no harm done,
            # the node's parent (one call behind on the recursion call) will simply delete it
            # by setting the respective child to nil.

            # If there is, however, an opposite child, either left or right,
            # the node's parent will simply update the respective child
            # to point to this node's existing child, effectively removing
            # the node from the tree.
            return target.right if target.left.nil?
            return target.left if target.right.nil?

            # At this point, the node has two childs
            # We need to find the leftmost child of its right child
            leftmost_child = find_leftmost_child(target.right)
            target.data = leftmost_child.data
            target.right = delete(leftmost_child.data, target.right)
        end
        return target
    end

    def find(value, target=@root)
        return nil if target.nil?
        return find(value, target.left) if value < target.data
        return find(value, target.right) if value > target.data
        return target
    end

    def level_order
        queue = [ @root ]
        index = 0
        while index < queue.length
            node = queue[index]
            queue.push(node.left) if !node.left.nil?
            queue.push(node.right) if !node.right.nil?
            if block_given?
                yield node
            else
                queue[index] = node.data
            end
            index += 1
        end
        return queue if !block_given?
    end

    def inorder(target=@root, nodes=[], &block)
        return if target.nil?
        inorder(target.left, nodes, &block)
        block.call(target) if block_given?
        nodes.append(target.data) if !block_given?
        inorder(target.right, nodes, &block)
        return nodes if !block_given?
    end

    def preorder(target=@root, nodes=[], &block)
        return if target.nil?
        block.call(target) if block_given?
        nodes.append(target.data) if !block_given?
        preorder(target.left, nodes, &block)
        preorder(target.right, nodes, &block)
        return nodes if !block_given?
    end

    def postorder(target=@root, nodes=[], &block)
        return if target.nil?
        postorder(target.left, nodes, &block)
        postorder(target.right, nodes, &block)
        block.call(target) if block_given?
        nodes.append(target.data) if !block_given?
        return nodes if !block_given?
    end

    def height(target=@root)
        height = 0
        until target.left.nil? && target.right.nil?
            if target.left.nil?
                target = target.right
            else
                target = target.left
            end
            height += 1
        end
        return height
    end

    def depth(target=@root)
        return -1 if target.nil?
        node = @root
        depth = 0
        until node.nil? || node == target
            if target < node
                node = node.left
            else
                node = node.right
            end
            depth += 1
        end
        return node.nil? ? -1 : depth
    end

    def height(target=@root)
        return 0 if target.nil?
        [height(target.left), height(target.right)].max + 1
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

    def find_leftmost_child(target=@root)
        target = target.left until target.left.nil?
        return target
    end
end

tree = Tree.new([1,2,3,4,5,6,7,8,9,10, 11, 12, 13, 14, 15, 16, 17])
n = tree.find(3)
tree.pretty_print
p tree.height
