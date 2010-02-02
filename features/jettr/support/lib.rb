LIB_DIR = File.join(File.dirname(__FILE__),'..','..','lib')
$:.unshift(File.expand_path(LIB_DIR)) unless
  $:.include?(LIB_DIR) || $:.include?(File.expand_path(LIB_DIR))