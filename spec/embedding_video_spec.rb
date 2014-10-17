# encoding: utf-8

require 'spec_helper'
require_relative "../lib/texttube/baby/embedding_video.rb"


module TextTube # for convenience
module Baby

	describe EmbeddingVideo do
		context "Given some text" do
			let(:content) { "[video_large[//youtu.be/1Xhdy9zBEws|Royksopp, Remind Me]]" }
			let(:expected) {
%q[<iframe title="YouTube video player" class="youtube-player" type="text/html" width="853" height="510" src="//www.youtube.com/embed/1Xhdy9zBEws" frameborder="0"></iframe>]
			}
			context "containing valid extended markdown for video" do
				context "with no options" do
					subject { EmbeddingVideo.run content }
					it { should_not be_nil }
					it { should be == expected }
				end
			end
			context "containing invalid extended markdown for video" do
				let(:content) { "video[a24.m4a|A24]]" }
				subject { EmbeddingVideo.run content }
				it { should_not be_nil }
				it { should_not be == expected }
				it { should == content }
			end
		end

	end # describe

end
end # for inconvenience
