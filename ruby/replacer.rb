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

def replacer(old,new="",filter="")
  old=old.to_s
  new=new.to_s
  model=Sketchup.active_model
  entities=model.selection
  sz = entities.size.to_s
  puts "Entities:" + sz
  ents = get_instances(entities)
  if ents.empty?
    return "No component selected"
  end
  model.start_operation("Change definition names", true)
  i = 0
  ents.each{|ent|
    defn = ent.definition
    name = defn.name
	next unless name.include?(filter)
	next unless name.include?(old)
    newname = name.sub(old,new)
    puts name + " => " + newname
	defn.name = newname
    i += 1
  }
  model.commit_operation
  "Processed #{i} component definitions"
end#def
