# TextTubeBaby

Here are some ready built filters to use with TextTube. If you write any you think would be useful, send me a pull request!

### Note! ###

If you're having a problem with the TextTube::InsideBlock filter on Heroku it could be because of the version of Libxml2 it uses, as [the problem given here states](http://stackoverflow.com/q/8598958/335847), which means Nokogiri won't always work properly on Heroku. When using the InsideBlock filter this can be a problem, so use the `hpricot` branch instead.

### Note! Note!! ###

Because of the problems with Nokogiri, from v6.0.0 it's been replaced by [Oga](https://github.com/YorickPeterse/oga). If you want alternatives then look in the source for the other versions, or someone could be helpful and send in a plugin with [Ox](https://github.com/ohler55/ox) or some other parser doing the work :)

## Installation

Add this line to your application's Gemfile:

```sh
gem 'texttube_baby'
```

And then execute:

```sh
$ bundle install
```

though I'm a fan of sandboxing my gems, so:

```sh
$ bundle install --binstubs --path vendor.noindex
```

(the .noindex stops OSX Spotlight indexing it, that's just my little tip to you;)

Or install it yourself as:

```sh
$ gem install texttube_baby
```

## The Filters! ##

### LinkReffing ###

If you'd don't want your links inline and would prefer to have them at the bottom of the document, then you can use this:

```ruby
require 'texttube/base'
require 'texttube/baby/link_reffing'

class TextWithLinks < TextTube::Base
  register TextTube::Baby::LinkReffing
end

s = TextWithLinks.new %q!Iain's blog[[http://iainbarnett.me.uk|My blog]] is good. Erik Hollensbe's blog[[http://erik.hollensbe.org/|Holistic Engineering]] is also good, as is James Coglan's blog[[http://blog.jcoglan.com/|The If Works]]!

s.filter
```

and it will produce this:

```
# => "Iain's blog[&#8304;](#0 "Jump to reference") is good. Erik Hollensbe's blog[&sup1;](#1 "Jump to reference") is also good, as is James Coglan's blog[&sup2;](#2 "Jump to reference")\n<div markdown='1' id='reflinks'>\n<a name="0"></a>&#91;0&#93; [http://iainbarnett.me.uk](http://iainbarnett.me.uk "http://iainbarnett.me.uk") My blog\n\n\n<a name="1"></a>&#91;1&#93; [http://erik.hollensbe.org/](http://erik.hollensbe.org/ "http://erik.hollensbe.org/") Holistic Engineering\n\n\n<a name="2"></a>&#91;2&#93; [http://blog.jcoglan.com/](http://blog.jcoglan.com/ "http://blog.jcoglan.com/") The If Works\n\n</div>"
```

Run that through a markdown parser and you get:

```html
<p>Iain's blog<a href="#0" title="Jump to reference">&#8304;</a> is good. Erik Hollensbe's blog<a href="#1" title="Jump to reference">&sup1;</a> is also good, as is James Coglan's blog<a href="#2" title="Jump to reference">&sup2;</a></p>

<div markdown='1' id='reflinks'>
<a name="0"></a>&#91;0&#93; [http://iainbarnett.me.uk](http://iainbarnett.me.uk "http://iainbarnett.me.uk") My blog


<a name="1"></a>&#91;1&#93; [http://erik.hollensbe.org/](http://erik.hollensbe.org/ "http://erik.hollensbe.org/") Holistic Engineering


<a name="2"></a>&#91;2&#93; [http://blog.jcoglan.com/](http://blog.jcoglan.com/ "http://blog.jcoglan.com/") The If Works

</div>
```

Using this will probably end up with also using InsideBlock, to transform the markdown inside the div.

### InsideBlock ###

Sometimes it'd be useful to wrap some markdown with HTML, for example:

```
<div id="notes">

* first
* second
* third

</div>
```

If you put this through a markdown parser the markdown won't get parsed:

```ruby
require 'rdiscount'
s = "<div id="notes">\n\n* first\n* second\n* third\n\n</div>\n"
puts RDiscount.new(s).to_html
```

This is the output:

```
<div id="notes">

* first
* second
* third

</div>
```

My brilliant idea to get around this is to add an HTML attribute of `markdown='1'` to HTML tags that you want the markdown parser to look inside:

```
<div id="notes" markdown='1'>

* first
* second
* third

</div>
```

Trying this with `InsideBlock` gives:

```ruby
    puts TextTube::Baby::InsideBlock.run s
```

```
<div id="notes">
<ul>
<li>first</li>
<li>second</li>
<li>third</li>
</ul>

</div>
```

To use it as a filter:

```ruby
require 'texttube/base'

class MyFilter < TextTube::Baby::Base
  register TextTube::Baby::InsideBlock
end

myf = MyFilter.new(s)
# => "<div id="notes" markdown='1'>\n\n* first\n* second\n* third\n\n</div>\n"

puts myf.filter
```

Gives:

```
<div id="notes">
<ul>
<li>first</li>
<li>second</li>
<li>third</li>
</ul>

</div>
```

### Coderay ###

Filters an HTML code block and marks it up with [coderay](http://coderay.rubychan.de/):


```ruby
require 'texttube/base'
require 'texttube/baby/coderay'
require 'rdiscount' # a markdown parser

class TextWithCode < TextTube::Baby::Base
  register do
    filter_with :rdiscount do |text|
      RDiscount.new(text).to_html
    end
  end
  register TextTube::Baby::Coderay
end

s = TextWithCode.new <<'STR'
# FizzBuzz #

    ::::ruby
    (1..100).each do |n| 
      out = "#{n}: "
      out << "Fizz" if n % 3 == 0
      out << "Buzz" if n % 5 == 0
      puts out
    end

That's all folks!
STR
# => "# FizzBuzz #\n\n    ::::ruby\n    (1..100).each do |n| \n      out = "\#{n}: "\n      out << "Fizz" if n % 3 == 0\n      out << "Buzz" if n % 5 == 0\n      puts out\n    end\n\nThat's all folks!\n"


puts s.filter
```

Produces:

```
<h1>FizzBuzz</h1>

<pre><code class="CodeRay">(<span class="integer">1</span>..<span class="integer">100</span>).each <span class="keyword">do</span> |n| 
  out = <span class="string"><span class="delimiter">"</span><span class="inline"><span class="inline-delimiter">#{</span>n<span class="inline-delimiter">}</span></span><span class="content">: </span><span class="delimiter">"</span></span>
  out &lt;&lt; <span class="string"><span class="delimiter">"</span><span class="content">Fizz</span><span class="delimiter">"</span></span> <span class="keyword">if</span> n % <span class="integer">3</span> == <span class="integer">0</span>
  out &lt;&lt; <span class="string"><span class="delimiter">"</span><span class="content">Buzz</span><span class="delimiter">"</span></span> <span class="keyword">if</span> n % <span class="integer">5</span> == <span class="integer">0</span>
  puts out
<span class="keyword">end</span></code></pre>

<p>That's all folks!</p>
```

The language was specified with a leading `::::ruby`. It didn't have to be as the default is to use Ruby, but if you want to use any other of the [coderay supported languages](http://coderay.rubychan.de/doc/CodeRay/Scanners.html), that's how to do it.

### Spiffing ###

Transforms CSS written in British English into its ugly sister from across the pond. Inspired by [visualidiot's SpiffingCSS](https://github.com/visualidiot/Spiffing).

```ruby
content = <<CSS
  body {
    background-colour: darkgrey;
    background-photograph: url(logo.gif);
    transparency: .7;
  
    font: 72px "Comic Sans", cursive !please;
    font-weight: plump;
    p { text-align: centre }
    fieldset input {
      text-transform: capitalise;
    }
  }
CSS

require 'texttube/base'
require 'texttube/baby/spiffing'

class CssString < TextTube::Base
  register TextTube::Baby::Spiffing
end

puts CssString.new(content).filter
```

# output:

```css
body {
  background-color: darkgray;
  background-image: url(logo.gif);
  opacity: .7;

  font: 72px "Comic Sans", cursive !important;
  font-weight: bold;
  p { text-align: center }
  fieldset input {
    text-transform: capitalize;
  }
}
```

God save the Queen!


## Contributing

1. Fork it ( https://github.com/[my-github-username]/TextTubeBaby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
