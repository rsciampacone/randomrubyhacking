
class RasLinkedList
	def initialize
		@head = nil
		@tail = nil
		@length = 0
	end
	
	attr_reader :length

	class RasLLNode 
		def initialize(newElt, previousNode, nextNode = nil)
			@elt = newElt
			@previousNode = previousNode
			@nextNode = nextNode;
		end
		
		attr_reader :elt, :previousNode
		attr :nextNode, true
	end
	
	def add(elt)
		node = RasLLNode.new(elt, @tail)
		@head = node if @head.nil?
		@tail.nextNode = node if not @tail.nil?
		@tail = node
		@length += 1
	end
	
	def verify(expectedLength = @length)
		raise "LL error: Internal length " << length << " doesn't match expected length " << expectedLength if expectedLength != @length
		count = 0
		currentElt = @head
		until currentElt.nil? do
			count += 1
			currentElt = currentElt.nextNode
		end
		raise "LL error: Expected length " << expectedLength.to_s << " but got " << count.to_s if expectedLength != count
	end
end

# Minor testing
ll = RasLinkedList.new()
ll.verify
ll.add("ryan")
ll.add("andrew")
ll.verify(2)


puts "RasLinkedList loaded"
	