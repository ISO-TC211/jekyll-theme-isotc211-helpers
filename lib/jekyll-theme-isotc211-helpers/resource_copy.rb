# Copies resource contents as is to site destination, bypassing Jekyll’s conversion

Jekyll::Hooks.register :site, :post_write do |site|
  if site.config.key?('resource_listings')
    site.config['resource_listings'].each do |listing_id, cfg|
      copy_resource_contents(cfg, site.config['destination'])
    end
  end
end

def copy_resource_contents(resource_cfg, site_dest)
  FileUtils.cp_r("#{resource_cfg['resource_root']}/.", "#{site_dest}/#{resource_cfg['index_url']}")
end
