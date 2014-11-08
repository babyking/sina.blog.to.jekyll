sina.blog.to.jekyll
===================

新浪博客转换至jekyll的markdown格式


## 配置

```ruby
config = {
    :username => 'xujinglei',   # 用户名
    :posts => './_posts',         # 生成markdown文件路径
    :post_ext => 'md',
    :post_layout => 'post'        # 文件模板
}
```

## 使用

```bash
ruby path/to/sinablog2jekyll.rb
```
