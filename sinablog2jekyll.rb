require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'time'
require 'stringex'


config = {
    :username => 'xuxiaoming8',   # 用户名
    :posts => './_posts',         # 生成markdown文件路径
    :post_ext => 'md',
    :post_layout => 'post'        # 文件模板
}
blog_urls = []  #所有博客文章url列表

blog_home_url = 'http://blog.sina.com.cn/'+config[:username]
doc = Nokogiri::HTML(open(blog_home_url))

puts "获取博客目录页..."
blog_dir_url = doc.css('.blognavInfo span')[1].css('a')[0]['href']
puts "博客目录页为:#{blog_dir_url}"

puts "正在获取博客文章列表..."
while blog_dir_url != ''
  doc_dir = Nokogiri::HTML(open(blog_dir_url))
  doc_dir.css('.atc_title').css('a').each do |link|
    blog_urls.push(link['href'])
    puts link['href']
  end
  #获取下一页的url
  begin
    blog_dir_url =doc_dir.css('.SG_pgnext a')[0]['href']
  rescue
    break
  end
end


puts "正在转换为jekyll markdown格式...."

if(not File.exist?(config[:posts]))
  Dir.mkdir(config[:posts])
end

blog_urls.each do |url|
  doc = Nokogiri::HTML(open(url))

  blog_title = doc.css('.titName')[0].content
  blog_time = doc.css('.time')[0].content.gsub(/[()]/,'').strip[0,10]

  nbsp = Nokogiri::HTML("&nbsp;").text
  blog_content = doc.css('.articalContent')[0].content.lstrip.gsub(/^#{nbsp}/,"")

  #blog_content = blog_content.gsub(/^\012/, "````")
  #blog_content = blog_content.gsub(/\012/, "  \012")
  #blog_content = blog_content.gsub(/````/, "\012")

  filename = File.join(config[:posts], "#{blog_time}-#{blog_title.to_url}.#{config[:post_ext]}")

  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: #{config[:post_layout]}"
    post.puts "title: \"#{blog_title}\""
    post.puts "---"
    post.puts "#{blog_content}"
    post.close
  end

end
