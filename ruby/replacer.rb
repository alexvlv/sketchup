def replacer (old,new="")
  mod = Sketchup.active_model
  sel = mod.selection
  if sel.empty?
    defins = mod.definitions
  else
    defins = sel.grep(Sketchup::ComponentInstance).map(&:definition).uniq
    return "No component selected" if defins == []
  end
  mod.start_operation("Change definition names", true)
  i = 0
  defins.each{|defin|
    next unless defin.name.include?(old)
    defin.name = defin.name.sub(old,new)
    i += 1
  }
  mod.commit_operation
  "#{i} changes"
end
