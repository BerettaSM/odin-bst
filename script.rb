require './bst.rb'

array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)

tree.pretty_print
puts "Is tree balanced? #{tree.balanced?}"

puts "Level order"
p tree.level_order

puts "Pre-order"
p tree.preorder

puts "In-order"
p tree.inorder

puts "Post-order"
p tree.postorder

10.times { tree.insert(rand(100..200)) }

tree.pretty_print
puts "Is tree balanced? #{tree.balanced?}"

tree.rebalance

tree.pretty_print
puts "Is tree balanced? #{tree.balanced?}"

puts "Level order"
p tree.level_order

puts "Pre-order"
p tree.preorder

puts "In-order"
p tree.inorder

puts "Post-order"
p tree.postorder
