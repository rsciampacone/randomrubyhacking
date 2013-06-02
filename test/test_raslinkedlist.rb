# This is some old test code loosely converted to the Minitest unit format.
# Not necessarily the most comprehensive but it tries out the framework
#

$:.push File.expand_path("../lib", File.dirname(__FILE__))

require 'minitest/autorun'
require 'raslinkedlist'

class RasLinkedList
	def verify(tester, expectedLength = @length)
		# check that the length of the list matches what is expected (both internally and what the user specifies
		tester.assert_equal expectedLength, @length, "LL error: Internal length " << length.to_s << " doesn't match expected length " << expectedLength.to_s
		count = 0
		currentNode = @head
		tester.assert currentNode.nil? || currentNode.previousNode.nil?, "LL error: @head element had a non-null previous element"
		until currentNode.nil? do
			count += 1
			nextNode = currentNode.nextNode
			tester.assert !nextNode.nil? || currentNode == @tail, "LL error: @tail \"" << @tail.to_s << "\" doesn't match found tail \"" << currentNode.to_s << "\""
			currentNode = nextNode
		end
		tester.assert_equal expectedLength, count, "LL error: Expected length " << expectedLength.to_s << " but got " << count.to_s
	end
end

class TestRasLinkedList < Minitest::Test
	def test_new_is_empty
		ll = RasLinkedList.new
		ll.verify(self)
		assert_empty ll, "New list should have been empty"
	end
	
	def test_basic_add_and_remove_works
		ll = RasLinkedList.new
		ll.add("ryan")
		ll.add("andrew")
		ll.add("sciampacone")
		ll.verify(self, 3)
		ll.remove!("andrew")
		ll.verify(self, 2)
		ll.remove!("ryan")
		ll.verify(self, 1)
		ll.add("nobody")
		ll.remove!("sciampacone")
		ll.verify(self, 1)
		ll.remove!("nobody")
		ll.verify(self, 0)
		ll.add("ryan")
		ll.add("ryan")
		ll.verify(self, 2)
		ll.remove!("Ryan")
		ll.verify(self, 2)
		ll.remove!("ryan")
		ll.verify(self, 0)
		assert_empty ll, "List after equal adds and removes should have been empty"
	end		

	def test_basic_add_all_functionality
		ll = RasLinkedList.new
		ll.add_all([1,2,3,4])
		ll.verify(self, 4)
	end

	def test_basic_enumeration
		# Check basic Enumeration
		ll = RasLinkedList.new
		ll.add_all(["ryan", "andrew", "sciampacone"])
		ll.verify(self, 3)
		result = ""
		ll.each { |x| result << x }
		assert_equal result, "ryanandrewsciampacone", "LL test error: Basic each() iteration didn't visit all items and/or in correct order"
		ll.verify(self)
	end

	def test_basic_enumeration
		ll = RasLinkedList.new
		ll.add(1,2,3,4)
		result = ll.collect {|x| x * x}
		assert_equal result, [1,4,9,16], "LL test error: collect() on squares didn't return correct array " << result.to_s
	end
	
	def test_returning_an_enumerable
		ll = RasLinkedList.new
		ll.add(1,2,3,4)
		iterator = ll.each
		result = iterator.collect{|x| x + x}
		assert_equal result, [2,4,6,8], "LL test error: each as an Enumerable didn't map to correct doubling array " << result.to_s
	end

	def test_basic_comparison
		ll1 = RasLinkedList.new
		ll1.add(1,2,3)
		ll1.verify(self)
		ll2 = RasLinkedList.new
		ll2.add(1,2,3)
		ll2.verify(self)
		assert_equal ll1, ll2, "LL test error: Equal linked lists didn't compare"
		ll2.add(0)
		refute_equal ll1, ll2, "LL test error: Inequal linked lists compared equal"
		assert_operator ll1, :<, ll2, "LL test error: First list should have compared less than second list"
		ll2.remove!(3)
		assert_operator ll2, :<, ll1, "LL test error: Second list should have compared less than first list"
		assert_operator RasLinkedList.new, :<, ll1, "LL test error: Empty list should have compared less than populated list"
	end

	def test_sorting
		ll = RasLinkedList.new
		ll.add(3,2,4,5,1)
		result = ll.sort
		result.verify(self, 5)
		assert_instance_of RasLinkedList, result, "LL test error: Sort should return a RasLinkedList type"
		compare = RasLinkedList.new
		compare.add(1,2,3,4,5)
		assert_equal result, compare, "LL test error: Sort didn't return a sorted version"
	end
end
