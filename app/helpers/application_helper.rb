module ApplicationHelper
  def default_meta_tags
    {
      site: "PDF製本データくん",
      title: "PDFを結合して製本データを作成する",
      reverse: true,
      charset: 'utf-8',
      description: "PDF製本データくんは好きなだけPDFを結合して、製本データを作成することができます。",
      keywords: "pdf,製本,bookbinding,結合,merge,データ,data",
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :discription,
        type: 'website',
        url: request.original_url,
        locale: 'ja_JP',
      }
    }
  end
end
