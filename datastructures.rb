
class RasLinkedList
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
	
	# add _elt_ to the list
	def add!(elt)
		node = RasNode.new(elt, @tail)
		@head = node if @head.nil?
		@tail.nextNode = node unless @tail.nil?
		@tail = node
		@length += 1
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

	def verify(expectedLength = @length)
		# check that the length of the list matches what is expected (both internally and what the user specifies
		raise "LL error: Internal length " << length << " doesn't match expected length " << expectedLength if expectedLength != @length
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
ll = RasLinkedList.new()
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

puts "RasLinkedList loaded"
	