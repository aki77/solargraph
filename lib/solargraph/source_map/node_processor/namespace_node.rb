module Solargraph
  class SourceMap
    module NodeProcessor
      class NamespaceNode < Base
        def process
          sc = nil
          if node.type == :class and !node.children[1].nil?
            sc = unpack_name(node.children[1])
          end
          loc = get_node_location(node)
          nspin = Solargraph::Pin::Namespace.new(
            type: node.type,
            location: loc,
            closure: region.closure,
            name: unpack_name(node.children[0]),
            comments: comments_for(node),
            visibility: :public
          )
          pins.push nspin
          unless sc.nil?
            pins.push Pin::Reference::Superclass.new(
              location: loc,
              closure: pins.last,
              name: sc
            )
          end
          process_children region.update(closure: nspin, visibility: :public)
        end
      end
    end
  end
end
