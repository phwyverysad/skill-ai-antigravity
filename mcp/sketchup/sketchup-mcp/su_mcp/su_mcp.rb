require 'sketchup.rb'
require 'extensions.rb'

File.open('C:/Users/woran/sketchup_mcp_debug.log', 'a') { |f| f.puts('su_mcp.rb loaded'); f.flush } rescue nil

module SU_MCP
  unless file_loaded?(__FILE__)
    ext = SketchupExtension.new('Sketchup MCP Server', 'su_mcp/main')
    ext.description = 'Model Context Protocol server for Sketchup'
    ext.version     = '1.5.0'
    ext.copyright   = '2024'
    ext.creator     = 'MCP Team'
    
    Sketchup.register_extension(ext, true)
    File.open('C:/Users/woran/sketchup_mcp_debug.log', 'a') { |f| f.puts("Extension registered, load_error=#{ext.load_error}"); f.flush } rescue nil
    
    file_loaded(__FILE__)
  end
end