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

<p>Example1<a class="ref" id="ref-0" href="#reflink-0" title="Jump to reference"><sup>0</sup></a>.</p>

<p>Example2<a class="ref" id="ref-1" href="#reflink-1" title="Jump to reference"><sup>1</sup></a>.</p>

<div markdown='1' id='reflinks'><p class="reflink" name="reflink-0" id="reflink-0"><a class="reflink ref"href="#ref-0" title="back up">[0]</a> <a class="reflink" href="http://example.org/abc/1234.5678" title="http://example.org/abc/1234.5678">http://example.org/abc/1234.5678</a> Example1 link</p><p class="reflink" name="reflink-1" id="reflink-1"><a class="reflink ref"href="#ref-1" title="back up">[1]</a> <a class="reflink" href="http://example.com/ABC/0.1.2.3" title="http://example.com/ABC/0.1.2.3">http://example.com/ABC/0.1.2.3</a> Example2 link</p></div>

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
The UtterFAIL website<a class="ref" id="ref-0" href="#reflink-0" title="Jump to reference"><sup>0</sup></a> is good. My blog<a class="ref" id="ref-1" href="#reflink-1" title="Jump to reference"><sup>1</sup></a> is also good.
<div markdown='1' id='reflinks'><p class="reflink" name="reflink-0" id="reflink-0"><a class="reflink ref"href="#ref-0" title="back up">[0]</a> <a class="reflink" href="http://utterfail.info" title="http://utterfail.info">http://utterfail.info</a> UtterFAIL!</p><p class="reflink" name="reflink-1" id="reflink-1"><a class="reflink ref"href="#ref-1" title="back up">[1]</a> <a class="reflink" href="http://iainbarnett.me.uk" title="http://iainbarnett.me.uk">http://iainbarnett.me.uk</a> My blog</p></div>
HTML
              s.strip
            }
            include_examples "outputting links"
          end
          context "and an option not to ref the link (i.e. inline)" do
            let(:expected) {
                %Q$The UtterFAIL website <a class="ref" href="http://utterfail.info">UtterFAIL!</a> is good. My blog <a class="ref" href="http://iainbarnett.me.uk">My blog</a> is also good.$
            }
            subject {
              TextTube::Baby::LinkReffing.run content, kind: :inline
            }
            include_examples "outputting links"
            context "and use markdown" do
              let(:expected) {
              "The UtterFAIL website [UtterFAIL!](http://utterfail.info) is good. My blog [My blog](http://iainbarnett.me.uk) is also good."
              }
              subject {
                TextTube::Baby::LinkReffing.run content, kind: :inline, format: :markdown
              }
              include_examples "outputting links"
            end
          end
          context "and an option to output a link as HTML" do
            let(:expected) { s = <<HTML
The UtterFAIL website<a class="ref" id="ref-0" href="#reflink-0" title="Jump to reference"><sup>0</sup></a> is good. My blog<a class="ref" id="ref-1" href="#reflink-1" title="Jump to reference"><sup>1</sup></a> is also good.
<div markdown='1' id='reflinks'><p class="reflink" name="reflink-0" id="reflink-0"><a class="reflink ref"href="#ref-0" title="back up">[0]</a> <a class="reflink" href="http://utterfail.info" title="http://utterfail.info">http://utterfail.info</a> UtterFAIL!</p><p class="reflink" name="reflink-1" id="reflink-1"><a class="reflink ref"href="#ref-1" title="back up">[1]</a> <a class="reflink" href="http://iainbarnett.me.uk" title="http://iainbarnett.me.uk">http://iainbarnett.me.uk</a> My blog</p></div>
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