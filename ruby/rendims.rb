###
###  $Id$
###
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

def rendims(prefix="",suffix="",filter="")
  prefix=prefix.to_s
  suffix=suffix.to_s
  model=Sketchup.active_model
  model.start_operation("rendims +"+prefix+"/"+suffix)
  entities=model.selection
  sz = entities.size.to_s
  puts "Entities:" + sz
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
	dimensions = [bbox.width.to_mm.round, bbox.height.to_mm.round, bbox.depth.to_mm.round]
	dimensions.sort!
    newname = "#{prefix}#{dimensions[1]}х#{dimensions[0]}х#{dimensions[2]}#{suffix}"
    puts name + " => " + newname
	defn.name = newname
    i += 1
  }
  model.commit_operation
  "Processed #{i} component definitions"
end#def
