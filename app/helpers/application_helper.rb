module ApplicationHelper
    def full_title(page_title)
        base_title = "Proofly"
        if page_title.empty?
            base_title
            else
            "#{page_title}"
        end
    end
    def full_description(page_description)
        base_description = "Prooflyは、文章などを手軽に共有、販売できる、クリエイターとユーザーをつなぐプラットフォームです。ブログのように使うことも、文章の共有に使うことも、 コンテンツを販売することも自在に活用いただけます。"
        if base_description.empty?
            base_title
            else
            "#{base_description}"
        end
    end
end
