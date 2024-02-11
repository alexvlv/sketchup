#  $Id$
def get_instances(ents, instances = [])
  ents.each{|e|
    case e
    when Sketchup::Group
      get_instances(e.entities, instances)
    when Sketchup::ComponentInstance
	  inst=[]
      get_instances(e.definition.entities, inst)
	  instances<<e if inst == []
	  instances.push(*inst)
    end
  }
  instances
end

def dims(filter="", select=FALSE)
  mod = Sketchup.active_model
  sel = mod.selection
  #mod.selection.clear 
  if sel.empty?
    entities = mod.active_entities
  else
    entities = sel
  end
  sz = entities.size.to_s
  puts "entities:" + sz
  ents = get_instances(entities)
  if ents.empty?
    return "No component selected"
  end
  i = 0
  founds = []
  ents.each{|ent|
    defn = ent.definition
    name = defn.name
	next unless name.include?(filter)
    bbox = defn.bounds
    w = bbox.width.to_l.to_s
    h = bbox.height.to_l.to_s
    d = bbox.depth.to_l.to_s
    puts name + " " + w + " " + h + " " + d
    i += 1
	founds << ent
  }
  if select
    mod.selection.clear
	founds.each{|ent| mod.selection.add(ent)}
  end
  "#{i} found"
end
