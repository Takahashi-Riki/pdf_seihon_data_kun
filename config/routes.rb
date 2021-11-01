Rails.application.routes.draw do
  #root 'generate_pdfs#top'
  get "/:language" => 'generate_pdfs#top'
  post '/:language/create' => 'generate_pdfs#create'
  get '/:language/create' => 'generate_pdfs#top'
  get '/:language/result/:identification_number' => 'generate_pdfs#result'
  get '/:language/download/:identification_number' => 'generate_pdfs#download'
end
