class GeneratePdfsController < ApplicationController
  def top
    begin
      File.delete("combined.pdf")
    rescue
      puts "-----combined.pdf does not exist-----"
    end
  end

  def create
    filename_array = params["filename_concated"].split(",")
    count_array = params["count_concated"].split(",")
    pdfs_file = params["pdfs_file"]
    pdf = CombinePDF.new
    if pdfs_file.nil?
      flash.now[:danger] = "1つ以上のPDFをアップロードしてください" # This message means that you must upload one or more files.
      render :top
    else
      for i in 0..pdfs_file.length-1
        uploaded_file = pdfs_file[i]
        begin
          File.binwrite("public/uploaded/#{uploaded_file.original_filename}", uploaded_file.read)
        rescue
          puts "-----error occured during saving pdf-----"
          puts pdfs_file[i]
        end
      end
      if params[:start] == "left"
        filename = params[:size] + "_" + params[:direction] + ".pdf"
        pdf << CombinePDF.load(Rails.root.join('public/addition', filename))
      end
      for i in 0..filename_array.length-1
        for k in 0..count_array[i].to_i-1
          if filename_array[i] == "白紙ページ" #"白紙ページ" means a white page nothing is writen on
            filename = params[:size] + "_" + params[:direction] + ".pdf"
            begin
              pdf << CombinePDF.load(Rails.root.join('public/addition', filename))
            rescue
              puts "-----error occured during combining white page pdf-----"
            end
          elsif
            begin
              pdf << CombinePDF.load(Rails.root.join('public/uploaded', filename_array[i]))
            rescue
              puts "-----error occured during combining #{filename_array[i]}-----"
            end
          end
        end
      end
      identification_number = rand(100000000000).to_s
      pdf.save identification_number + "_combined.pdf"
      Dir.glob("#{Rails.root}/public/uploaded/*") do |file|
        begin
          File.delete(file)
        end
      end
      redirect_to "/result/"+identification_number
    end
  end

  def result
    @identification_number = params[:identification_number]
  end

  def download
    send_file(params[:identification_number] + "_combined.pdf")
  end

  # private
  #   # Only allow a list of trusted parameters through.
  #   def permit_params
  #     params.permit(:filename_concated, :count_concated, :commit, pdfs: [])
  #   end
end
