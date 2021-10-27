Rails.application.routes.draw do
  root 'generate_pdfs#top'
  post 'create' => 'generate_pdfs#create'
  get 'result' => 'generate_pdfs#result'
  get 'download' => 'generate_pdfs#download'
end
