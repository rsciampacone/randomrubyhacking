
# Very basic linked list structure.
# Hacking around learning Ruby.
#
# Notes
# 1) Enumerables are left to return arrays.  The "sort" override demonstrates converting back to a RasLinkedList
#
class RasLinkedList
	VERSION = "0.0.0"

	include Enumerable
	include Comparable

	def initialize
		@head = nil
		@tail = nil
		@length = 0
	end
	
	attr_reader :length

	class RasNode 
		def initialize(newElt, previousNode, nextNode = nil)
			@elt = newElt
			@previousNode = previousNode
			@nextNode = nextNode;
		end
		
		attr_reader :elt
		attr_accessor :previousNode, :nextNode
	end

	def empty?
		@head.nil?
	end
		
	# add each entry in _elts_ to the list
	def add(*elts)
		elts.each do | elt |
			node = RasNode.new(elt, @tail)
			@head = node if @head.nil?
			@tail.nextNode = node unless @tail.nil?
			@tail = node
			@length += 1
		end
	end

	def add_all(elements)
		add(*elements)
	end
	
	# rules for equality (this will seem a lot like strings)
	# 1) Compare each element with its matching indexed element and return <=> of the first unequal one
	# 2) If one list is shorter, and all elements compare ==, then return the shorter list as being <
	# 3) If all elements are equal, then return 0

	def <=>(otherLL)
		node = @head
		otherLL.each do | otherElt |
			return -1 if node.nil?
			return node.elt <=> otherElt unless node.elt == otherElt
			node = node.nextNode
		end
		node.nil? ? 0 : 1
	end
	
	def ==(otherLL)
		(self <=> otherLL) == 0
	end

	# remove all occurrences of _elt_ from the list
	def remove!(elt)
		node = @head
		until node.nil? do
			until node.nil? do
				break if node.elt == elt
				node = node.nextNode
			end

			break if node.nil?

			node.previousNode.nextNode = node.nextNode unless node.previousNode.nil?
			node.nextNode.previousNode = node.previousNode unless node.nextNode.nil?
			@head = node.nextNode if @head == node
			@tail = node.previousNode if @tail == node
			@length -= 1
			
			node = node.nextNode
		end
	end

	def each
		if block_given?
			node = @head
			until node.nil? do
				yield node.elt
				node = node.nextNode
			end
		else
			enum_for(:each)
		end
	end
	
	# This is really just seeing if I understand this
	alias old_sort sort
	private :old_sort
	def sort
		result = self.class.new
		result.add(*old_sort)
		result
	end
end
