---
layout: post
title: "Welcome to My Blog"
date: 2025-05-15 21:00:00 +0000
categories: general
tags: introduction welcome
---

This is my first blog post. Jekyll makes it easy to create content using Markdown.

<!-- more -->

## What to Expect

In this blog, I'll be sharing my thoughts on [your topics of interest], projects I'm working on, and more.

## Code Snippets

Jekyll makes it easy to include code snippets:

```python
def hello_world():
    print("Hello, World!")
```

Stay tuned for more posts!

### Tag Pages Generator

Create `_plugins/tag_generator.rb`:

```ruby
module Jekyll
  class TagPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag'
        site.tags.each_key do |tag|
          site.pages << TagPage.new(site, site.source, File.join('writings', 'tags'), tag)
        end
      end
    end
  end

  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = "#{tag}.html"

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')
      self.data['tag'] = tag
      self.data['title'] = "Posts tagged with '#{tag}'"
    end
  end
end
```
