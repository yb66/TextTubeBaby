# encoding: utf-8

require 'spec_helper'
require_relative "../lib/texttube/baby/link_reffing.rb"

module TextTube
module Baby # convience

  describe LinkReffing do
    context "Given some text" do
      context "With a link to be reffed in it" do
        shared_examples "outputting links" do
          it { should_not be_nil }
          it { should == expected }
        end

        context "And markdown" do          
          require 'rdiscount'
          let(:content) { <<CONTENT
# Some Example Links #

Example1[[http://example.org/abc/1234.5678|Example1 link]].

Example2[[http://example.com/ABC/0.1.2.3|Example2 link]].
CONTENT
          }
          let(:expected){<<HTML
<h1>Some Example Links</h1>

<p>Example1<a href="#0" title="Jump to reference">&#8304;</a>.</p>

<p>Example2<a href="#1" title="Jump to reference">&sup1;</a>.</p>

<div markdown='1' id='reflinks'>
<a name="0"></a>&#91;0&#93; [http://example.org/abc/1234.5678](http://example.org/abc/1234.5678 "http://example.org/abc/1234.5678") Example1 link


<a name="1"></a>&#91;1&#93; [http://example.com/ABC/0.1.2.3](http://example.com/ABC/0.1.2.3 "http://example.com/ABC/0.1.2.3") Example2 link

</div>

HTML
          }
          subject {
            text = TextTube::Baby::LinkReffing.run content
            RDiscount.new(text).to_html
          }
          include_examples "outputting links"
        end # context

        context "Given blah" do

          let(:content) { "The UtterFAIL website[[http://utterfail.info|UtterFAIL!]] is good. My blog[[http://iainbarnett.me.uk|My blog]] is also good." }

          context "and no options" do
            subject { TextTube::Baby::LinkReffing.run content }
            let(:expected) { s = <<HTML
The UtterFAIL website[&#8304;](#0 "Jump to reference") is good. My blog[&sup1;](#1 "Jump to reference") is also good.
<div markdown='1' id='reflinks'>
<a name="0"></a>&#91;0&#93; [http://utterfail.info](http://utterfail.info "http://utterfail.info") UtterFAIL!


<a name="1"></a>&#91;1&#93; [http://iainbarnett.me.uk](http://iainbarnett.me.uk "http://iainbarnett.me.uk") My blog

</div>
HTML
              s.strip
            }
            include_examples "outputting links"
          end
          context "and an option not to ref the link (i.e. inline)" do
            let(:expected) {
              "The UtterFAIL website [UtterFAIL!](http://utterfail.info) is good. My blog [My blog](http://iainbarnett.me.uk) is also good."
            }
            subject {
              TextTube::Baby::LinkReffing.run content, kind: :inline
            }
            include_examples "outputting links"
            context "and use HTML" do
              let(:expected) {
                %Q$The UtterFAIL website <a href="http://utterfail.info">UtterFAIL!</a> is good. My blog <a href="http://iainbarnett.me.uk">My blog</a> is also good.$
              }
              subject {
                TextTube::Baby::LinkReffing.run content, kind: :inline, format: :html
              }
              include_examples "outputting links"
            end
          end
          context "and an option to output a link as HTML" do
            let(:expected) { s = <<HTML
The UtterFAIL website<a href="#0" title="Jump to reference">&#8304;</a> is good. My blog<a href="#1" title="Jump to reference">&sup1;</a> is also good.
<div markdown='1' id='reflinks'>
<a name="0"></a>&#91;0&#93; [http://utterfail.info](http://utterfail.info "http://utterfail.info") UtterFAIL!


<a name="1"></a>&#91;1&#93; [http://iainbarnett.me.uk](http://iainbarnett.me.uk "http://iainbarnett.me.uk") My blog

</div>
HTML
          s.strip
        }
            subject { TextTube::Baby::LinkReffing.run content, format: :html }
            include_examples "outputting links"
          end
          context "and an option to not show the link at all" do
            let(:expected) { s = <<HTML
The UtterFAIL website is good. My blog is also good.
HTML
              s.strip
            }
            subject {
              TextTube::Baby::LinkReffing.run content, kind: :none
            }
            include_examples "outputting links"
          end
      
          context "With no link to be reffed in it" do
            let(:content) { %Q$The [UtterFAIL website](http://utterfail.info/ "UtterFAIL!") is good.$ }
            let(:expected) { content }
            subject { TextTube::Baby::LinkReffing.run content }
            it { should_not be_nil }
            it { should == expected }
          end # context
        end # context blah
      end
    end # context
    
    context "Given no text" do
      subject { TextTube::Baby::LinkReffing.run "" }
      it { should_not be_nil }
      it { should == "" }
    end # context
    
  end # describe LinkReffing

end #convenience
end # module 