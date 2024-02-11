### v1.1 prefix and/or suffix
### Usage:
###  banding "prefix-" [or banding "prefix-","" or banding "prefix-",nil] adds a prefix
###  banding "","-suffix" [or banding nil,"-suffix"] adds a suffix
###  banding "prefix-","-suffix" adds asuffix and a prefix
###
def banding(prefix="",suffix="")
  prefix=prefix.to_s
  suffix=suffix.to_s
  model=Sketchup.active_model
  model.start_operation("banding +"+prefix+"/"+suffix)
  ss=model.selection
  defs=[]
  ss.each{|e|
    if e.class==Sketchup::ComponentInstance
      defs<<e.definition if not defs.include?(e.definition)
    end#if
  }
  defnames=[]
  defs.each{|d|
    d.name=prefix+d.name+suffix
    defnames<<d.name
  }
  defnames.each{|n|puts n}
  puts "Processed "+defs.length.to_s+" Component Definitions"
  puts ""
  model.commit_operation
end#def

# Based on: Mass rename components
# https://sketchucation.com/forums/viewtopic.php?f=180&t=23617
