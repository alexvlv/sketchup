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

def dims(filter="")
  mod = Sketchup.active_model
  sel = mod.selection
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
  }
  "#{i} found"
end
