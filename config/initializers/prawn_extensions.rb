module Prawn
  class Document
    alias_method :orig_start_new_page, :start_new_page unless method_defined? :orig_start_new_page
 
    def run_before_new_page(&block)
      @run_before_new_page_blocks ||= Array.new
      @run_before_new_page_blocks <<  Proc.new(&block)
    end
 
    def run_after_new_page(&block)
      @run_after_new_page_blocks ||= Array.new
      @run_after_new_page_blocks <<  Proc.new(&block)
    end
 
    def start_new_page(options = {})
      run_blocks @run_before_new_page_blocks, options
      self.orig_start_new_page options
      run_blocks @run_after_new_page_blocks
    end
 
    protected
 
    def run_blocks(blocks, *args)
      return if !blocks || blocks.empty?
      blocks.each { |block| block.arity == 0 ? self.instance_eval(&block) : block.call(self, *args) }
    end
  end
end

#refer ogma/config/initializers/prawn_extensions.rb 
#https://www.bunkus.org/blog/2009/07/different-background-images-and-page-layouts-in-a-single-pdf-with-prawn/
#works for tables that automatically span into new pages (background), as 'color' must be called upon new page creation (note cursor position)
#http://inboxhealthinterns.blogspot.com/2014/07/using-prawn-to-dynamically-generate-pdfs.html
#calling 'color' after text/table already displayed, will cover text/table 
#sample usage - 'run_after_new_page' in ogma/app/pdf/appraisal_form_pdf.rb
