require 'redwood'
require 'pry'
require 'awesome_print'

describe Redwood do
  let (:tree) { Redwood::Tree.new }

  it "instantiates" do
    expect(tree).to be_instance_of Redwood::Tree
  end

  it "finds nodes" do
    tree.add :child, :parent
    expect(tree.find(:parent).name).to eq(:parent)
    expect(tree.find(:child).name).to eq(:child)
  end

  it "adds a node" do
    tree.add :name
    expect(tree.root.name).to eq(:name)
  end

  it "adds a child node and a parent node" do
    tree.add :child, :parent
    expect(tree.root.name).to eq(:parent)
    expect(tree.root.children.first.name).to eq(:child)
  end

  it "finds an already existing parent node" do
    tree.add :child1, :parent
    tree.add :child2, :parent
    expect(tree.root.name).to eq(:parent)
    expect(tree.root.children.map(&:name)).to eq([:child1, :child2])
  end

  it "add a child to a non-existent parent node", focus: true do
    tree.add :a, :b
    tree.add :b, :c
    tree.add :d, :e
    tree.add :e, :b
    expect(tree.order).to eq([:c, :b, :a, :e, :d])
  end

  it "can create a new root" do
    tree.add :node1, :node2
    tree.add :node2, :node3
    expect(tree.order).to eq([:node3, :node2, :node1])
  end

  it "can create a child to a child" do
    tree.add :node1, :node2
    tree.add :node3, :node1
    expect(tree.order).to eq([:node2, :node1, :node3])
  end

  describe "ordered output" do
    it "can output in order" do
      tree.add :child, :parent
      expect(tree.order).to eq([:parent, :child])
    end

    it "can output in order a root with 2 children" do
      tree.add :child, :parent
      tree.add :child2, :parent
      expect(tree.order).to eq([:parent, :child, :child2])
    end
  end
end
