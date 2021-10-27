Rails.application.routes.draw do
  root 'generate_pdfs#top'
  get 'result' => 'generate_pdfs#result'
end
