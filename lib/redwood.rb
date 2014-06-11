require "redwood/version"

module Redwood
  class Tree
    attr_reader :root

    def add(child_name, parent_name=nil)
      child = find(child_name)
      if child
        new_root = child == @root && parent_name != nil
      else
        child = Node.new(child_name, [])
      end

      if parent_name == nil
        @root = child
      else
        parent = find(parent_name)
        if parent
          parent.children << child
        else
          parent = Node.new(parent_name, [child])
        end

        @root = parent if @root.nil? || new_root
      end
    end

    def find(name)
      @root.find(name) unless @root.nil?
    end

    def order
      @root.order
    end
  end

  Node = Struct.new :name, :children do
    def find(search_name)
      return self if name == search_name

      node = nil

      Array(children).each do |child|
        node = child.find(search_name)
        break if node
      end

      node
    end

    def order
      output = [name]

      Array(children).each do |child|
        output.concat child.order
      end

      output
    end
  end
end
