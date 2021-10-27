class GeneratePdfsController < ApplicationController
  def top
    begin
      File.delete("combined.pdf")
    rescue
      puts "combined.pdfは存在しません"
    end
  end

  def create
    filename_array = params["filename_concated"].split(",")
    count_array = params["count_concated"].split(",")
    pdf = CombinePDF.new
    for i in 0..filename_array.length-1
      uploaded_file = params["pdfs_file"][i]
      begin
        File.binwrite("public/uploaded/#{uploaded_file.original_filename}", uploaded_file.read)
        for k in 1..count_array[i].to_i-1
          pdf << CombinePDF.load(Rails.root.join('public/uploaded', uploaded_file.original_filename))
        end
      rescue
        puts params["pdfs_file"][i]
      end
    end
    pdf.save "combined.pdf"
    # Dir.glob("#{Rails.root}/public/uploaded/*") do |file|
    #   begin
    #     File.delete(file)
    #   end
    # end
    redirect_to result_path
  end

  def result

  end

  def download
    send_file("combined.pdf")
  end

  # private
  #   # Only allow a list of trusted parameters through.
  #   def permit_params
  #     params.permit(:filename_concated, :count_concated, :commit, pdfs: [])
  #   end
end
