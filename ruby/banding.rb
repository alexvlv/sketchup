### v1.1 prefix and/or suffix
### Usage:
###  banding "prefix-" [or banding "prefix-","" or banding "prefix-",nil] adds a prefix
###  banding "","-suffix" [or banding nil,"-suffix"] adds a suffix
###  banding "prefix-","-suffix" adds asuffix and a prefix
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

def banding(prefix="",suffix="",filter="")
  prefix=prefix.to_s
  suffix=suffix.to_s
  model=Sketchup.active_model
  model.start_operation("banding +"+prefix+"/"+suffix)
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
    newname = prefix+name+suffix
    puts name + " => " + newname
	defn.name = newname
    i += 1
  }
  model.commit_operation
  "Processed #{i} component definitions"
end#def

  # defs=[]
  # ss.each{|e|
    # if e.class==Sketchup::ComponentInstance
      # defs<<e.definition if not defs.include?(e.definition)
    # end#if
  # }
  #defnames.each{|n|puts n}
  
# Based on: Mass rename components
# https://sketchucation.com/forums/viewtopic.php?f=180&t=23617
