require 'time'

class GeneratePdfsController < ApplicationController
  before_action :set_language

  def root
    # Japanese is the default language
    redirect_to "/ja"
  end

  def top

  end

  def create
    filename_array = pdf_params["filename_concated"].split(",")
    count_array = pdf_params["count_concated"].split(",")
    pdfs_file = pdf_params["pdfs_file"]
    whtie_page = pdf_params[:size] + "_" + pdf_params[:direction] + ".pdf"
    starting_side = pdf_params[:start]
    pdf = CombinePDF.new
    if pdfs_file.nil?
      flash.now[:danger] = "1つ以上のPDFをアップロードしてください" # This message means that you must upload one or more files.
      render :top
    else
      for i in 0..pdfs_file.length-1
        uploaded_file = pdfs_file[i]
        begin
          #File.binwrite("public/uploaded/#{uploaded_file.original_filename}", uploaded_file.read)
          File.binwrite(get_filepath("uploaded", uploaded_file.original_filename), uploaded_file.read)
        rescue
          puts "-----error occured during saving #{uploaded_file}-----"
        end
      end
      if starting_side == "left"
        pdf << CombinePDF.load(get_filepath("addition", white_page))
      end
      for i in 0..filename_array.length-1
        selected_file = filename_array[i]
        for k in 0..count_array[i].to_i-1
          if selected_file == "白紙ページ" #"白紙ページ" means a white page nothing is writen on
            begin
              pdf << CombinePDF.load(get_filepath("addition", white_page))
            rescue
              puts "-----error occured during combining white page pdf-----"
            end
          else
            begin
              pdf << CombinePDF.load(get_filepath("uploaded", selected_file))
            rescue
              puts "-----error occured during combining #{selected_file}-----"
            end
          end
        end
      end
      identification_number = Time.new.strftime("%Y%m%d%H%M%S%L")
      pdf_name = identification_number + "_combined.pdf"
      pdf.save get_filepath("created", pdf_name)
      redirect_to "/" + @language + "/result/" + identification_number
    end
  end

  def result
    @identification_number = pdf_params[:identification_number].to_s
  end

  def download
    pdf_name = pdf_params[:identification_number].to_s + "_combined.pdf"
    send_file(get_filepath("created", pdf_name))
  end

  private
    def pdf_params
      params.permit(:filename_concated, :count_concated, :identification_number, :language, :size, :direction, :start, pdfs_file: [])
    end

    def set_language
      @language = pdf_params[:language]
      if @language == "en"
        @other_language = "ja"
        @logo = "Mr.PDF Bookbinder"
        @footer = "© 2021 PDF製本データくん All Rights Reserved."
        @change_language_message = "このWebサイトの言語を日本語に変更する"
        @about_binded_data = "How do you bind PDF data?"
        @right_start = "Right start"
        @left_start = "Left start"
        @about_white_page_data = "How do you add white page?"
        @vertical = "Vertical"
        @horizontal = "Horizontal"
        @a4 = "A4 per side"
        @b5 = "B5(JIS) per side"
        @add_white_page =  "Add a white page"
        @submit = "Submit"
        @select_pdf_file = "Select PDF files / drop PDF files here"
        @order_and_count = "How do you arrange PDF files / How many times do you join a PDF file in a row?"
        @download_binded_data = "Download binded PDF data"
      elsif
        @language = "ja"
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
      end
    end

    def get_filepath(directory, filename)
      Rails.root.join('public', directory, filename)
    end
end