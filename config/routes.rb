Rails.application.routes.draw do
  mount_roboto
  root 'generate_pdfs#root'
  get "/:language" => 'generate_pdfs#top'
  post '/:language/create' => 'generate_pdfs#create'
  get '/:language/create' => 'generate_pdfs#top'
  get '/:language/result/:identification_number' => 'generate_pdfs#result'
  get '/:language/download/:identification_number' => 'generate_pdfs#download'
end
