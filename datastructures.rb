
class RasLinkedList
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
	
	# add each entry in _elts_ to the list
	def add!(*elts)
		elts.each do | elt |
			node = RasNode.new(elt, @tail)
			@head = node if @head.nil?
			@tail.nextNode = node unless @tail.nil?
			@tail = node
			@length += 1
		end
	end

	def add_all!(elements)
		add!(*elements)
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
		result.add!(*old_sort)
		result
	end
	
	def verify(expectedLength = @length)
		# check that the length of the list matches what is expected (both internally and what the user specifies
		raise "LL error: Internal length " << length.to_s << " doesn't match expected length " << expectedLength.to_s if expectedLength != @length
		count = 0
		currentNode = @head
		raise "LL error: @head element had a non-null previous element" unless currentNode.nil? or currentNode.previousNode.nil?
		until currentNode.nil? do
			count += 1
			nextNode = currentNode.nextNode
			raise "LL error: @tail \"" << @tail.to_s << "\" doesn't match found tail \"" << currentNode.to_s << "\"" if nextNode.nil? and not currentNode == @tail
			currentNode = nextNode
		end
		raise "LL error: Expected length " << expectedLength.to_s << " but got " << count.to_s if expectedLength != count

	end
end

# Minor testing
ll = RasLinkedList.new
ll.verify
ll.add!("ryan")
ll.add!("andrew")
ll.add!("sciampacone")
ll.verify(3)
ll.remove!("andrew")
ll.verify(2)
ll.remove!("ryan")
ll.verify(1)
ll.add!("nobody")
ll.remove!("sciampacone")
ll.verify(1)
ll.remove!("nobody")
ll.verify(0)
ll.add!("ryan")
ll.add!("ryan")
ll.verify(2)
ll.remove!("Ryan")
ll.verify(2)
ll.remove!("ryan")
ll.verify(0)

ll = RasLinkedList.new
ll.add_all!([1,2,3,4])
ll.verify(4)

# Check basic Enumeration
ll = RasLinkedList.new
ll.add_all!(["ryan", "andrew", "sciampacone"])
ll.verify(3)
result = ""
ll.each { |x| result << x }
raise "LL test error: Basic each() iteration didn't visit all items and/or in correct order" unless result == "ryanandrewsciampacone"
ll.verify

# Check mixin Enumeration
ll = RasLinkedList.new
ll.add!(1,2,3,4)
result = ll.collect {|x| x * x}
raise "LL test error: collect() on squares didn't return correct array " << result.to_s unless result == [1,4,9,16]

# Check if each can return a real Enumerable
iterator = ll.each
result = iterator.collect{|x| x + x}
raise "LL test error: each as an Enumerable didn't map to correct doubling array " << result.to_s unless result == [2,4,6,8]

# Check basic comparison
ll1 = RasLinkedList.new
ll1.add!(1,2,3)
ll1.verify
ll2 = RasLinkedList.new
ll2.add!(1,2,3)
ll2.verify
raise "LL test error: Equal linked lists didn't compare" unless ll1 == ll2
ll2.add!(0)
raise "LL test error: Inequal linked lists compared equal" unless ll1 != ll2
raise "LL test error: First list should have compared less than second list" unless  ll1 < ll2
ll2.remove!(3)
raise "LL test error: Second list should have compared less than first list" unless ll2 < ll1
raise "LL test error: Empty list should have compared less than populated list" unless RasLinkedList.new < ll1

ll = RasLinkedList.new
ll.add!(3,2,4,5,1)
result = ll.sort
result.verify(5)
raise "LL test error: Sort should return a RasLinkedList type" unless result.is_a? RasLinkedList
compare = RasLinkedList.new
compare.add!(1,2,3,4,5)
raise "LL test error: Sort didn't return a sorted version" unless result == compare


puts "RasLinkedList loaded"
