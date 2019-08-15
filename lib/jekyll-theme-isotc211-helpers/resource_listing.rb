require 'pathname'

module Jekyll

  class ResourceReader < Generator
    safe true
    priority :high

    def generate(site)
      site.generate_resource_pages
    end
  end

  class ResourceListingPage < Page
    def initialize(site, base_dir, url, layout, header, resources)
      @site = site
      @base = base_dir
      @dir = url
      @name = "index.html"

      self.process(@name)

      self.data = {
        'layout' => layout || 'resource-index',
        'title' => header,
        'resources' => resources,
      }
    end
  end

  class ResourcePage < Page
    def initialize(site, base_dir, index_url, index_label, layout, id, label, contents_tree)
      @site = site
      @base = base_dir
      @dir = File.join(index_url, id)
      @name = "index.html"

      self.process(@name)

      self.data = {
        'layout' => layout || 'resource-page',
        'title' => "#{label.capitalize} #{id}",
        'parent_title' => index_label,
        'parent_link' => "/#{index_url}",
        'contents' => contents_tree,
      }
    end
  end

  class Site

    def write_resource_listing_page(listing_id, resources)
      cfg = self.config['resource_listings'][listing_id]

      self.pages << ResourceListingPage.new(
        self,
        self.source,
        cfg['index_url'],
        cfg['index_layout'],
        cfg['index_title'],
        resources)
    end

    def write_resource_page(listing_id, resource_id, contents_tree)
      cfg = self.config['resource_listings'][listing_id]

      self.pages << ResourcePage.new(
        self,
        self.source,
        cfg['index_url'],
        cfg['index_title'],
        cfg['resource_layout'],
        resource_id,
        cfg['resource_label'],
        contents_tree)
    end

    def read_resource_contents(dir, id, listing_id)
      cfg = self.config['resource_listings'][listing_id]
      return directory_hash(dir, "#{cfg['resource_label'].capitalize} #{id}")
    end

    def generate_resource_pages
      if self.config.key?('resource_listings')

        self.config['resource_listings'].each do |listing_id, cfg|
          resources = {}

          Pathname(cfg['resource_root']).children.each do |resource_dir|
            basename = File.basename(resource_dir)
            if basename[0] == '.'
              # Ignore dot-directories
              next
            end

            id = basename
            resources[id] = {}  # Empty hash can in future be resource metadata
            contents = self.read_resource_contents(resource_dir.to_s, id, listing_id)
            self.write_resource_page(listing_id, id, contents)
          end

          self.write_resource_listing_page(listing_id, resources)
        end

      end
    end

  end

end


def directory_hash(path, name=nil, level=0)
  data = {
    'data' => (name || path),
    'full_path' => path,
    'level' => level,
  }
  data['children'] = children = []

  # Increment nesting indicator
  level += 1

  Dir.foreach(path) do |entry|
    next if (entry == '..' || entry == '.')

    full_path = File.join(path, entry)

    if File.directory?(full_path)
      children << directory_hash(full_path, entry, level=level)
    else
      children << {
        'data' => entry,
        'full_path' => full_path,
        'level' => level,
      }
    end
  end

  return data
end
