Rails.application.routes.draw do
  root 'generate_pdfs#top'
  post 'create' => 'generate_pdfs#create'
  get 'create' => 'generate_pdfs#top'
  get 'result/:identification_number' => 'generate_pdfs#result'
  get 'download/:identification_number' => 'generate_pdfs#download'
end
