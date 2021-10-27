class GeneratePdfsController < ApplicationController
  def top
  end

  def result
    filename_array = params["filename_concated"].split(",")
    count_array = params["count_concated"].split(",")
    # for i in 0..filename_array.length
    #   uploaded_file = params["pdfs"][i]
    #   output_path = Rails.root.join('public', uploaded_file)
    #   File.open(output_path, 'w+b') do |fp|
    #     fp.write  uploaded_file.read
    #   end
    # end
    pdf = CombinePDF.new
    for i in 0..filename_array.length
      for k in 1..count_array[i].to_i
        pdf << CombinePDF.load(params["pdfs"][i].read)
        #pdf << CombinePDF.load(File.read(params["pdfs"][i]))
      end
    end
    pdf.save "combined.pdf"
  end

  private
    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:generate_pdf).permit(:pdfs, :filename_concated, :count_concated)
    end
end
