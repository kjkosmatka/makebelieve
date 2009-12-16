PROJECT_NAME = 'makebelieve'
CLASSES = ['variable','potential','network','graph','elimination','gibbs_inference','monkey_patches']

libpath = File.dirname(__FILE__)
classpath = File.join(libpath, PROJECT_NAME)

$:.unshift(classpath) unless
  $:.include?(classpath) || $:.include?(File.expand_path(classpath))

CLASSES.each do |classname|
  require classname
end
 
module Makebelieve
end