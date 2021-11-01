class GeneratePdfsController < ApplicationController
  before_action :set_language

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
      pdf_name = identification_number + "_combined.pdf"
      pdf.save pdf_name
      redirect_to "/" + @language + "/result/" + identification_number
    end
  end

  def result
    @identification_number = params[:identification_number].to_s
  end

  def download
    send_file(params[:identification_number].to_s + "_combined.pdf")
  end

  private
    def pdf_params
      params.permit(:filename_concated, :count_concated, :language, pdfs: [])
    end

    def set_language
      @language = pdf_params[:language]
      if @language == "ja"
        @other_language = "en"
        @logo = "PDF製本データくん"
        @footer = "© 2021 PDF製本データくん All Rights Reserved."
        @change_language_message = "Change the language of this website to English"
        @about_binded_data = "作成する製本データについて"
        @right_start = "右始まり"
        @left_start = "左始まり"
        @about_white_page_data = "挿入する白紙データについて"
        @vertical = "縦"
        @horizontal = "横"
        @a4 = "片面A4"
        @b5 = "片面B5(JIS)"
        @add_white_page =  "白紙を挿入する"
        @submit = "送信"
        @select_pdf_file = "PDFファイルを選択/またはここにPDFファイルをドロップ"
        @order_and_count = "各PDFファイルの並び順と連続結合回数"
        @download_binded_data = "製本データをダウンロード"
      elsif
        @other_language = "ja"
        @logo = "Mr.PDF Bookbinder"
        @footer = "© 2021 PDF製本データくん All Rights Reserved."
        @change_language_message = "このWebサイトの言語を日本語に変更する"
        @about_binded_data = "How do you bind PDF data?"
        @right_start = "Right start"
        @left_start = "Left start"
        @about_white_page_data = "How do you add white page?"
        @vertical = "vertical"
        @horizontal = "horizontal"
        @a4 = "A4 per side"
        @b5 = "B5(JIS) per side"
        @add_white_page =  "Add white page"
        @submit = "Submit"
        @select_pdf_file = "Select PDF file / drop PDF file here"
        @order_and_count = "How do you arrange PDF files / How many times do you join a PDF file in a row?"
        @download_binded_data = "Download binded PDF data"
      end
    end

end
