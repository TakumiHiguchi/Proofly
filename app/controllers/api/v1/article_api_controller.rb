module Api
    module V1
        class ArticleApiController < ApplicationController
          skip_before_action :verify_authenticity_token
          def index
              
              
              result = []
              #修正: 下書きの非表示を行う
              datas = UserDetail.joins(:articles).select("user_details.*,articles.*").order("articles.created_at DESC").search(params[:query],"api").userSort(params[:ukey])
              datas = datas.limit(params[:per]) if params[:per]
              
              datas.each do |pass|
                 ins=[]
                 ins.push(
                          title:pass.title,
                          user_name:pass.name,
                          user_key:pass.user_key,
                          article_key:pass.key,
                          description:pass.description,
                          thumbnail:pass.thum
                          )
                          
                 result.push(ins)
              end

              render json: JSON.pretty_generate({
                                                status: 'SUCCESS',
                                                api_version: 'v1',
                                                data_count: datas.length,
                                                articles:result
                                                
                                                })
          end
        end
    end
end
