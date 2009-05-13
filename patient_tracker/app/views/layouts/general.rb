class Views::Layouts::General < Erector::Widget
	def content
		html do
		  head do
			title "Nucats/Nubic eNOTIS - #{page_title}"
			css "default.css"
		  end	
		end

		body do
		 #self.ender_body
		end
	end

	def render_body

	end

end
