//
//  main.swift
//  PointerSample
//

typealias GetPointer = @convention(c) (UnsafeMutableRawPointer) -> UnsafeMutableRawPointer

protocol Parent: class {
	var value: String { get set }
}
protocol Child: class {
	var value: String { get set }
}

class P: Parent {
	var value: String
	var children: [Child]
	
	init(value: String) {
		self.value = value
		self.children = []
		
		print("Init P: \(self.value)")
	}
	
	deinit {
		print("Deinit P: \(self.value)")
	}
}

class C: Child {
	var value: String
	
	weak var parent: Parent?
	
	init(value: String, parent: Parent) {
		self.value = value
		self.parent = parent
		
		print("Init C: \(self.value)")
	}
	
	deinit {
		print("Deinit C: \(self.value)")
	}
}

func getChild(parent: Parent) -> Child {
	return C(value: "CHILD", parent: parent)
}

func getChildPointer(parentPointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
	let parent = parentPointer.assumingMemoryBound(to: Parent.self).pointee
	let child = getChild(parent: parent)
	let childPointer = UnsafeMutablePointer<Child>.allocate(capacity: 1)
	childPointer.initialize(to: child)
	parent.value = "Parent Changed"
	child.value = "Child Changed"
	return UnsafeMutableRawPointer(childPointer)
}

func load() {
	let parent = P(value: "PARENT")
	let parentPointer = UnsafeMutablePointer<Parent>.allocate(capacity: 1)
	parentPointer.initialize(to: parent)
	
	let getPointer: GetPointer = getChildPointer
	let childPointer = getPointer(parentPointer)
		.assumingMemoryBound(to: C.self)
	let child = childPointer.move()
	parent.children.append(child)
	childPointer.deallocate(capacity: 1)
	
	parentPointer.deinitialize()
	parentPointer.deallocate(capacity: 1)
	
	print("End: \(parent.value)")
	print("End: \(parent.children.map{$0.value})")
	print("End: \(child.value)")
}

load()
